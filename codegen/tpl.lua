--
--- @module resty.aws.$(NAME)

local _M = {}
local http = require 'resty.http'
local request = require 'resty.aws.request'

local VERSION = '$(API_VERSION)'
local CONTENT_TYPE = '$(CONTENT_TYPE)'
local SIGNATURE_VERSION = '$(SIGNATURE_VERSION)'

local REGIONS = {
# for _, region in pairs(REGIONS) do
    ['$(region)'] = '$(region)',
# end
}

local ENDPOINTS = {
# for _, e in ipairs(ENDPOINTS) do
    ['$(e[1])'] = '$(e[2])',
# end
}

local mt = { __index = _M }

function _M.new(_, region)
    local r = string.lower(region or os.getenv('AWS_DEFAULT_REGION'))

    if not r then
        return nil, '[$(NAME)] region[' .. region .. '] is not available for this service'
    end

    return setmetatable({
        service = '$(NAME)',
        scope = region .. '/$(NAME)/aws4_request',
        host = REGIONS[r]
    }, mt)
end


$(METHODS)


return _M

