--
--- @module resty.aws.sns

local _M = {}
local http = require 'resty.http'
local request = require 'resty.aws.request'

local VERSION = '2010-03-31'
local CONTENT_TYPE = 'application/xml'
local SIGNATURE_VERSION = 'v4'

local REGIONS = {
    ['ap-southeast-1'] = 'ap-southeast-1',
    ['ap-northeast-2'] = 'ap-northeast-2',
    ['ap-northeast-1'] = 'ap-northeast-1',
    ['us-east-2'] = 'us-east-2',
    ['ap-south-1'] = 'ap-south-1',
    ['us-west-2'] = 'us-west-2',
    ['us-east-1'] = 'us-east-1',
    ['eu-central-1'] = 'eu-central-1',
    ['eu-west-1'] = 'eu-west-1',
    ['sa-east-1'] = 'sa-east-1',
    ['us-west-1'] = 'us-west-1',
    ['ap-southeast-2'] = 'ap-southeast-2',
}

local ENDPOINTS = {
    ['ap-southeast-1'] = 'sns.ap-southeast-1.amazonaws.com',
    ['ap-northeast-2'] = 'sns.ap-northeast-2.amazonaws.com',
    ['ap-northeast-1'] = 'sns.ap-northeast-1.amazonaws.com',
    ['us-east-2'] = 'sns.us-east-2.amazonaws.com',
    ['ap-south-1'] = 'sns.ap-south-1.amazonaws.com',
    ['us-west-2'] = 'sns.us-west-2.amazonaws.com',
    ['us-east-1'] = 'sns.us-east-1.amazonaws.com',
    ['eu-central-1'] = 'sns.eu-central-1.amazonaws.com',
    ['eu-west-1'] = 'sns.eu-west-1.amazonaws.com',
    ['sa-east-1'] = 'sns.sa-east-1.amazonaws.com',
    ['us-west-1'] = 'sns.us-west-1.amazonaws.com',
    ['ap-southeast-2'] = 'sns.ap-southeast-2.amazonaws.com',
}

local mt = { __index = _M }

function _M.new(_, region)
    local r = string.lower(region or os.getenv('AWS_DEFAULT_REGION'))

    if not r then
        return nil, '[sns] region[' .. region .. '] is not available for this service'
    end

    return setmetatable({
        service = 'sns',
        scope = region .. '/sns/aws4_request',
        host = REGIONS[r]
    }, mt)
end


local CONFIRMSUBSCRIPTION_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.ConfirmSubscription(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'ConfirmSubscription',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = CONFIRMSUBSCRIPTION_HEADER_KEYS,
        header_data = opts,
    })
end



local CREATETOPIC_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.CreateTopic(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'CreateTopic',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = CREATETOPIC_HEADER_KEYS,
        header_data = opts,
    })
end



local CHECKIFPHONENUMBERISOPTEDOUT_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.CheckIfPhoneNumberIsOptedOut(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'CheckIfPhoneNumberIsOptedOut',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = CHECKIFPHONENUMBERISOPTEDOUT_HEADER_KEYS,
        header_data = opts,
    })
end



local GETENDPOINTATTRIBUTES_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.GetEndpointAttributes(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'GetEndpointAttributes',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = GETENDPOINTATTRIBUTES_HEADER_KEYS,
        header_data = opts,
    })
end



local DELETEPLATFORMAPPLICATION_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.DeletePlatformApplication(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'DeletePlatformApplication',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = DELETEPLATFORMAPPLICATION_HEADER_KEYS,
        header_data = opts,
    })
end



local DELETETOPIC_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.DeleteTopic(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'DeleteTopic',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = DELETETOPIC_HEADER_KEYS,
        header_data = opts,
    })
end



local GETSMSATTRIBUTES_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.GetSMSAttributes(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'GetSMSAttributes',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = GETSMSATTRIBUTES_HEADER_KEYS,
        header_data = opts,
    })
end



local LISTENDPOINTSBYPLATFORMAPPLICATION_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.ListEndpointsByPlatformApplication(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'ListEndpointsByPlatformApplication',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = LISTENDPOINTSBYPLATFORMAPPLICATION_HEADER_KEYS,
        header_data = opts,
    })
end



local UNSUBSCRIBE_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.Unsubscribe(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'Unsubscribe',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = UNSUBSCRIBE_HEADER_KEYS,
        header_data = opts,
    })
end



