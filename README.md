# Name

lua-resty-aws-sdk - a raw aws sdk generated from API specification

## Table of Contents

* [Name](#Name)
* [Status](#Status)

## Status

This library is not ready for production.

## Description

This Lua library provides basic aws request signing and creating feature. You can use this module
with `proxy_pass`, or `lua-resty-http` or any other library you want.

## Synopsis

```lua
local lambda = require 'resty.aws.lambda'
local cred = requrie 'resty.aws.cred'
local json = require 'cjson'

local c = cred.from_env()
local l = lambda:new()
local body = json.encode({
  foo = 'bar'
})

local req = l:Invoke(c, {
    FunctionName = 'test' 
    ['X-Amz-Client-Context'] = '<some_base64_json_context>'
}, body)

-- do something with req
```

## Request Structure

The `req` variable in the code above is just a data object which includes the following informations:

* headers - headers as a `{ { k, v } }` list
* hostname - the hostname which you can send the api request to
* port - the port, 443 only
* pathname - the pathname for the api
* method - the request method you can use to send the api request
* query - the query string as string
* body - the request body

Because the aws sdk api only provides you data. You can build your own APIs on top of them. It doesn't
care about which `http` library you use.

## Credentials

AWS credentials is a very important in the API request. So make sure you choose the right way to read
and pass your credential to the request.

In this library. It provides a module called `resty.aws.cred`. Which allows you get your credential from
different places.

The credential table will have a data structure which looks like this:

```
{
  key = String,
  secret = String,
  session_token = ?String
}
```

The session token is widly used in different places `iam/sts`. But is not a required field.

### `from_env`

This function will help you create a new credential table using `AWS_` related environment variables, the name
of the variables are consist with `aws-cli`. 

- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_SESSION_TOKEN

```lua
local c = require 'resty.aws.cred'
local credential = c.from_env()
```

### `from_iam`

This function will help you create a new credential table using `iam` role which your related to the resource(ec2/ecs/..)
you use. It simply sends http request to `169.254.169.254` to get the metadata informations. For more information about
`iam` role and metadata. You need to check the [AWS Document](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html)
about it.


```lua
local c = require 'resty.aws.cred'
local credential = c.from_iam('lambdainvoke')
```


## Contribute

Service source files are generated using the `codegen/main.lua` file to create. All service file share the same format. And
`botocore` as a submodule provides a nice API specification. We don't need to do the busywork to create lua api for every
service manually. Instead, once we finish the code generation script. The `api-spec` + `codegen` will generate the code for
us. So, don't change the code manually in the `lib/resty/aws` directory.

## Support signature methods

- [v4](http://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html)

## Implemented Services

- `resty.aws.lambda`
- `resty.aws.sqs`
- `resty.aws.sns`

## Todo

- `resty.aws.s3`
- `resty.aws.cloudwatch`
- `resty.aws.elb`
- `resty.aws.kinesis`
- `resty.aws.logs`
- `resty.aws.kms`
- `resty.aws.cognito-identity`


## Not Yet Implemented

- [s3 signigure](http://docs.aws.amazon.com/AmazonS3/latest/API/bucket-policy-s3-sigv4-conditions.html)

