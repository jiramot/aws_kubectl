.PHONY: build

build:
	docker build -t jiramot/aws_kubectl:3 .

push:
	docker push jiramot/aws_kubectl:3
