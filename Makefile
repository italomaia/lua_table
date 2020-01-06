test-51:
	docker run --rm -w /root \
		-v "$(PWD):/root"\
		alpine sh -c "\
			apk add gcc libc-dev lua5.1-dev luarocks luarocks5.1 &&\
			luarocks-5.1 install busted &&\
			busted .\
		"

test-52:
	docker run --rm -w /root \
		-v "$(PWD):/root"\
		alpine sh -c "\
			apk add gcc libc-dev lua5.2-dev luarocks luarocks5.2 &&\
			luarocks-5.2 install busted &&\
			busted .\
		"

test-53:
	docker run --rm -w /root \
		-v "$(PWD):/root"\
		alpine sh -c "\
			apk add gcc libc-dev lua5.3-dev luarocks luarocks5.3 &&\
			luarocks-5.3 install busted &&\
			busted .\
		"

test:
	busted .

build-docs:
	ldoc .
