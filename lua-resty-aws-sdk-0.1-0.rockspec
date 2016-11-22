package = "lua-resty-aws-sdk"
version = "0.1-0"
source = {
   url = "git://github.com/kiddkai/lua-resty-aws-sdk",
   tag = "v0.1.0"
}
description = {
   summary = "A generic long running task daemon",
   homepage = "https://github.com/kiddkai/lua-resty-aws-sdk",
   license = "2-clause BSD",
   maintainer = "Zekai Zheng(kiddkai@gmail.com)"
}
dependencies = {
   "lua >= 5.1",
   "lua-resty-http ~> 0.10-0"
}
build = {
   type = "builtin",
   modules = {
     ["resty.aws.request"] = "lib/resty/aws/request",
     ["resty.aws.signature"] = "lib/resty/aws/signature",
     ["resty.aws.cred"] = "lib/resty/aws/cred",
     ["resty.aws.sns"] = "lib/resty/aws/sns",
     ["resty.aws.sqs"] = "lib/resty/aws/sqs",
     ["resty.aws.lambda"] = "lib/resty/aws/lambda.lua"
   }
}
