# Default arguments
VERSION ?= 4.0
PHP ?= 8.1
DOCKER_USER ?= www-data
PROTOCOL ?= http
# NAMESPACE prefix in project's name
NAMESPACE ?= local
# Project's name
PROJECT = ${NAMESPACE}_chevereto-build
CONTAINER_BASENAME ?= ${NAMESPACE}_chevereto-build-${VERSION}
TAG_BASENAME ?= ${NAMESPACE}_chevereto-build:${VERSION}
# SERVICE php|database|http
SERVICE ?= php
LICENSE ?= $(shell stty -echo; read -p "Chevereto V4 License key: " license; stty echo; echo $$license)
PORT ?= 8040
VERSION_DOTLESS = $(shell echo \${VERSION} | tr -d '.')
# Echo doing
FEEDBACK = $(shell echo 👉 V\${VERSION} \${NAMESPACE} [PHP \${PHP}] \(\${DOCKER_USER}\))
FEEDBACK_SHORT = $(shell echo 👉 V\${VERSION} [PHP \${PHP}] \(\${DOCKER_USER}\))

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
	@chmod +x ./scripts/chevereto.sh
	@LICENSE=${LICENSE} \
	VERSION=${VERSION} \
	./scripts/chevereto.sh
	@echo "* Building httpd image"
	@rm -rf ./chevereto/app/vendor
	@docker build . \
		-f http.Dockerfile \
		-t ${TAG_BASENAME}_http
	@echo "* Building PHP image"
	@docker build . \
		-f php.Dockerfile \
		-t ${TAG_BASENAME}_php

image-build:
	@echo "${FEEDBACK_SHORT}"
	@echo "* Building PHP image"
	@docker build . \
		-f php.Dockerfile \
		-t ${TAG_BASENAME}_php
	@echo "* Building httpd image"
	@docker build . \
		-f http.Dockerfile \
		-t ${TAG_BASENAME}_http

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
	TAG_BASENAME=${TAG_BASENAME} \
	VERSION=${VERSION} \
	docker compose \
		-p ${PROJECT} \
		-f projects/prod.yml \
		up

up-d: arguments
	@CONTAINER_BASENAME=${CONTAINER_BASENAME} \
	PORT=${PORT} \
	TAG_BASENAME=${TAG_BASENAME} \
	VERSION=${VERSION} \
	docker compose \
		-p ${PROJECT} \
		-f projects/prod.yml \
		up -d
	@echo "👉 http://localhost:${PORT}"

stop: arguments
	@CONTAINER_BASENAME=${CONTAINER_BASENAME} \
	PORT=${PORT} \
	VERSION=${VERSION} \
	docker compose \
		-p ${PROJECT} \
		-f projects/prod.yml \
		stop

down: arguments
	@CONTAINER_BASENAME=${CONTAINER_BASENAME} \
	PORT=${PORT} \
	VERSION=${VERSION} \
	docker compose \
		-p ${PROJECT} \
		-f projects/prod.yml \
		down

down--volumes: arguments
	@CONTAINER_BASENAME=${CONTAINER_BASENAME} \
	PORT=${PORT} \
	VERSION=${VERSION} \
	docker compose \
		-p ${PROJECT} \
		-f projects/prod.yml \
		down --volumes
