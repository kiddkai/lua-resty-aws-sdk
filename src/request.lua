local ngx = require 'ngx'
local signature = require 'signature'


local function build_query(opts)
    local queries = {}
    local keys = opts.query_keys
    local data = opts.query_data
    local key

    if keys then
        for i = 1, #keys do
            key = keys[i]
            if data[key] then
                table.insert(queries, { key, data[key] })
            end
        end
    end

    return queries
end



local function build_v4_headers(opts, queries)
    local content_type = opts.content_type
    local accept = content_type
    local method = opts.method
    local pathname = opts.pathname
    local cred = opts.cred
    local header_keys = opts.header_keys
    local header_data = opts.header_data
    local datetime = signature.amz_date()
    local date = string.sub(datetime, 1, 8)
    local headers = {}

    if header_keys then
        for i = 1, #header_keys do
            local k = header_keys[i]
            local low_k = string.lower(k)
            if low_k == 'x-amz-date' then
                table.insert(headers, { k, datetime })
            elseif low_k == 'host' then
                table.insert(headers, { k, opts.host })
            elseif low_k == 'x-amz-security-token' then
                if cred.session_token then
                    table.insert(headers, { k, cred.session_token })
                end
            elseif header_data[k] then
                table.insert(headers, { k, header_data[k] })
            end
        end
    end


    local canonical_str, signed_headers = signature.new_canonical_request(
      method,
      pathname,
      queries,
      headers,
      opts.body
    )

    local canonical_hash = signature.hash(canonical_str)
    local str_to_sign = signature.str_to_sign(canonical_hash, headers, opts.region, opts.service)
    local auth_header = signature.new_auth_header(cred, signed_headers, date, opts.region, opts.service, str_to_sign)

    table.insert(headers, { 'content-type', content_type })
    table.insert(headers, { 'accept', accept })
    table.insert(headers, { 'Authorization' , auth_header })

    return headers
end


local function build_headers(opts, queries)
    local signature_version = opts.signature_version

    if string.find(signature_version, 'v4') then
        return build_v4_headers(opts, queries)
    elseif string.find(signature_version, 's3') then
        error('not supporting s3 signature yet')
    end
end


local function query_to_str(queries)
    local len = #queries

    if len == 0 then
        return ''
    end

    local res = '?'
    local item
    for i = 1, len do
        item = queries[i]
        res = res .. tostring(item[1]) .. '=' .. ngx.escape_uri(item[2])

        if i < len then
            res = res .. '&'
        end
    end
    return res
end


local function request(opts)
    local queries = build_query(opts)
    local headers = build_headers(opts, queries)

    return {
        headers = headers,
        hostname = opts.host,
        port = 443,
        pathname = opts.pathname,
        method = opts.method,
        query = query_to_str(queries),
        body = opts.body
    }
end



return request

