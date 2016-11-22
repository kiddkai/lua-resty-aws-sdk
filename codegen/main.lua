#!/usr/local/openresty/bin/resty

local render = require 'service'

print(render(arg[1]))
