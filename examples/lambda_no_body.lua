local lambda = require 'resty.aws.lambda'
local cred = require 'resty.aws.cred'
local json = require 'cjson'
local pp = require 'pl.pretty'
local http = require 'resty.http'

local c = cred.from_env()
local l = lambda:new("ap-southeast-2")
--local body = json.encode({
--  foo = 'bar'
--})
local body = ''

-- e30= is {} base64 encoded
local req = l:Invoke(c, {
    ['FunctionName'] = 'bs',
    ['X-Amz-Client-Context'] = 'e30='
}, body)

pp.dump(req)

local headers = {}
for _, h in pairs(req.headers) do
    headers[h[1]] = h[2]
end
local httpc = http.new()
httpc:set_timeout(500)
httpc:connect(req.hostname, req.port)
local sess, err = httpc:ssl_handshake()
local res, err = httpc:request({
    path = req.pathname .. req.query,
    method = req.method,
    body = '',
    headers = headers
})
if not res then
    print(err)
    return
end
local json = require 'cjson'
print(res:read_body())
