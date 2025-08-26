all: build run

build:
	docker build . -t shells

run:
	docker run -i -t shells
