local ngx = require 'ngx'
local json = require 'cjson'
local lfs = require 'lfs'
local template = require 'pl.template'
local dir = require 'pl.dir'
local path = require 'pl.path'
local file = require 'pl.file'
local stringx = require 'pl.stringx'

local f, e = io.open(lfs.currentdir() .. '/botocore/botocore/data/endpoints.json')

if not f then
    print(e)
    return
end

local endpoints = json.decode(f:read('*a'))

f:close()

local partition = endpoints.partitions[1]

local function regions_for_service(name)
    local services = partition.services
    local service = services[name]
    local eps = service['endpoints']

    local regions = {}
    for region_name, _ in pairs(eps) do
        table.insert(regions, region_name)
    end

    return regions
end


local function merge(tbs)
    local target = {}
    local tb
    for i = 1, #tbs do
        tb = tbs[i]
        if tb then
            for k, v in pairs(tb) do
                target[k] = v
            end
        end
    end

    return target
end


local function find_prop(tbs, prop_name)
    local tb
    for i = 1, #tbs do
        tb = tbs[i]
        if tb[prop_name] then
            return tb[prop_name]
        end
    end
    return nil
end

local function endpoints_for_service(name)
    local services = partition.services
    local service = services[name]
    local eps = service['endpoints']

    local lines = {}
    local defaults
    for region_name, _ in pairs(eps) do
        defaults = merge({
            partition.defaults,
            service.defaults,
            endpoints[region_name]
        })

        local ep = ngx.re.gsub(defaults.hostname, '{([a-zA-Z]+)}', function(m)
            local res = find_prop({ { region = region_name, service = name }, eps[region_name], service, partition }, m[1])
            return res
        end)

        table.insert(lines,{ region_name, ep })
    end

    return lines
end



local function load_api_spec(name)
    local versions = dir.getdirectories(lfs.currentdir() .. '/botocore/botocore/data/' .. name)

    table.sort(versions, function (a, b)
        a = ngx.re.gsub(path.basename(a), '-', '')
        b = ngx.re.gsub(path.basename(b), '-', '')
        return tonumber(a) > tonumber(b)
    end)

    local spec = json.decode(file.read(versions[1] .. '/service-2.json'))

    return spec
end



local function parse_protocol(spec)
    local proto = spec.metadata.protocol
    if string.find(proto, 'json') then
        return 'application/json'
    elseif string.find(proto, 'xml') then
        return 'application/xml'
    else
        return 'application/xml'
    end
end

local pp = require 'pl.pretty'

local function build_uri(segements)
    local len = #segements
    local res = ""
    local in_str = false

    local seg
    if #segements == 0 then
        return "'/'"
    end
    for i = 1, len do
        seg = segements[i]
        if seg.type == 'text' then
            if in_str then
                if #seg.value then
                    res = res .. '/' .. seg.value
                end
            else
                if #seg.value then
                    if i > 1 then
                        res = res .. " .. "
                    end
                    res = res .. "'/" .. seg.value
                end
            end

            if i == len then
                res = res .. "'"
            end
            in_str = true
        elseif seg.type == 'var' then
            if in_str then
                res = res .. "/' .. " .. seg.value
            else
                if i == 1 then
                    res = res .. "'/' .. " .. seg.value
                else
                    res = res .. " .. '/' .. " ..  seg.value
                end
            end
            in_str = false
        elseif seg.type == 'query_action' then
            res = res .. " .. '?" .. seg.value .. "'"
        end
    end

    return  res
end



local function parse_uri(uri)
    local segs = stringx.split(uri,  '/')
    local res = {}
    local query_action
    local last = segs[#segs]

    if string.find(last, '?') then
        local sep = stringx.split(last, '?')
        segs[#segs] = sep[1]
        query_action = sep[2]
    end

    for i, seg in ipairs(segs) do
        if #seg > 0 then
            if string.find(seg, '{') then
                table.insert(res, { type = 'var', value = ngx.re.gsub(seg, '({|}|\\+)', '') })
            else
                table.insert(res, { type = 'text', value = seg })
            end
        end
    end

    if query_action then
        table.insert(res, { type = 'query_action', value = query_action })
    end

    return res
end


local function render_method(env)
    local tpl = file.read(lfs.currentdir() .. '/method_tpl.lua')
    return template.substitute(tpl, env)
end


local function render_spec(spec)
   local ops = spec.operations 
   local shapes = spec.shapes

   local input, shape
   local uri_params, queries, headers
   local blocks = {}
   for _, operation in pairs(ops) do
        uri_params = {}
        queries = {}
        headers = { "'X-Amz-Date'", "'Host'", "'X-Amz-Security-Token'" }
        input = operation.input

        local uri_exp = build_uri(parse_uri(operation.http.requestUri))

        if input and input.shape then
            shape = shapes[input.shape]

            if shape.type == 'structure' then
                for member_name, member_value in pairs(shape.members) do
                    if member_value.location == 'uri' then
                        table.insert(uri_params, member_name)
                    elseif member_value.location == 'querystring' then
                        table.insert(queries, "'" .. member_value.locationName .. "'")
                    elseif member_value.location == 'header' then
                        table.insert(headers,  "'" .. member_value.locationName .. "'")   
                    end
                end
            end
        end
        
        table.sort(queries)
        table.sort(headers)

        table.insert(blocks, render_method(merge({ _G, {
            NAME = operation.name,
            ARGS = table.concat({ 'cred', 'opts' }, ', '),
            URI = uri_exp,
            METHOD = operation.http.method,
            URI_PARAMS = uri_params,
            QUERIES = queries,
            HEADERS = headers,
            OK_RESPONSE_CODE = operation.http.responseCode,
        }})))
   end

   return table.concat(blocks, '\n\n\n')
end



local function render(name)
    local tpl_f = io.open(lfs.currentdir() .. '/tpl.lua')
    local tpl = tpl_f:read('*a')
    tpl_f:close()
    local spec = load_api_spec(name)

    local env = {
        API_VERSION = spec.metadata.apiVersion,
        SIGNATURE_VERSION = spec.metadata.signatureVersion,
        CONTENT_TYPE = parse_protocol(spec),
        NAME = name,
        REGIONS = regions_for_service(name),
        ENDPOINTS = endpoints_for_service(name),
        METHODS = render_spec(spec)
    }


    return template.substitute(tpl, merge({ _G, env }))
end


return render
