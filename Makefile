all: build run
tag ?= $$(date +%Y%m%d%H%M)

build:
	docker build . --tag docker.io/sirrgb/shells:latest

run:
	docker run --interactive --tty docker.io/sirrgb/shells:latest

publish:
	docker tag docker.io/sirrgb/shells:latest docker.io/sirrgb/shells:$(tag)
	docker image push docker.io/sirrgb/shells:$(tag)
	docker image push docker.io/sirrgb/shells:latest
