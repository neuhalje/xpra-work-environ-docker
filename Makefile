DOCKER-IMAGE-VERSION = 0.0.20
DOCKER=podman

.PHONY: build
				#--no-cache
build: base-image babashka-installer inkscape-appimage
	${DOCKER} buildx \
               build \
                --platform linux/amd64 \
		--build-arg VCS_REF="${git rev-parse --short HEAD}" \
                --build-arg VERSION=${DOCKER-IMAGE-VERSION} \
		--build-arg BUILD_DATE="${date +'%Y-%m-%d'}" \
		-t docker.io/jensneuhalfen/xpra-work-env:${DOCKER-IMAGE-VERSION} \
		docker

               # --squash \ will crash installing python
			   #
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
	echo "b1fa184c87f5115251cc38bcc999221c23b458df608cfeb6395a427185eb708c  docker/babashka-installer"|shasum -a256 -c
	chmod 755 docker/babashka-installer 

.PHONY: inkscape-appimage
inkscape-appimage:
	[ -d docker/tmp ] || mkdir docker/tmp
	# [ -f docker/tmp/Inkscape.AppImage ] && rm docker/tmp/Inkscape.AppImage
	[ -f docker/tmp/Inkscape.AppImage ] || wget -O docker/tmp/Inkscape.AppImage https://inkscape.org/gallery/item/42330/Inkscape-0e150ed-x86_64.AppImage
	echo "f8648da54e4dab474b40957c6156034b7094b0d701394ec86534cefe3bc00ed5  docker/tmp/Inkscape.AppImage" | shasum -a256 -c

.PHONY: base-image
base-image:
	${DOCKER} pull ubuntu:lunar

runnomount:
	${DOCKER} run --rm -p 0.0.0.0:9876:9876 \
                --platform linux/amd64 \
                --user $(id -u):$(id -g) \
		-e "CERT_SAN=DNS:localhost,IP:127.0.0.1,DNS:xpra.example.com" \
		-e XPRA_PASSWORD="test" \
		jensneuhalfen/xpra-work-env:${DOCKER-IMAGE-VERSION}
run:
	${DOCKER} run --rm -p 0.0.0.0:9876:9876 \
                --platform linux/amd64 \
                --user $(id -u):$(id -g) \
		-v ${PWD}/home:/home/ubuntu \
		-v ~/Documents:/home/ubuntu/Documents \
		-v ~/.doom.d:/home/ubuntu/.doom.d \
		-v ~/.emacs.d:/home/ubuntu/.emacs.d \
		-e "CERT_SAN=DNS:localhost,IP:127.0.0.1,DNS:xpra.example.com" \
		-e XPRA_PASSWORD="test" \
		jensneuhalfen/xpra-work-env:latest
# jensneuhalfen/xpra-work-env:${DOCKER-IMAGE-VERSION}
shell:
	${DOCKER} run --rm -ti \
                --platform linux/amd64 \
		-v ${PWD}/home:/home/ubuntu \
		-v ~/Documents:/home/ubuntu/Documents \
		-v ~/.doom.d:/home/ubuntu/.doom.d \
		jensneuhalfen/xpra-work-env:latest \
		/bin/bash

no-mount-shell:
	${DOCKER} run --rm -ti \
                --platform linux/amd64 \
		jensneuhalfen/xpra-work-env:${DOCKER-IMAGE-VERSION} \
		/bin/bash

.PHONY: push
push: 
	${DOCKER} tag docker.io/jensneuhalfen/xpra-work-env:${DOCKER-IMAGE-VERSION} docker.io/jensneuhalfen/xpra-work-env:latest
	${DOCKER} push docker.io/jensneuhalfen/xpra-work-env:${DOCKER-IMAGE-VERSION}
	${DOCKER} push docker.io/jensneuhalfen/xpra-work-env:latest
