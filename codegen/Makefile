RESTY="/usr/local/openresty/bin/resty"

build: clean dist/lambda.lua dist/sns.lua dist/sqs.lua

.PHONY: build

dist:
	mkdir -p dist

dist/lambda.lua: dist
	RESTY ./main.lua lambda > dist/lambda.lua

dist/sns.lua: dist
	RESTY ./main.lua sns > dist/sns.lua

dist/sqs.lua: dist
	RESTY ./main.lua sqs > dist/sqs.lua

clean:
	-rm -rf dist

.PHONY: clean