local SETPLATFORMAPPLICATIONATTRIBUTES_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.SetPlatformApplicationAttributes(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'SetPlatformApplicationAttributes',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = SETPLATFORMAPPLICATIONATTRIBUTES_HEADER_KEYS,
        header_data = opts,
    })
end



local GETSUBSCRIPTIONATTRIBUTES_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.GetSubscriptionAttributes(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'GetSubscriptionAttributes',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = GETSUBSCRIPTIONATTRIBUTES_HEADER_KEYS,
        header_data = opts,
    })
end



local SUBSCRIBE_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.Subscribe(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'Subscribe',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = SUBSCRIBE_HEADER_KEYS,
        header_data = opts,
    })
end



local SETTOPICATTRIBUTES_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.SetTopicAttributes(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'SetTopicAttributes',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = SETTOPICATTRIBUTES_HEADER_KEYS,
        header_data = opts,
    })
end



local LISTSUBSCRIPTIONSBYTOPIC_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.ListSubscriptionsByTopic(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'ListSubscriptionsByTopic',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = LISTSUBSCRIPTIONSBYTOPIC_HEADER_KEYS,
        header_data = opts,
    })
end



local LISTPLATFORMAPPLICATIONS_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.ListPlatformApplications(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'ListPlatformApplications',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = LISTPLATFORMAPPLICATIONS_HEADER_KEYS,
        header_data = opts,
    })
end



local OPTINPHONENUMBER_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.OptInPhoneNumber(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'OptInPhoneNumber',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = OPTINPHONENUMBER_HEADER_KEYS,
        header_data = opts,
    })
end



local CREATEPLATFORMENDPOINT_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.CreatePlatformEndpoint(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'CreatePlatformEndpoint',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = CREATEPLATFORMENDPOINT_HEADER_KEYS,
        header_data = opts,
    })
end



local SETENDPOINTATTRIBUTES_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.SetEndpointAttributes(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'SetEndpointAttributes',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = SETENDPOINTATTRIBUTES_HEADER_KEYS,
        header_data = opts,
    })
end



local DELETEENDPOINT_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.DeleteEndpoint(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'DeleteEndpoint',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = DELETEENDPOINT_HEADER_KEYS,
        header_data = opts,
    })
end



local REMOVEPERMISSION_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.RemovePermission(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'RemovePermission',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = REMOVEPERMISSION_HEADER_KEYS,
        header_data = opts,
    })
end



local PUBLISH_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.Publish(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'Publish',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = PUBLISH_HEADER_KEYS,
        header_data = opts,
    })
end



local LISTSUBSCRIPTIONS_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.ListSubscriptions(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'ListSubscriptions',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = LISTSUBSCRIPTIONS_HEADER_KEYS,
        header_data = opts,
    })
end



local SETSUBSCRIPTIONATTRIBUTES_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.SetSubscriptionAttributes(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'SetSubscriptionAttributes',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = SETSUBSCRIPTIONATTRIBUTES_HEADER_KEYS,
        header_data = opts,
    })
end



local CREATEPLATFORMAPPLICATION_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.CreatePlatformApplication(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'CreatePlatformApplication',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = CREATEPLATFORMAPPLICATION_HEADER_KEYS,
        header_data = opts,
    })
end



local LISTTOPICS_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.ListTopics(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'ListTopics',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = LISTTOPICS_HEADER_KEYS,
        header_data = opts,
    })
end



local LISTPHONENUMBERSOPTEDOUT_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.ListPhoneNumbersOptedOut(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'ListPhoneNumbersOptedOut',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = LISTPHONENUMBERSOPTEDOUT_HEADER_KEYS,
        header_data = opts,
    })
end



local SETSMSATTRIBUTES_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.SetSMSAttributes(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'SetSMSAttributes',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = SETSMSATTRIBUTES_HEADER_KEYS,
        header_data = opts,
    })
end



local ADDPERMISSION_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.AddPermission(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'AddPermission',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = ADDPERMISSION_HEADER_KEYS,
        header_data = opts,
    })
end



local GETTOPICATTRIBUTES_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.GetTopicAttributes(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'GetTopicAttributes',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = GETTOPICATTRIBUTES_HEADER_KEYS,
        header_data = opts,
    })
end



local GETPLATFORMAPPLICATIONATTRIBUTES_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.GetPlatformApplicationAttributes(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'GetPlatformApplicationAttributes',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = GETPLATFORMAPPLICATIONATTRIBUTES_HEADER_KEYS,
        header_data = opts,
    })
end



return _M


