.PHONY: build
build: 
	docker build -t xuxxux/xpra-work-env:0.0.1 docker
run:
	docker run -p 127.0.0.1:9876:9876 -v ${PWD}/home:/home/user -v ~/Documents:/home/user/Documents xuxxux/xpra-work-env:0.0.1
