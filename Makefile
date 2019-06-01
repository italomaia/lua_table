test-51:
	docker run --rm \
		-v "$PWD:/root"\
		alpine sh -c "\
			apk add luarocks5.1 &&\
			cd /root &&\
			USER=root luarocks-5.1 install busted &&\
			busted .\
		"

test-52:
	docker run --rm \
		-v "$PWD:/root"\
		alpine sh -c "\
			apk add luarocks5.2 &&\
			cd /root &&\
			USER=root luarocks-5.2 install busted &&\
			busted .\
		"

test-53:
	docker run --rm \
		-v "$PWD:/root"\
		alpine sh -c "\
			apk add luarocks5.3 &&\
			cd /root &&\
			USER=root luarocks-5.3 install busted &&\
			busted .\
		"

test:
	busted .

build-docs:
	ldoc .
