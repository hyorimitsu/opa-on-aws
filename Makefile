-include .env

init:
	cp sample.env .env
	cp sample.config .config

build:
	docker build --no-cache \
		--build-arg GIT_CONFIG_USER_NAME="$(GIT_CONFIG_USER_NAME)" \
		--build-arg GIT_CONFIG_USER_EMAIL="$(GIT_CONFIG_USER_EMAIL)" \
		-t $(PROJECT_NAME):$(BUILD_TAG) .

run:
	docker run -it --rm \
		--name $(PROJECT_NAME) \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) \
		-e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
		-e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) \
		$(PROJECT_NAME):$(BUILD_TAG) /bin/bash
