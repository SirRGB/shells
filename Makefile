all: build run

build:
	docker build . --tag sirrgb/shells

run:
	docker run --interactive --tty sirrgb/shells

publish:
	docker push sirrgb/shells
