--
--- @module resty.aws.lambda

local _M = {}
local http = require 'resty.http'
local request = require 'resty.aws.request'

local VERSION = '2015-03-31'
local CONTENT_TYPE = 'application/json'
local SIGNATURE_VERSION = 'v4'

local REGIONS = {
    ['ap-southeast-1'] = 'ap-southeast-1',
    ['ap-northeast-2'] = 'ap-northeast-2',
    ['ap-northeast-1'] = 'ap-northeast-1',
    ['us-east-2'] = 'us-east-2',
    ['us-west-2'] = 'us-west-2',
    ['us-east-1'] = 'us-east-1',
    ['ap-southeast-2'] = 'ap-southeast-2',
    ['eu-central-1'] = 'eu-central-1',
    ['eu-west-1'] = 'eu-west-1',
}

local ENDPOINTS = {
    ['ap-southeast-1'] = 'lambda.ap-southeast-1.amazonaws.com',
    ['ap-northeast-2'] = 'lambda.ap-northeast-2.amazonaws.com',
    ['ap-northeast-1'] = 'lambda.ap-northeast-1.amazonaws.com',
    ['us-east-2'] = 'lambda.us-east-2.amazonaws.com',
    ['us-west-2'] = 'lambda.us-west-2.amazonaws.com',
    ['us-east-1'] = 'lambda.us-east-1.amazonaws.com',
    ['ap-southeast-2'] = 'lambda.ap-southeast-2.amazonaws.com',
    ['eu-central-1'] = 'lambda.eu-central-1.amazonaws.com',
    ['eu-west-1'] = 'lambda.eu-west-1.amazonaws.com',
}

local mt = { __index = _M }

function _M.new(_, region)
    local r = string.lower(region or os.getenv('AWS_DEFAULT_REGION'))

    if not r then
        return nil, '[lambda] region[' .. region .. '] is not available for this service'
    end

    return setmetatable({
        service = 'lambda',
        scope = region .. '/lambda/aws4_request',
        host = REGIONS[r]
    }, mt)
end


local CREATEFUNCTION_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.CreateFunction(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'CreateFunction',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/2015-03-31/functions',
        body = data or '',
        header_keys = CREATEFUNCTION_HEADER_KEYS,
        header_data = opts,
    })
end



local UPDATEEVENTSOURCEMAPPING_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.UpdateEventSourceMapping(self, cred, opts, data)
    local UUID = opts['UUID']
    if not UUID then
        return nil, 'UUID is required'
    end

    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'UpdateEventSourceMapping',
        method = 'PUT',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/2015-03-31/event-source-mappings/' .. UUID,
        body = data or '',
        header_keys = UPDATEEVENTSOURCEMAPPING_HEADER_KEYS,
        header_data = opts,
    })
end



local GETALIAS_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.GetAlias(self, cred, opts, data)
    local FunctionName = opts['FunctionName']
    if not FunctionName then
        return nil, 'FunctionName is required'
    end

    local Name = opts['Name']
    if not Name then
        return nil, 'Name is required'
    end

    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'GetAlias',
        method = 'GET',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/2015-03-31/functions/' .. FunctionName .. '/aliases/' .. Name,
        body = data or '',
        header_keys = GETALIAS_HEADER_KEYS,
        header_data = opts,
    })
end



local LISTEVENTSOURCEMAPPINGS_QUERY_KEYS = { 'EventSourceArn', 'FunctionName', 'Marker', 'MaxItems' }
local LISTEVENTSOURCEMAPPINGS_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.ListEventSourceMappings(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'ListEventSourceMappings',
        method = 'GET',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/2015-03-31/event-source-mappings',
        body = data or '',
        query_keys = LISTEVENTSOURCEMAPPINGS_QUERY_KEYS,
        query_data = opts,
        header_keys = LISTEVENTSOURCEMAPPINGS_HEADER_KEYS,
        header_data = opts,
    })
end



local LISTALIASES_QUERY_KEYS = { 'FunctionVersion', 'Marker', 'MaxItems' }
local LISTALIASES_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.ListAliases(self, cred, opts, data)
    local FunctionName = opts['FunctionName']
    if not FunctionName then
        return nil, 'FunctionName is required'
    end

    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'ListAliases',
        method = 'GET',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/2015-03-31/functions/' .. FunctionName .. '/aliases',
        body = data or '',
        query_keys = LISTALIASES_QUERY_KEYS,
        query_data = opts,
        header_keys = LISTALIASES_HEADER_KEYS,
        header_data = opts,
    })
end



local DELETEALIAS_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.DeleteAlias(self, cred, opts, data)
    local FunctionName = opts['FunctionName']
    if not FunctionName then
        return nil, 'FunctionName is required'
    end

    local Name = opts['Name']
    if not Name then
        return nil, 'Name is required'
    end

    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'DeleteAlias',
        method = 'DELETE',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/2015-03-31/functions/' .. FunctionName .. '/aliases/' .. Name,
        body = data or '',
        header_keys = DELETEALIAS_HEADER_KEYS,
        header_data = opts,
    })
