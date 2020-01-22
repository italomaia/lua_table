test-51:
	docker build --build-arg LUA_V=5.1 -t lua_table/test:51 .
	docker run --rm -t -v "$(PWD):/root" lua_table/test:51

test-52:
	docker build --build-arg LUA_V=5.2 -t lua_table/test:52 .
	docker run --rm -t -v "$(PWD):/root" lua_table/test:52

test-53:
	docker build --build-arg LUA_V=5.3 -t lua_table/test:53 .
	docker run --rm -t -v "$(PWD):/root" lua_table/test:53

test:
	busted .

build-docs:
	ldoc .
