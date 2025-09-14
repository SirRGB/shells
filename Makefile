all: build run

build:
	docker build . --tag shells

run:
	docker run --interactive --tty shells
