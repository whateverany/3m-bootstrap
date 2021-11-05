DOCKER_COMPOSE_RUN := docker-compose run --rm
BUILD ?= 0
VERSION := 0.0.0
TARGET_SEMANTIC_VERSION := $(TARGET_VERSION)
TARGET_SEMANTIC_RC := $(TARGET_SEMANTIC_VERSION)-rc.$(TARGET_BUILD)
ENVFILE := .env

build: .env env-SOURCE_GROUP
	/usr/bin/docker build \
		--no-cache \
	  --build-arg SOURCE_GROUP=$(SOURCE_GROUP) \
	  --build-arg SOURCE_REGISTRY=$(SOURCE_REGISTRY) \
	  --build-arg SOURCE_IMAGE=$(SOURCE_IMAGE) \
	  --build-arg SOURCE_VERSION=$(SOURCE_VERSION) \
	  --tag $(TARGET_REGISTRY)$(TARGET_GROUP)$(TARGET_IMAGE):$(TARGET_SEMANTIC_VERSION) \
	  --tag $(TARGET_REGISTRY)$(TARGET_GROUP)$(TARGET_IMAGE):$(TARGET_SEMANTIC_RC) \
	  --file Dockerfile  \
	  .
.PHONY: build

login: .env
	docker login --username ${TARGET_REGISTRY_USER} --password "${TARGET_REGISTRY_TOKEN}"  "${TARGET_REGISTRY}"
.PHONY: login

publish: .env
	docker push $(TARGET_REGISTRY)$(TARGET_GROUP)$(TARGET_IMAGE):$(TARGET_SEMANTIC_VERSION)
	docker push $(TARGET_REGISTRY)$(TARGET_GROUP)$(TARGET_IMAGE):$(TARGET_SEMANTIC_RC)
.PHONY: publish

logout: .env
	docker logout "${TARGET_REGISTRY}"
.PHONY: logout

shell: .env
	$(DOCKER_COMPOSE_RUN) 3m /bin/sh
.PHONY: shell

shell-root: .env
	$(DOCKER_COMPOSE_RUN) -u root 3m /bin/sh
.PHONY: shell-root

.env:
	echo $(ENVFILE)

env-%:
	echo "INFO: Check if $* is not empty"

