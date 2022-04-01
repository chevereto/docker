# Default arguments
VERSION ?= 4.0
PHP ?= 8.1
ARCH ?= arm64v8
DOCKER_USER ?= www-data
PROTOCOL ?= http
CONTAINER_BASENAME ?= chevereto-build-${VERSION}-${ARCH}
TAG ?= chevereto-build:${VERSION}-${ARCH}
# SERVICE php|database|http
SERVICE ?= php
PORT ?= 8040
# NAMESPACE prefix in project's name
NAMESPACE = local
VERSION_DOTLESS = $(shell echo \${VERSION} | tr -d '.')
LICENSE ?= $(shell stty -echo; read -p "Chevereto V4 License key: " license; stty echo; echo $$license)
# Echo doing
FEEDBACK = $(shell echo 👉 V\${VERSION} \${ARCH} [PHP \${PHP}] \(\${DOCKER_USER}\))
FEEDBACK_SHORT = $(shell echo 👉 V\${VERSION} [PHP \${PHP}] \(\${DOCKER_USER}\))
# Project's name
PROJECT = ${NAMESPACE}-chevereto-build-${ARCH}

arguments:
	@echo "${FEEDBACK}"

# Tools

build-httpd: 
	@echo "👉 Downloading source httpd.conf"
	@docker run --rm httpd:2.4 cat /usr/local/apache2/conf/httpd.conf > httpd.conf
	@echo "👉 Adding chevereto.conf to httpd.conf"
	@cat chevereto.conf >> httpd.conf
	@echo "✅ httpd.conf updated"

# Docker

build:
	@echo "${FEEDBACK_SHORT}"
	@docker build . \
		--build-arg LICENSE=${LICENSE} \
		--build-arg ARCH=${ARCH} \
		-t ${TAG}

bash: arguments
	@docker exec -it --user ${DOCKER_USER} \
		${CONTAINER_BASENAME}_${SERVICE} \
		bash

log-access: arguments
	@docker logs ${CONTAINER_BASENAME}_${SERVICE} -f 2>/dev/null

log-error: arguments
	@docker logs ${CONTAINER_BASENAME}_${SERVICE} -f 1>/dev/null

# Docker compose

up: arguments
	@ARCH=${ARCH} \
	CONTAINER_BASENAME=${CONTAINER_BASENAME} \
	PORT=${PORT} \
	TAG=${TAG} \
	VERSION=${VERSION} \
	docker compose \
		-p ${PROJECT} \
		-f projects/prod.yml \
		up

up--d: arguments
	@ARCH=${ARCH} \
	CONTAINER_BASENAME=${CONTAINER_BASENAME} \
	PORT=${PORT} \
	TAG=${TAG} \
	VERSION=${VERSION} \
	docker compose \
		-p ${PROJECT} \
		-f projects/prod.yml \
		up -d
	@echo "👉 http://localhost:${PORT}"

stop: arguments
	@ARCH=${ARCH} \
	CONTAINER_BASENAME=${CONTAINER_BASENAME} \
	PORT=${PORT} \
	TAG=${TAG} \
	VERSION=${VERSION} \
	docker compose \
		-p ${PROJECT} \
		-f projects/prod.yml \
		stop

down: arguments
	@ARCH=${ARCH} \
	CONTAINER_BASENAME=${CONTAINER_BASENAME} \
	PORT=${PORT} \
	TAG=${TAG} \
	VERSION=${VERSION} \
	docker compose \
		-p ${PROJECT} \
		-f projects/prod.yml \
		down

down--volumes: arguments
	@ARCH=${ARCH} \
	CONTAINER_BASENAME=${CONTAINER_BASENAME} \
	PORT=${PORT} \
	TAG=${TAG} \
	VERSION=${VERSION} \
	docker compose \
		-p ${PROJECT} \
		-f projects/prod.yml \
		down --volumes

app-volume--flush: down
	@docker volume rm \
		${PROJECT}_app