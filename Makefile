#!make
SYSTEM ?= ubuntu/22.04
ENV_FILE = ./.env
NAMESPACE ?= chevereto
NAMESPACE_FILE = ./namespace/${NAMESPACE}
NAMESPACE_FILE_EXISTS = false
ifneq ("$(wildcard ${NAMESPACE_FILE})","")
	NAMESPACE_FILE_EXISTS = true
	include ${NAMESPACE_FILE}
	export $(shell sed 's/=.*//' ${NAMESPACE_FILE})
endif
ifneq ("$(wildcard ${ENV_FILE})","")
	include ${ENV_FILE}
	export $(shell sed 's/=.*//' ${ENV_FILE})
endif
SOURCE ?= ~/git/chevereto/v4
TARGET ?= default# default|dev
VERSION ?= 4.0
PHP ?= 8.2
EDITION ?= pro
DOCKER_USER ?= www-data
HOSTNAME ?= localhost
HOSTNAME_PATH ?= /
PROTOCOL ?= https
SERVICE ?= php
ENCRYPTION_KEY ?=
EMAIL_HTTPS ?= mail@yourdomain.tld
DB_PORT ?= 8836
HTTP_PORT ?= 80
HTTPS_PORT ?= 443
PORT = $(shell [ "${PROTOCOL}" = "http" ] && echo \${HTTP_PORT} || echo \${HTTPS_PORT})
HTTPS = $(shell [ "${PROTOCOL}" = "http" ] && echo 0 || echo 1)
HTTPS_CERT = https/$(shell [ -f "https/cert.pem" ] && echo || echo dummy/)cert.pem
HTTPS_KEY = https/$(shell [ -f "https/key.pem" ] && echo || echo dummy/)key.pem
URL_BARE = ${PROTOCOL}://${HOSTNAME}${HOSTNAME_PATH}
URL_PORT = ${PROTOCOL}://${HOSTNAME}:${PORT}${HOSTNAME_PATH}
URL = $(shell [ "${PORT}" = 80 -o "${PORT}" = 443 ] && echo ${URL_BARE} || echo ${URL_PORT})
PROJECT = ${NAMESPACE}_chevereto$(shell [ ! "${TARGET}" = "default" ] && echo -\${TARGET})
CONTAINER_BASENAME = ${PROJECT}-${VERSION}
IMAGE_EDITION_FREE_BASE = ghcr.io/chevereto/chevereto
IMAGE_NAME = chevereto$(shell [ ! "${TARGET}" = "default" ] && echo -\${TARGET})
IMAGE ?= $(shell [ "${EDITION}" = "free" ] && echo \${IMAGE_EDITION_FREE_BASE} || echo \${IMAGE_NAME}):${VERSION}
COMPOSE ?= docker-compose
COMPOSE_TARGET = ${COMPOSE}.yml
COMPOSE_SAMPLE = $(shell [ "${TARGET}" = "default" ] && echo default || echo dev).yml
COMPOSE_FILE = $(shell [ -f \${COMPOSE_TARGET} ] && echo \${COMPOSE_TARGET} || echo \${COMPOSE_SAMPLE})
FEEDBACK = $(shell echo 👉 \${TARGET} \${CONTAINER_BASENAME} @\${NAMESPACE_FILE} V\${VERSION} \(\${DOCKER_USER}\))
FEEDBACK_SHORT = $(shell echo 👉 \${TARGET} V\${VERSION} \(\${DOCKER_USER}\))
LICENSE ?= $(shell stty -echo; read -p "Chevereto V4 License key (if any): 🔑" license; stty echo; echo $$license)
DOCKER_COMPOSE = $(shell echo @CONTAINER_BASENAME=\${CONTAINER_BASENAME} \
	SOURCE=\${SOURCE} \
	DB_PORT=\${DB_PORT} \
	HTTP_PORT=\${HTTP_PORT} \
	HTTPS_PORT=\${HTTPS_PORT} \
	HTTPS_CERT=\${HTTPS_CERT} \
	HTTPS_KEY=\${HTTPS_KEY} \
	HTTPS=\${HTTPS} \
	IMAGE=\${IMAGE} \
	VERSION=\${VERSION} \
	HOSTNAME=\${HOSTNAME} \
	HOSTNAME_PATH=\${HOSTNAME_PATH} \
	URL=\${URL} \
	docker compose -p \${PROJECT} -f \${COMPOSE_FILE})

# Informational

feedback:
	@./scripts/chevereto/logo.sh
	@echo "${FEEDBACK}"

feedback--short:
	@echo "${FEEDBACK_SHORT}"

feedback--compose: feedback--image
	@echo "🐋 ${COMPOSE_FILE}"

feedback--url:
	@echo "🔌 ${PORT}"
	@echo "${URL} @URL"

feedback--image:
	@echo "📦 ${IMAGE} (BASE ${IMAGE_NAME})"

feedback--volumes:
	@echo "${PROJECT}_database"
	@echo "${PROJECT}_storage"

feedback--namespace:
	@echo "$(shell [ "${NAMESPACE_FILE_EXISTS}" = "true" ] && echo "✅" || echo "❌") ${NAMESPACE_FILE}"
	@echo "🔑 ${ENCRYPTION_KEY}"
	@echo "🌎 ${HOSTNAME}"

