.PHONY: build
build: base-image
	docker build -t xuxxux/xpra-work-env:0.0.1 docker

.PHONY: base-image
base-image:
	docker pull ubuntu:hirsute

run:
	docker run -p 127.0.0.1:9876:9876 \
		-v ${PWD}/home:/home/user \
		-v ~/Documents:/home/user/Documents \
		-v ~/.doom.d:/home/user/.doom.d \
		xuxxux/xpra-work-env:0.0.1
shell:
	docker run -ti \
		-v ${PWD}/home:/home/user \
		-v ~/Documents:/home/user/Documents \
		-v ~/.doom.d:/home/user/.doom.d \
		xuxxux/xpra-work-env:0.0.1 \
		/bin/bash

