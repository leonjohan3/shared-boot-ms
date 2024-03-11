.PHONY: build run push

IMAGE_NAME = shared-boot-ms
VERSION = $(shell git log|head -1|awk '{print $$2}'|cut -c-6)
REGION = us-east-1
AWS_ACCOUNT_ID = $(filter-out $@,$(MAKECMDGOALS))

# to push Docker image to ECR: make push <AWS_ACCOUNT_ID>

# https://stackoverflow.com/questions/6273608/how-to-pass-argument-to-makefile-from-command-line
%:
	@:

build:
	./gradlew build
	docker build --progress plain -t $(IMAGE_NAME) .

push: build
	aws ecr get-login-password | docker login --username AWS --password-stdin $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com
	docker tag $(IMAGE_NAME):latest $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com/$(IMAGE_NAME):$(VERSION)
	docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com/$(IMAGE_NAME):$(VERSION)

run: build
	docker run --rm -p 8080:8080 -d --name $(IMAGE_NAME) $(IMAGE_NAME)

