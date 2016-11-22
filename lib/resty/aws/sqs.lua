--
--- @module resty.aws.sqs

local _M = {}
local http = require 'resty.http'
local request = require 'resty.aws.request'

local VERSION = '2012-11-05'
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
    ['ap-southeast-1'] = 'sqs.ap-southeast-1.amazonaws.com',
    ['ap-northeast-2'] = 'sqs.ap-northeast-2.amazonaws.com',
    ['ap-northeast-1'] = 'sqs.ap-northeast-1.amazonaws.com',
    ['us-east-2'] = 'sqs.us-east-2.amazonaws.com',
    ['ap-south-1'] = 'sqs.ap-south-1.amazonaws.com',
    ['us-west-2'] = 'sqs.us-west-2.amazonaws.com',
    ['us-east-1'] = 'sqs.us-east-1.amazonaws.com',
    ['eu-central-1'] = 'sqs.eu-central-1.amazonaws.com',
    ['eu-west-1'] = 'sqs.eu-west-1.amazonaws.com',
    ['sa-east-1'] = 'sqs.sa-east-1.amazonaws.com',
    ['us-west-1'] = 'sqs.us-west-1.amazonaws.com',
    ['ap-southeast-2'] = 'sqs.ap-southeast-2.amazonaws.com',
}

local mt = { __index = _M }

function _M.new(_, region)
    local r = string.lower(region or os.getenv('AWS_DEFAULT_REGION'))

    if not r then
        return nil, '[sqs] region[' .. region .. '] is not available for this service'
    end

    return setmetatable({
        service = 'sqs',
        scope = region .. '/sqs/aws4_request',
        host = REGIONS[r]
    }, mt)
end


local DELETEQUEUE_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.DeleteQueue(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'DeleteQueue',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = DELETEQUEUE_HEADER_KEYS,
        header_data = opts,
    })
end



local PURGEQUEUE_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.PurgeQueue(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'PurgeQueue',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = PURGEQUEUE_HEADER_KEYS,
        header_data = opts,
    })
end



local SENDMESSAGEBATCH_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.SendMessageBatch(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'SendMessageBatch',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = SENDMESSAGEBATCH_HEADER_KEYS,
        header_data = opts,
    })
end



local DELETEMESSAGEBATCH_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.DeleteMessageBatch(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'DeleteMessageBatch',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = DELETEMESSAGEBATCH_HEADER_KEYS,
        header_data = opts,
    })
end



local GETQUEUEATTRIBUTES_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.GetQueueAttributes(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'GetQueueAttributes',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = GETQUEUEATTRIBUTES_HEADER_KEYS,
        header_data = opts,
    })
end



local SETQUEUEATTRIBUTES_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.SetQueueAttributes(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'SetQueueAttributes',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = SETQUEUEATTRIBUTES_HEADER_KEYS,
        header_data = opts,
    })
end



local SENDMESSAGE_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.SendMessage(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'SendMessage',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = SENDMESSAGE_HEADER_KEYS,
        header_data = opts,
    })
end



local CREATEQUEUE_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.CreateQueue(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'CreateQueue',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = CREATEQUEUE_HEADER_KEYS,
        header_data = opts,
    })
end



local GETQUEUEURL_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.GetQueueUrl(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'GetQueueUrl',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = GETQUEUEURL_HEADER_KEYS,
        header_data = opts,
    })
end



local CHANGEMESSAGEVISIBILITY_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.ChangeMessageVisibility(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'ChangeMessageVisibility',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = CHANGEMESSAGEVISIBILITY_HEADER_KEYS,
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



local DELETEMESSAGE_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.DeleteMessage(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'DeleteMessage',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = DELETEMESSAGE_HEADER_KEYS,
        header_data = opts,
    })
end



local CHANGEMESSAGEVISIBILITYBATCH_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.ChangeMessageVisibilityBatch(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'ChangeMessageVisibilityBatch',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = CHANGEMESSAGEVISIBILITYBATCH_HEADER_KEYS,
        header_data = opts,
    })
end



local LISTQUEUES_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.ListQueues(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'ListQueues',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = LISTQUEUES_HEADER_KEYS,
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



local RECEIVEMESSAGE_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.ReceiveMessage(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'ReceiveMessage',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = RECEIVEMESSAGE_HEADER_KEYS,
        header_data = opts,
    })
end



local LISTDEADLETTERSOURCEQUEUES_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.ListDeadLetterSourceQueues(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'ListDeadLetterSourceQueues',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/',
        body = data or '',
        header_keys = LISTDEADLETTERSOURCEQUEUES_HEADER_KEYS,
        header_data = opts,
    })
end



return _M