end



local INVOKEASYNC_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.InvokeAsync(self, cred, opts, data)
    local FunctionName = opts['FunctionName']
    if not FunctionName then
        return nil, 'FunctionName is required'
    end

    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'InvokeAsync',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/2014-11-13/functions/' .. FunctionName .. '/invoke-async',
        body = data or '',
        header_keys = INVOKEASYNC_HEADER_KEYS,
        header_data = opts,
    })
end



local GETPOLICY_QUERY_KEYS = { 'Qualifier' }
local GETPOLICY_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.GetPolicy(self, cred, opts, data)
    local FunctionName = opts['FunctionName']
    if not FunctionName then
        return nil, 'FunctionName is required'
    end

    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'GetPolicy',
        method = 'GET',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/2015-03-31/functions/' .. FunctionName .. '/policy',
        body = data or '',
        query_keys = GETPOLICY_QUERY_KEYS,
        query_data = opts,
        header_keys = GETPOLICY_HEADER_KEYS,
        header_data = opts,
    })
end



local DELETEEVENTSOURCEMAPPING_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.DeleteEventSourceMapping(self, cred, opts, data)
    local UUID = opts['UUID']
    if not UUID then
        return nil, 'UUID is required'
    end

    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'DeleteEventSourceMapping',
        method = 'DELETE',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/2015-03-31/event-source-mappings/' .. UUID,
        body = data or '',
        header_keys = DELETEEVENTSOURCEMAPPING_HEADER_KEYS,
        header_data = opts,
    })
end



local LISTFUNCTIONS_QUERY_KEYS = { 'Marker', 'MaxItems' }
local LISTFUNCTIONS_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.ListFunctions(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'ListFunctions',
        method = 'GET',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/2015-03-31/functions',
        body = data or '',
        query_keys = LISTFUNCTIONS_QUERY_KEYS,
        query_data = opts,
        header_keys = LISTFUNCTIONS_HEADER_KEYS,
        header_data = opts,
    })
end



local CREATEEVENTSOURCEMAPPING_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.CreateEventSourceMapping(self, cred, opts, data)
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'CreateEventSourceMapping',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/2015-03-31/event-source-mappings',
        body = data or '',
        header_keys = CREATEEVENTSOURCEMAPPING_HEADER_KEYS,
        header_data = opts,
    })
end



local UPDATEFUNCTIONCODE_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.UpdateFunctionCode(self, cred, opts, data)
    local FunctionName = opts['FunctionName']
    if not FunctionName then
        return nil, 'FunctionName is required'
    end

    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'UpdateFunctionCode',
        method = 'PUT',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/2015-03-31/functions/' .. FunctionName .. '/code',
        body = data or '',
        header_keys = UPDATEFUNCTIONCODE_HEADER_KEYS,
        header_data = opts,
    })
end



local GETFUNCTION_QUERY_KEYS = { 'Qualifier' }
local GETFUNCTION_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.GetFunction(self, cred, opts, data)
    local FunctionName = opts['FunctionName']
    if not FunctionName then
        return nil, 'FunctionName is required'
    end

    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'GetFunction',
        method = 'GET',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/2015-03-31/functions/' .. FunctionName,
        body = data or '',
        query_keys = GETFUNCTION_QUERY_KEYS,
        query_data = opts,
        header_keys = GETFUNCTION_HEADER_KEYS,
        header_data = opts,
    })
end



local DELETEFUNCTION_QUERY_KEYS = { 'Qualifier' }
local DELETEFUNCTION_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.DeleteFunction(self, cred, opts, data)
    local FunctionName = opts['FunctionName']
    if not FunctionName then
        return nil, 'FunctionName is required'
    end

    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'DeleteFunction',
        method = 'DELETE',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/2015-03-31/functions/' .. FunctionName,
        body = data or '',
        query_keys = DELETEFUNCTION_QUERY_KEYS,
        query_data = opts,
        header_keys = DELETEFUNCTION_HEADER_KEYS,
        header_data = opts,
    })
end



local GETEVENTSOURCEMAPPING_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.GetEventSourceMapping(self, cred, opts, data)
    local UUID = opts['UUID']
    if not UUID then
        return nil, 'UUID is required'
    end

    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'GetEventSourceMapping',
        method = 'GET',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/2015-03-31/event-source-mappings/' .. UUID,
        body = data or '',
        header_keys = GETEVENTSOURCEMAPPING_HEADER_KEYS,
        header_data = opts,
    })
end



local UPDATEALIAS_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.UpdateAlias(self, cred, opts, data)
    local FunctionName = opts['FunctionName']
    if not FunctionName then
        return nil, 'FunctionName is required'
    end

    local Name = opts['Name']
    if not Name then
        return nil, 'Name is required'
    end

    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'UpdateAlias',
        method = 'PUT',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/2015-03-31/functions/' .. FunctionName .. '/aliases/' .. Name,
        body = data or '',
        header_keys = UPDATEALIAS_HEADER_KEYS,
        header_data = opts,
    })
end



