SOURCE ?= ~/git/chevereto/v4
TARGET ?= prod# prod|dev
VERSION ?= 4.0
PHP ?= 8.1
DOCKER_USER ?= www-data
HOSTNAME ?= localhost
HOSTNAME_PATH ?= /
PROTOCOL ?= http
NAMESPACE ?= chevereto
SERVICE ?= php

PORT ?= 8420

URL = ${PROTOCOL}://${HOSTNAME}:${PORT}/
PROJECT = $(shell [[ \${TARGET} == "prod" ]] && echo \${NAMESPACE}_chevereto || echo \${NAMESPACE}_chevereto-${TARGET})
CONTAINER_BASENAME ?= ${NAMESPACE}_chevereto-${VERSION}
TAG_BASENAME ?= ${NAMESPACE}_chevereto:${VERSION}

COMPOSE ?= docker-compose
PROJECT_COMPOSE = ${COMPOSE}.yml
COMPOSE_SAMPLE = default.yml
COMPOSE_FILE = $(shell [[ -f \${PROJECT_COMPOSE} ]] && echo \${PROJECT_COMPOSE} || echo \${COMPOSE_SAMPLE})

FEEDBACK = $(shell echo 👉 \${TARGET} V\${VERSION} \${NAMESPACE} [PHP \${PHP}] \(\${DOCKER_USER}\))
FEEDBACK_SHORT = $(shell echo 👉 \${TARGET} V\${VERSION} [PHP \${PHP}] \(\${DOCKER_USER}\))

LICENSE ?= $(shell stty -echo; read -p "Chevereto V4 License key: 🔑" license; stty echo; echo $$license)

DOCKER_COMPOSE = $(shell echo docker compose -p \${PROJECT} -f \${COMPOSE_FILE})

feedback:
	@./scripts/logo.sh
	@echo "${FEEDBACK}"

feedback--short:
	@echo "${FEEDBACK_SHORT}"

feedback--compose:
	@echo "🐋 ${COMPOSE_FILE}"

feedback--url:
	@echo "🌎 ${URL}"

feedback--volumes:
	@echo "${PROJECT}_database"
	@echo "${PROJECT}_assets"
	@echo "${PROJECT}_storage"

# Docker

image: feedback--short
	@chmod +x ./scripts/chevereto.sh
	@LICENSE=${LICENSE} \
	VERSION=${VERSION} \
	./scripts/chevereto.sh
	@echo "* Building PHP image"
	@docker build . \
		-f Dockerfile \
		-t ${TAG_BASENAME}_php

image-custom: feedback--short
	@echo "* Building PHP image"
	@docker build . \
		-f Dockerfile \
		-t ${TAG_BASENAME}_php

volume-cp:
	docker run --rm -it -v ${VOLUME_FROM}:/from -v ${VOLUME_TO}:/to alpine ash -c "cd /from ; cp -av . /to"

volume-rm:
	docker volume rm ${VOLUME}

bash: feedback
	@docker exec -it --user ${DOCKER_USER} \
		${CONTAINER_BASENAME}_${SERVICE} \
		bash

log-access: feedback
	@docker logs ${CONTAINER_BASENAME}_${SERVICE} -f 2>/dev/null

log-error: feedback
	@docker logs ${CONTAINER_BASENAME}_${SERVICE} -f 1>/dev/null

# docker compose

up: feedback feedback--compose feedback--url
	@CONTAINER_BASENAME=${CONTAINER_BASENAME} \
	PORT=${PORT} \
	TAG_BASENAME=${TAG_BASENAME} \
	VERSION=${VERSION} \
	HOSTNAME=${HOSTNAME} \
	HOSTNAME_PATH=${HOSTNAME_PATH} \
	URL=${URL} \
	${DOCKER_COMPOSE} up

up-d: feedback feedback--compose feedback--url
	@CONTAINER_BASENAME=${CONTAINER_BASENAME} \
	PORT=${PORT} \
	TAG_BASENAME=${TAG_BASENAME} \
	VERSION=${VERSION} \
	HOSTNAME=${HOSTNAME} \
	HOSTNAME_PATH=${HOSTNAME_PATH} \
	URL=${URL} \
	${DOCKER_COMPOSE} up -d

stop: feedback feedback--compose
	@CONTAINER_BASENAME=${CONTAINER_BASENAME} \
	PORT=${PORT} \
	VERSION=${VERSION} \
	${DOCKER_COMPOSE} stop

start: feedback feedback--compose
	@CONTAINER_BASENAME=${CONTAINER_BASENAME} \
	PORT=${PORT} \
	VERSION=${VERSION} \
	${DOCKER_COMPOSE} start

restart: feedback feedback--compose
	@CONTAINER_BASENAME=${CONTAINER_BASENAME} \
	PORT=${PORT} \
	VERSION=${VERSION} \
	${DOCKER_COMPOSE} restart

down: feedback feedback--compose
	@CONTAINER_BASENAME=${CONTAINER_BASENAME} \
	PORT=${PORT} \
	VERSION=${VERSION} \
	${DOCKER_COMPOSE} down

down--volumes: feedback feedback--compose
	@CONTAINER_BASENAME=${CONTAINER_BASENAME} \
	PORT=${PORT} \
	VERSION=${VERSION} \
	${DOCKER_COMPOSE} down --volumes
