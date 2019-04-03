build-image-53:
	docker build -t lua-table-test-53 --build-arg LUA_V=5.3 .

run-test-53:
	docker run --rm -v "$(PWD):/root" lua-table-test-53

build-images: build-image-53

run-tests: run-test-53

test-53: build-image-53 run-test-53

test: build-images run-tests

docs:
	ldoc $(pwd)
