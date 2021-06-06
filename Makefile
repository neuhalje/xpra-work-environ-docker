DOCKER-IMAGE-VERSION = 0.0.2

.PHONY: build
build: base-image
	docker build -t xuxxux/xpra-work-env:${DOCKER-IMAGE-VERSION} docker

.PHONY: base-image
base-image:
	docker pull ubuntu:hirsute

run:
	docker run -p 127.0.0.1:9876:9876 \
		-v ${PWD}/home:/home/user \
		-v ~/Documents:/home/user/Documents \
		-v ~/.doom.d:/home/user/.doom.d \
		-e "CERT_SAN=DNS:localhost,IP:127.0.0.1,DNS:xpra.example.com" \
		-e XPRA_PASSWORD \
		xuxxux/xpra-work-env:${DOCKER-IMAGE-VERSION}
shell:
	docker run -ti \
		-v ${PWD}/home:/home/user \
		-v ~/Documents:/home/user/Documents \
		-v ~/.doom.d:/home/user/.doom.d \
		xuxxux/xpra-work-env:${DOCKER-IMAGE-VERSION} \
		/bin/bash

.PHONY: push
push: build
	docker tag xuxxux/xpra-work-env:${DOCKER-IMAGE-VERSION} xuxxux/xpra-work-env:latest
	docker push xuxxux/xpra-work-env:${DOCKER-IMAGE-VERSION} xuxxux/xpra-work-env:latest