# Docker

image: feedback--image feedback--short
	@LICENSE=${LICENSE} \
	VERSION=${VERSION} \
	IMAGE_NAME=${IMAGE_NAME} \
	./scripts/system/chevereto.sh \
	docker build . \
		--cache-from ${IMAGE_EDITION_FREE_BASE}:${VERSION} \
		--network host \
		-f Dockerfile

image-custom: feedback--image feedback--short
	@mkdir -p chevereto
	echo "* Building custom image ${IMAGE}"
	@docker build . \
		--cache-from ${IMAGE_EDITION_FREE_BASE}:${VERSION}\
		--network host \
		--build-arg PHP=${PHP} \
		-f Dockerfile \
		-t ${IMAGE}

volume-cp:
	@docker run --rm -it -v ${VOLUME_FROM}:/from -v ${VOLUME_TO}:/to alpine ash -c "cd /from ; cp -av . /to"

volume-rm:
	@docker volume rm ${VOLUME}

# Logs

log: feedback
	@docker logs -f ${CONTAINER_BASENAME}_${SERVICE}

log-access: feedback
	@docker logs ${CONTAINER_BASENAME}_${SERVICE} -f 2>/dev/null

log-error: feedback
	@docker logs ${CONTAINER_BASENAME}_${SERVICE} -f 1>/dev/null

# Tools

bash: feedback
	@docker exec -it --user ${DOCKER_USER} \
		${CONTAINER_BASENAME}_${SERVICE} \
		bash

exec: feedback
	@docker exec -it --user ${DOCKER_USER} \
		${CONTAINER_BASENAME}_${SERVICE} \
		${COMMAND}

run: feedback
	@docker exec -it \
		${CONTAINER_BASENAME}_${SERVICE} \
		bash /var/scripts/${SCRIPT}.sh

cron:
	@./scripts/system/cron.sh

cron--run:
	@./scripts/system/cron--run.sh

cloudflare:
	@./scripts/system/cloudflare.sh

cloudflare--create:
	@./scripts/system/cloudflare--create.sh | (printf "CLOUDFLARE_IDENTIFIER=" && cat) >> ${NAMESPACE_FILE}

cloudflare--delete:
	@./scripts/system/cloudflare--delete.sh

encryption-key:
	@openssl rand -base64 32

install-docker:
	@SYSTEM=${SYSTEM} \
	./scripts/os/${SYSTEM}/install-docker.sh

.PHONY: namespace
namespace:
	@chmod +x ./scripts/system/namespace.sh
	@NAMESPACE=${NAMESPACE} \
	NAMESPACE_EXISTS=${NAMESPACE_EXISTS} \
	NAMESPACE_FILE=${NAMESPACE_FILE} \
	HOSTNAME=${HOSTNAME} \
	ENCRYPTION_KEY=${ENCRYPTION_KEY} \
	./scripts/system/namespace.sh

# Docker compose

up: feedback feedback--compose feedback--url
	${DOCKER_COMPOSE} up

up-d: feedback feedback--compose feedback--url
	${DOCKER_COMPOSE} up -d

stop: feedback feedback--compose
	${DOCKER_COMPOSE} stop

start: feedback feedback--compose
	${DOCKER_COMPOSE} start

restart: feedback feedback--compose
	${DOCKER_COMPOSE} restart

down: feedback feedback--compose
	${DOCKER_COMPOSE} down

down--volumes: feedback feedback--compose
	${DOCKER_COMPOSE} down --volumes

# Instances

spawn: feedback feedback--compose feedback--url cloudflare--create up-d

destroy: feedback feedback--compose cloudflare--delete
	${DOCKER_COMPOSE} down --volumes
	@rm namespace/${NAMESPACE}

# nginx-proxy

proxy:
	@docker network create nginx-proxy || true
	@docker run \
		--detach \
		--name nginx-proxy \
		--net nginx-proxy \
		--publish 80:80 \
		--publish 443:443 \
		--restart=always \
		--volume certs:/etc/nginx/certs \
		--volume vhost:/etc/nginx/vhost.d \
		--volume html:/usr/share/nginx/html \
		--mount type=bind,source=/var/run/docker.sock,target=/tmp/docker.sock,readonly \
		--mount type=bind,source=${PWD}/nginx/chevereto.conf,target=/etc/nginx/conf.d/chevereto.conf,readonly \
		--mount type=bind,source=${PWD}/nginx/cloudflare.conf,target=/etc/nginx/conf.d/cloudflare.conf,readonly \
		nginxproxy/nginx-proxy
	@docker run \
		--detach \
		--name nginx-proxy-acme \
		--restart=always \
		--volumes-from nginx-proxy \
		--volume acme:/etc/acme.sh \
		--mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock,readonly \
		--env "DEFAULT_EMAIL=${EMAIL_HTTPS}" \
		nginxproxy/acme-companion

proxy--view:
	@docker exec nginx-proxy cat /etc/nginx/conf.d/default.conf

proxy--remove:
	@docker container rm -f nginx-proxy nginx-proxy-acme || true
	@docker network rm nginx-proxy || true

