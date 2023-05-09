DOCKER-IMAGE-VERSION = 0.0.12
DOCKER=podman

.PHONY: build
build: base-image
	${DOCKER} build -t jensneuhalfen/xpra-work-env:${DOCKER-IMAGE-VERSION} docker

# This is a manual step on purpose. Do not trust the signing key downloaded
.PHONY: xpra-signing-key
xpra-signing-key:
ifneq (,$(wildcard docker/xpra.gpg))
	rm docker/xpra.gpg
endif
	wget -O - https://xpra.org/gpg.asc | gpg --dearmour -o docker/xpra.gpg

# This is a manual step on purpose. Do not trust the signing key downloaded
.PHONY: gopass-signing-key
gopass-signing-key:
ifneq (,$(wildcard docker/gopass.gpg))
	rm docker/gopass.gpg
endif
	wget -O  docker/gopass.gpg  https://packages.gopass.pw/repos/gopass/gopass-archive-keyring.gpg

.PHONY: base-image
base-image:
	${DOCKER} pull ubuntu:lunar

run:
	${DOCKER} run --rm -p 127.0.0.1:9876:9876 \
        --user $(id -u):$(id -g) \
		-v ${PWD}/home:/home/ubuntu \
		-v ~/Documents:/home/ubuntu/Documents \
		-v ~/.doom.d:/home/ubuntu/.doom.d \
		-v ~/.emacs.d:/home/ubuntu/.emacs.d \
		-e "CERT_SAN=DNS:localhost,IP:127.0.0.1,DNS:xpra.example.com" \
		-e XPRA_PASSWORD="test" \
		jensneuhalfen/xpra-work-env:${DOCKER-IMAGE-VERSION}
shell:
	${DOCKER} run --rm -ti \
		-v ${PWD}/home:/home/ubuntu \
		-v ~/Documents:/home/ubuntu/Documents \
		-v ~/.doom.d:/home/ubuntu/.doom.d \
		jensneuhalfen/xpra-work-env:${DOCKER-IMAGE-VERSION} \
		/bin/bash

.PHONY: push
push: build
	${DOCKER} tag jensneuhalfen/xpra-work-env:${DOCKER-IMAGE-VERSION} jensneuhalfen/xpra-work-env:latest
	${DOCKER} push jensneuhalfen/xpra-work-env:${DOCKER-IMAGE-VERSION}
	${DOCKER} push jensneuhalfen/xpra-work-env:latest
