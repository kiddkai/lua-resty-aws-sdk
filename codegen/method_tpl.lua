# if #QUERIES > 0 then
local $(NAME:upper())_QUERY_KEYS = { $(table.concat(QUERIES, ', ')) }
# end
# if #HEADERS > 0 then
local $(NAME:upper())_HEADER_KEYS = { $(table.concat(HEADERS, ', ')) }
# end
function _M.$(NAME)(self, $(ARGS), data)
# for _, URI_SEG in pairs(URI_PARAMS) do
    local $(URI_SEG) = opts['$(URI_SEG)']
    if not $(URI_SEG) then
        return nil, '$(URI_SEG) is required'
    end

# end
    return request({
        signature_version = SIGNATURE_VERSION,
        version = VERSION,
        service = self.service,
        host = self.host,
        scope = self.scope,
        action = '$(NAME)',
        method = '$(METHOD)',
        cred = cred,
        content_type = CONTENT_TYPE,
        pathname = $(URI),
        body = data or '',
# if #QUERIES > 0 then
        query_keys = $(NAME:upper())_QUERY_KEYS,
        query_data = opts,
# end
# if #HEADERS > 0 then
        header_keys = $(NAME:upper())_HEADER_KEYS,
        header_data = opts,
# end
    })
end
