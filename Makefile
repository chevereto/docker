# Default arguments
VERSION ?= 4.0
PHP ?= 8.1
DOCKER_USER ?= www-data
PROTOCOL ?= http
CONTAINER_BASENAME ?= chevereto-build-${VERSION}
TAG ?= chevereto-build:${VERSION}-${NAMESPACE}
# SERVICE php|database|http
SERVICE ?= php
PORT ?= 8040
# NAMESPACE prefix in project's name
NAMESPACE = local
VERSION_DOTLESS = $(shell echo \${VERSION} | tr -d '.')
LICENSE ?= $(shell stty -echo; read -p "Chevereto V4 License key: " license; stty echo; echo $$license)
# Echo doing
FEEDBACK = $(shell echo 👉 V\${VERSION} \${NAMESPACE} [PHP \${PHP}] \(\${DOCKER_USER}\))
FEEDBACK_SHORT = $(shell echo 👉 V\${VERSION} [PHP \${PHP}] \(\${DOCKER_USER}\))
# Project's name
PROJECT = ${NAMESPACE}-chevereto-build

arguments:
	@echo "${FEEDBACK}"

# Tools

build-httpd: 
	@echo "👉 Downloading source httpd.conf"
	@docker run --rm httpd:2.4 cat /usr/local/apache2/conf/httpd.conf > httpd/httpd.conf
	@echo "👉 Adding chevereto.conf to httpd.conf"
	@cat httpd/chevereto.conf >> httpd/httpd.conf
	@echo "✅ httpd/httpd.conf updated"

# Docker

image:
	@echo "${FEEDBACK_SHORT}"
	@docker build . \
		--build-arg LICENSE=${LICENSE} \
		-t ${TAG}

bash: arguments
	@docker exec -it --user ${DOCKER_USER} \
		${CONTAINER_BASENAME}_${SERVICE} \
		bash

log-access: arguments
	@docker logs ${CONTAINER_BASENAME}_${SERVICE} -f 2>/dev/null

log-error: arguments
	@docker logs ${CONTAINER_BASENAME}_${SERVICE} -f 1>/dev/null

# docker compose

up: arguments
	@CONTAINER_BASENAME=${CONTAINER_BASENAME} \
	PORT=${PORT} \
	TAG=${TAG} \
	VERSION=${VERSION} \
	docker compose \
		-p ${PROJECT} \
		-f projects/prod.yml \
		up

up--d: arguments
	@CONTAINER_BASENAME=${CONTAINER_BASENAME} \
	PORT=${PORT} \
	TAG=${TAG} \
	VERSION=${VERSION} \
	docker compose \
		-p ${PROJECT} \
		-f projects/prod.yml \
		up -d
	@echo "👉 http://localhost:${PORT}"

stop: arguments
	@CONTAINER_BASENAME=${CONTAINER_BASENAME} \
	PORT=${PORT} \
	TAG=${TAG} \
	VERSION=${VERSION} \
	docker compose \
		-p ${PROJECT} \
		-f projects/prod.yml \
		stop

down: arguments
	@CONTAINER_BASENAME=${CONTAINER_BASENAME} \
	PORT=${PORT} \
	TAG=${TAG} \
	VERSION=${VERSION} \
	docker compose \
		-p ${PROJECT} \
		-f projects/prod.yml \
		down

down--volumes: arguments
	@CONTAINER_BASENAME=${CONTAINER_BASENAME} \
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