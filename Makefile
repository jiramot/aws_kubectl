.PHONY: build

build:
	docker build -t jiramot/aws_kubectl .

push:
	docker push jiramot/aws_kubectl
