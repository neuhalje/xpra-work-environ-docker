DOCKER-IMAGE-VERSION = 0.0.11
DOCKER=podman

.PHONY: build
build: base-image
	${DOCKER} build -t jensneuhalfen/xpra-work-env:${DOCKER-IMAGE-VERSION} docker

.PHONY: base-image
base-image:
	${DOCKER} pull ubuntu:kinetic

run:
	${DOCKER} run --rm -p 127.0.0.1:9876:9876 \
        --user $(id -u):$(id -g) \
		-v ${PWD}/home:/home/user \
		-v ~/Documents:/home/user/Documents \
		-v ~/.doom.d:/home/user/.doom.d \
		-e "CERT_SAN=DNS:localhost,IP:127.0.0.1,DNS:xpra.example.com" \
		-e XPRA_PASSWORD \
		jensneuhalfen/xpra-work-env:${DOCKER-IMAGE-VERSION}
shell:
	${DOCKER} run --rm -ti \
		-v ${PWD}/home:/home/user \
		-v ~/Documents:/home/user/Documents \
		-v ~/.doom.d:/home/user/.doom.d \
		jensneuhalfen/xpra-work-env:${DOCKER-IMAGE-VERSION} \
		/bin/bash

.PHONY: push
push: build
	${DOCKER} tag jensneuhalfen/xpra-work-env:${DOCKER-IMAGE-VERSION} jensneuhalfen/xpra-work-env:latest
	${DOCKER} push jensneuhalfen/xpra-work-env:${DOCKER-IMAGE-VERSION}
	${DOCKER} push jensneuhalfen/xpra-work-env:latest