local CREATEALIAS_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.CreateAlias(self, cred, opts, data)
    local FunctionName = opts['FunctionName']
    if not FunctionName then
        return nil, 'FunctionName is required'
    end

    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'CreateAlias',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/2015-03-31/functions/' .. FunctionName .. '/aliases',
        body = data or '',
        header_keys = CREATEALIAS_HEADER_KEYS,
        header_data = opts,
    })
end



local PUBLISHVERSION_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.PublishVersion(self, cred, opts, data)
    local FunctionName = opts['FunctionName']
    if not FunctionName then
        return nil, 'FunctionName is required'
    end

    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'PublishVersion',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/2015-03-31/functions/' .. FunctionName .. '/versions',
        body = data or '',
        header_keys = PUBLISHVERSION_HEADER_KEYS,
        header_data = opts,
    })
end



local REMOVEPERMISSION_QUERY_KEYS = { 'Qualifier' }
local REMOVEPERMISSION_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.RemovePermission(self, cred, opts, data)
    local FunctionName = opts['FunctionName']
    if not FunctionName then
        return nil, 'FunctionName is required'
    end

    local StatementId = opts['StatementId']
    if not StatementId then
        return nil, 'StatementId is required'
    end

    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'RemovePermission',
        method = 'DELETE',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/2015-03-31/functions/' .. FunctionName .. '/policy/' .. StatementId,
        body = data or '',
        query_keys = REMOVEPERMISSION_QUERY_KEYS,
        query_data = opts,
        header_keys = REMOVEPERMISSION_HEADER_KEYS,
        header_data = opts,
    })
end



local LISTVERSIONSBYFUNCTION_QUERY_KEYS = { 'Marker', 'MaxItems' }
local LISTVERSIONSBYFUNCTION_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.ListVersionsByFunction(self, cred, opts, data)
    local FunctionName = opts['FunctionName']
    if not FunctionName then
        return nil, 'FunctionName is required'
    end

    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'ListVersionsByFunction',
        method = 'GET',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/2015-03-31/functions/' .. FunctionName .. '/versions',
        body = data or '',
        query_keys = LISTVERSIONSBYFUNCTION_QUERY_KEYS,
        query_data = opts,
        header_keys = LISTVERSIONSBYFUNCTION_HEADER_KEYS,
        header_data = opts,
    })
end



local UPDATEFUNCTIONCONFIGURATION_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.UpdateFunctionConfiguration(self, cred, opts, data)
    local FunctionName = opts['FunctionName']
    if not FunctionName then
        return nil, 'FunctionName is required'
    end

    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'UpdateFunctionConfiguration',
        method = 'PUT',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/2015-03-31/functions/' .. FunctionName .. '/configuration',
        body = data or '',
        header_keys = UPDATEFUNCTIONCONFIGURATION_HEADER_KEYS,
        header_data = opts,
    })
end



local ADDPERMISSION_QUERY_KEYS = { 'Qualifier' }
local ADDPERMISSION_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.AddPermission(self, cred, opts, data)
    local FunctionName = opts['FunctionName']
    if not FunctionName then
        return nil, 'FunctionName is required'
    end

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
        pathname = '/2015-03-31/functions/' .. FunctionName .. '/policy',
        body = data or '',
        query_keys = ADDPERMISSION_QUERY_KEYS,
        query_data = opts,
        header_keys = ADDPERMISSION_HEADER_KEYS,
        header_data = opts,
    })
end



local GETFUNCTIONCONFIGURATION_QUERY_KEYS = { 'Qualifier' }
local GETFUNCTIONCONFIGURATION_HEADER_KEYS = { 'Host', 'X-Amz-Date', 'X-Amz-Security-Token' }
function _M.GetFunctionConfiguration(self, cred, opts, data)
    local FunctionName = opts['FunctionName']
    if not FunctionName then
        return nil, 'FunctionName is required'
    end

    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'GetFunctionConfiguration',
        method = 'GET',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/2015-03-31/functions/' .. FunctionName .. '/configuration',
        body = data or '',
        query_keys = GETFUNCTIONCONFIGURATION_QUERY_KEYS,
        query_data = opts,
        header_keys = GETFUNCTIONCONFIGURATION_HEADER_KEYS,
        header_data = opts,
    })
end



local INVOKE_QUERY_KEYS = { 'Qualifier' }
local INVOKE_HEADER_KEYS = { 'Host', 'X-Amz-Client-Context', 'X-Amz-Date', 'X-Amz-Invocation-Type', 'X-Amz-Log-Type', 'X-Amz-Security-Token' }
function _M.Invoke(self, cred, opts, data)
    local FunctionName = opts['FunctionName']
    if not FunctionName then
        return nil, 'FunctionName is required'
    end

    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = 'Invoke',
        method = 'POST',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = '/2015-03-31/functions/' .. FunctionName .. '/invocations',
        body = data or '',
        query_keys = INVOKE_QUERY_KEYS,
        query_data = opts,
        header_keys = INVOKE_HEADER_KEYS,
        header_data = opts,
    })
end



return _M


