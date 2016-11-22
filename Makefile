
build: clean src codegen
	cp codegen/dist/*.lua lib/resty/aws/

.PHONY: build

src:
	cp src/*.lua lib/resty/aws/

.PHONY: src

codegen:
	make -C codegen

.PHONY: codegen

test:
	/usr/local/openresty/bin/resty ./scripts/busted test

.PHONY: test
	
clean:
	-make -C codegen clean
	-rm lib/resty/aws/*.lua

.PHONY: clean
