local pp = require 'pl.pretty'
local dir = require 'pl.dir'
local file = require 'pl.file'
local path = require 'pl.path'
local stringx = require 'pl.stringx'
local signature = require 'src.signature'

local function parse_req(req)
    local lines = stringx.split(req, '\n')
    local method = stringx.split(lines[1], ' ')[1]
    local p = stringx.split(lines[1], ' ')[2]
    local queries = {}
    local headers = {}
    local body = {}
    local datetime
    local in_body = false

    if string.find(p, '?') then
        local segs = stringx.split(p, '?')
        local args = ngx.decode_args(segs[2])
        local ks = {}
        for k, v in pairs(args) do
            table.insert(ks, k)
        end
        table.sort(ks)
        for i, k in ipairs(ks) do
            queries[i] = { k, args[k] }
        end

        p = segs[1]
    end

    for i = 2, #lines do
        if in_body then
            table.insert(body, lines[i])
        elseif not string.find(lines[i], ":") then
            in_body = true
        else 
            if string.lower(stringx.split(lines[i], ':')[1]) == 'x-amz-date' then
                datetime = stringx.split(lines[i], ':')[2]
            end
            table.insert(headers, {
                stringx.split(lines[i], ':')[1],
                stringx.split(lines[i], ':')[2]
            })
        end
    end

    return {
        datetime = datetime,
        method = method,
        path = p,
        headers = headers,
        queries = queries,
        body = table.concat(body, '\n')
    }
end


local dirs = dir.getdirectories('./test/aws4_testsuite')
local tests = {}
local to_read = {
    { 'authz' },
    { 'creq' },
    { 'req', parse_req },
    { 'sreq' },
    { 'sts' }
}

for i = 1, #dirs do
    local base = dirs[i]
    local name = path.basename(dirs[i])
    local should_insert = false
    local test = {
        name = name
    }

    for j = 1, #to_read do
        local content = file.read(base .. '/' .. name .. '.' .. to_read[j][1])
        if content then
            should_insert = true
            if to_read[j][2] then
                content = to_read[j][2](content)
            end
            test[to_read[j][1]] = content
        end
    end

    if should_insert then
        table.insert(tests, test)
    end
end



describe('Signature v4', function()
    describe('canonical req', function()
        for i = 1, #tests do
            it('canonical ' .. tests[i].name, function ()
                local test = tests[i]
                local req = test.req
                local creq = test.creq
                assert.are.equal(signature.new_canonical_request(
                    req.method,
                    req.path,
                    req.queries,
                    req.headers,
                    req.body
                ), creq)
            end)
        end
    end)

    describe('string to sign', function()
        for i = 1, #tests do
            it('sts ' .. tests[i].name, function ()
                local test = tests[i]
                local req = test.req
                local creq = signature.new_canonical_request(
                    req.method,
                    req.path,
                    req.queries,
                    req.headers,
                    req.body
                )
                local chash = signature.hash(creq)
                local sts = signature.str_to_sign(chash, req.headers, 'us-east-1', 'service')
                assert.are.equal(sts, test.sts)
            end)
        end
    end)

    describe('create sign header', function()
        for i = 1, #tests do
            it('sts ' .. tests[i].name, function ()
                local test = tests[i]
                local req = test.req
                local creq = signature.new_canonical_request(
                    req.method,
                    req.path,
                    req.queries,
                    req.headers,
                    req.body
                )
                local chash = signature.hash(creq)
                local sts = signature.str_to_sign(chash, req.headers, 'us-east-1', 'service')
                assert.are.equal(sts, test.sts)
            end)
        end
    end)

    describe('auth header', function()
        for i = 1, #tests do
            it('authz ' .. tests[i].name, function ()
                local test = tests[i]
                local req = test.req
                local date = string.sub(req.datetime, 1, 8)
                local creq, signed_headers = signature.new_canonical_request(
                    req.method,
                    req.path,
                    req.queries,
                    req.headers,
                    req.body
                )
                local chash = signature.hash(creq)
                local sts = signature.str_to_sign(chash, req.headers, 'us-east-1', 'service')
                local authz = signature.new_auth_header({ key = 'AKIDEXAMPLE', secret = 'wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY' }, signed_headers, date, 'us-east-1', 'service', sts)
                assert.are.equal(authz, test.authz)
            end)
        end
    end)
end)

