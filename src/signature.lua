local ngx = require 'ngx'
local sha256 = require 'resty.sha256'
local str = require 'resty.string'
local ffi = require "ffi"
local ffi_new = ffi.new
local ffi_str = ffi.string
local C = ffi.C

local ok, new_tab = pcall(require, "table.new")
if not ok then
    new_tab = function (narr, nrec) return {} end
end

local _M = {}

ffi.cdef [[
typedef struct env_md_st EVP_MD;
typedef struct env_md_ctx_st EVP_MD_CTX;
unsigned char *HMAC(const EVP_MD *evp_md, const void *key, int key_len,
            const unsigned char *d, size_t n, unsigned char *md,
            unsigned int *md_len);
const EVP_MD *EVP_sha256(void);
]]



local digest_len = ffi_new("int[?]", 64)
local buf = ffi_new("char[?]", 64)



local function hmac_sha256(key, msg)
    C.HMAC(C.EVP_sha256(), key, #key, msg, #msg, buf, digest_len)
    return ffi_str(buf, 32)
end


_M.hmac_sha256 = hmac_sha256



-- @see http://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
local function sha256_hex(payload)
    local hasher = sha256:new()
    hasher:update(payload)
    local hashed = hasher:final()
    return str.to_hex(hashed)
end


-- @see http://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
local function encode_headers(headers)
    local header, vidx
    local visited = {}
    local result = {}
    local sign_headers = {}
    for i = 1, #headers do
        header = headers[i]
        local header_name = string.lower(header[1])
        vidx = visited[header_name]
        if not vidx then
            table.insert(result, header_name .. ':' .. header[2])
            table.insert(sign_headers, header_name)
            visited[header_name] = #result
        else
            result[vidx] = result[vidx] .. ',' .. header[2]
        end
    end
    return table.concat(result, '\n') .. '\n', table.concat(sign_headers, ';')
end


-- @see http://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
local function encode_args(to_encode)
    local args = new_tab(#to_encode, 0)
    local arg
    local val
    for i = 1, #to_encode do
        arg = to_encode[i]
        val = ngx.escape_uri(arg[2] or '')
        -- escape_uri does not handling '$' correctly
        val = ngx.re.gsub(val, '\\$', '%24')
        args[i] = ngx.escape_uri(arg[1]) .. '=' .. val
    end
    return table.concat(args, '&')
end


-- @see http://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
local function canonical_req(method, uri, query, headers, payload)
    local encoded_headers, sign_headers = encode_headers(headers)
    local cstr = string.upper(method)    .. '\n' ..
                 uri                     .. '\n' ..
                 encode_args(query)      .. '\n' ..
                 encoded_headers         .. '\n' ..
                 sign_headers            .. '\n' ..
                 sha256_hex(payload)

    return cstr, sign_headers
end



_M.new_canonical_request = canonical_req
_M.hash = sha256_hex



-- @see http://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
local function amz_date()
    local date = ngx.re.gsub(ngx.utctime(), '(-|:)', '')

    return string.format('%sT%sZ',
                         string.sub(date, 1, 8),
                         string.sub(date, 10, string.len(date)))
end



-- @see http://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
local function date()
    local d = ngx.re.gsub(ngx.utctime(), '-', '')
    return string.sub(d, 1, 8)
end



_M.amz_date = amz_date
_M.date = date



local function string_to_sign(canonical_hash, headers, region, service)
    local amz_d

    for i = 1, #headers do
        if string.lower(headers[i][1]) == 'x-amz-date' then
            amz_d = headers[i][2]
        end
    end

    if not amz_d then
        amz_d = amz_date()
        table.insert(headers, { 'x-amz-date', amz_d })
    end

    return 'AWS4-HMAC-SHA256\n' ..
           amz_d .. '\n' ..
           string.sub(amz_d, 1, 8) .. '/' .. region .. '/' .. service .. '/aws4_request\n' ..
           canonical_hash
end



_M.str_to_sign = string_to_sign



local function derive_key(aws_secret, d, region, service)
    local ord = { region, service, 'aws4_request' }
    local len = #ord
    local k

    k = hmac_sha256('AWS4' .. aws_secret, d)

    for i=1, len do
        k = hmac_sha256(k, ord[i])
    end

    return k
end



function _M.new_signature(aws_secret, d, region, service, data)
    return str.to_hex(hmac_sha256(derive_key(aws_secret, d, region, service), data))
end



function _M.new_auth_header(cred, signed_headers, d, region, service, data)
    local signature = _M.new_signature(cred.secret, d, region, service, data)
    return 'AWS4-HMAC-SHA256 Credential=' .. cred.key .. '/' .. d .. '/' .. region .. '/' .. service .. '/aws4_request, SignedHeaders=' .. signed_headers .. ', Signature=' .. signature
end



return _M
