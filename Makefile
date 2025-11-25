all: build run

build:
	docker build . --tag docker.io/sirrgb/shells:latest

run:
	docker run --interactive --tty docker.io/sirrgb/shells:latest

publish:
	docker image push docker.io/sirrgb/shells:latest
