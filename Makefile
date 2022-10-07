VERSION ?= 4.0
PHP ?= 8.1
DOCKER_USER ?= www-data
HOSTNAME ?= localhost
HOSTNAME_PATH ?= /
PROTOCOL ?= http

NAMESPACE ?= local
PROJECT = ${NAMESPACE}_chevereto-build
CONTAINER_BASENAME ?= ${NAMESPACE}_chevereto-build-${VERSION}
TAG_BASENAME ?= ${NAMESPACE}_chevereto-build:${VERSION}

SERVICE ?= php
LICENSE ?= $(shell stty -echo; read -p "Chevereto V4 License key: 🔑" license; stty echo; echo $$license)

VERSION_DOTLESS = $(shell echo \${VERSION} | tr -d '.')
PHP_DOTLESS = $(shell echo \${PHP} | tr -d '.')

PORT ?= 8420
VERSION_DOTLESS = $(shell echo \${VERSION} | tr -d '.')

FEEDBACK = $(shell echo 👉 V\${VERSION} \${NAMESPACE} [PHP \${PHP}] \(\${DOCKER_USER}\))
FEEDBACK_SHORT = $(shell echo 👉 V\${VERSION} [PHP \${PHP}] \(\${DOCKER_USER}\))

ENDPOINT = ${PROTOCOL}://${HOSTNAME}
ENDPOINT_CONTEXT = ${PORT}${HOSTNAME_PATH}

URL_PROD = ${ENDPOINT}:${ENDPOINT_CONTEXT}

PROJECT ?= compose
PROJECT_COMPOSE = projects/${COMPOSE}.yml
COMPOSE_SAMPLE = projects/prod.yml
COMPOSE_FILE = $(shell [[ -f \${PROJECT_COMPOSE} ]] && echo \${PROJECT_COMPOSE} || echo \${COMPOSE_SAMPLE})

feedback:
	@./scripts/logo.sh
	@echo "${FEEDBACK}"

feedback--short:
	@echo "${FEEDBACK_SHORT}"

feedback--prod:
	@echo "${URL_PROD}"

feedback--compose:
	@echo "🐋 ${COMPOSE_FILE}"

# Docker

image: feedback--short
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

image-custom: feedback--short
	@echo "* Building PHP image"
	@docker build . \
		-f php.Dockerfile \
		-t ${TAG_BASENAME}_php
	@echo "* Building httpd image"
	@docker build . \
		-f http.Dockerfile \
		-t ${TAG_BASENAME}_http

image-httpd: feedback--short
	@echo "👉 Downloading source httpd.conf"
	@docker run --rm httpd:2.4 cat /usr/local/apache2/conf/httpd.conf > httpd/httpd.conf
	@echo "👉 Adding chevereto.conf to httpd.conf"
	@cat httpd/chevereto.conf >> httpd/httpd.conf
	@echo "✅ httpd/httpd.conf updated"

bash: feedback
	@docker exec -it --user ${DOCKER_USER} \
		${CONTAINER_BASENAME}_${SERVICE} \
		bash

log-access: feedback
	@docker logs ${CONTAINER_BASENAME}_${SERVICE} -f 2>/dev/null

log-error: feedback
	@docker logs ${CONTAINER_BASENAME}_${SERVICE} -f 1>/dev/null

# docker compose

up: feedback feedback--compose feedback--prod
	@CONTAINER_BASENAME=${CONTAINER_BASENAME} \
	PORT=${PORT} \
	TAG_BASENAME=${TAG_BASENAME} \
	VERSION=${VERSION} \
	HOSTNAME=${HOSTNAME} \
	HOSTNAME_PATH=${HOSTNAME_PATH} \
	URL_PROD=${URL_PROD} \
	docker compose \
		-p ${PROJECT} \
		-f ${COMPOSE_FILE} \
		up

up-d: feedback feedback--compose feedback--prod
	@CONTAINER_BASENAME=${CONTAINER_BASENAME} \
	PORT=${PORT} \
	TAG_BASENAME=${TAG_BASENAME} \
	VERSION=${VERSION} \
	HOSTNAME=${HOSTNAME} \
	HOSTNAME_PATH=${HOSTNAME_PATH} \
	URL_PROD=${URL_PROD} \
	docker compose \
		-p ${PROJECT} \
		-f ${COMPOSE_FILE} \
		up -d
	@echo "👉 ${URL_PROD}"

stop: feedback feedback--compose
	@CONTAINER_BASENAME=${CONTAINER_BASENAME} \
	PORT=${PORT} \
	VERSION=${VERSION} \
	docker compose \
		-p ${PROJECT} \
		-f ${COMPOSE_FILE} \
		stop

down: feedback feedback--compose
	@CONTAINER_BASENAME=${CONTAINER_BASENAME} \
	PORT=${PORT} \
	VERSION=${VERSION} \
	docker compose \
		-p ${PROJECT} \
		-f ${COMPOSE_FILE} \
		down

down--volumes: feedback feedback--compose
	@CONTAINER_BASENAME=${CONTAINER_BASENAME} \
	PORT=${PORT} \
	VERSION=${VERSION} \
	docker compose \
		-p ${PROJECT} \
		-f ${COMPOSE_FILE} \
		down --volumes
