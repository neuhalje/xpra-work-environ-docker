DOCKER-IMAGE-VERSION = 0.0.16
DOCKER=podman

.PHONY: build
build: base-image babashka-installer
	${DOCKER} buildx \
               build \
                --platform linux/amd64 \
		--build-arg VCS_REF="${git rev-parse --short HEAD}" \
                --build-arg VERSION=${DOCKER-IMAGE-VERSION} \
		--build-arg BUILD_DATE="${date +'%Y-%m-%d'}" \
		-t docker.io/jensneuhalfen/xpra-work-env:${DOCKER-IMAGE-VERSION} \
		docker

               # --squash \ will crash installing python
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

.PHONY: babashka-installer
babashka-installer:
ifneq (,$(wildcard docker/babashka-installer))
	rm docker/babashka-installer
endif
	wget -O  docker/babashka-installer  https://raw.githubusercontent.com/babashka/babashka/master/install
	chmod 755 docker/babashka-installer 

.PHONY: base-image
base-image:
	${DOCKER} pull ubuntu:lunar

run:
	${DOCKER} run --rm -p 127.0.0.1:9876:9876 \
                --platform linux/amd64 \
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
                --platform linux/amd64 \
		-v ${PWD}/home:/home/ubuntu \
		-v ~/Documents:/home/ubuntu/Documents \
		-v ~/.doom.d:/home/ubuntu/.doom.d \
		jensneuhalfen/xpra-work-env:${DOCKER-IMAGE-VERSION} \
		/bin/bash

.PHONY: push
push: build
	${DOCKER} tag docker.io/jensneuhalfen/xpra-work-env:${DOCKER-IMAGE-VERSION} docker.io/jensneuhalfen/xpra-work-env:latest
	${DOCKER} push docker.io/jensneuhalfen/xpra-work-env:${DOCKER-IMAGE-VERSION}
	${DOCKER} push docker.io/jensneuhalfen/xpra-work-env:latest
