#!make
SYSTEM ?= ubuntu/22.04
ENV_FILE = ./.env
DOMAIN ?= localhost
NAMESPACE ?= chevereto
NAMESPACE_FILE = ./namespace/${NAMESPACE}
NAMESPACE_FILE_EXISTS = false
CHEVERETO_LICENSE_KEY ?= ""
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
VERSION ?= 4.3
PHP ?= 8.2
EDITION ?= $(shell [ "${CHEVERETO_LICENSE_KEY}" = "" ] && echo free || echo pro)
DOCKER_USER ?= www-data
HOSTNAME ?= localhost
HOSTNAME_PATH ?= /
PROTOCOL ?= https
SERVICE ?= php
ENCRYPTION_KEY ?=
EMAIL_HTTPS ?= mail@yourdomain.tld
# dev ports, none of these exposed on production
DB_PORT ?= 8836
REDIS_PORT ?= 8869
# http ports
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
CHEVERETO_LICENSE ?= $(shell stty -echo; read -p "Chevereto V4 License key (for paid edition): 🔑" license; stty echo; echo $$license)
DOCKER_COMPOSE = $(shell echo @CONTAINER_BASENAME=\${CONTAINER_BASENAME} \
	SOURCE=\${SOURCE} \
	DB_PORT=\${DB_PORT} \
	REDIS_PORT=\${REDIS_PORT} \
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
	@echo "Protocol ${PROTOCOL} (:${PORT})"
	@echo "@URL ${URL}"

feedback--image:
	@echo "📦 ${IMAGE} (BASE ${IMAGE_NAME})"

feedback--volumes:
	@echo "${PROJECT}_database"
	@echo "${PROJECT}_storage"

feedback--namespace:
	@echo "$(shell [ "${NAMESPACE_FILE_EXISTS}" = "true" ] && echo "✅" || echo "❌") ${NAMESPACE_FILE}"
	@echo "🔑 ${ENCRYPTION_KEY}"
	@echo "🌎 ${HOSTNAME}"

# Repo

sync:
	@./scripts/chevereto/logo.sh
	@echo "🔄 Syncing with remote repository (rebase+autostash)"
	@git remote -v
	@git fetch --tags -f && git pull --rebase --autostash
	@echo "Listing available branches..."
	@git --no-pager branch --sort=-committerdate
	@echo '[OK] Run `git switch <branch>` to change branch if needed'

# Docker

image: feedback--image feedback--short
	@CHEVERETO_LICENSE_KEY=${CHEVERETO_LICENSE_KEY} \
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
		--network host \
		--build-arg PHP=${PHP} \
		-f Dockerfile \
		-t ${IMAGE}

volume-cp:
	@docker run --rm -it -v ${VOLUME_FROM}:/from -v ${VOLUME_TO}:/to alpine ash -c "cd /from ; cp -av . /to"

volume-rm:
	${DOCKER_COMPOSE} down
	@docker volume rm ${VOLUME}
	${DOCKER_COMPOSE} up -d

volume-rm-service:
	${DOCKER_COMPOSE} down
	@docker volume rm ${PROJECT}_${SERVICE}
	${DOCKER_COMPOSE} up -d

volume-backup-service:
	@mkdir -p ./backup
	${DOCKER_COMPOSE} down
	@docker run --rm -it -v ${PROJECT}_${SERVICE}:/volume -v ./backup:/backup alpine ash -c "cd /volume ; tar czvf /backup/${PROJECT}_${SERVICE}.tar.gz ."
	${DOCKER_COMPOSE} up -d
	@echo "📦 Backup created at ./backup/${PROJECT}_${SERVICE}.tar.gz"

volume-restore-service:
	@mkdir -p ./backup
	@if [ ! -f "./backup/${PROJECT}_${SERVICE}.tar.gz" ]; then \
			echo "Backup file ./backup/${PROJECT}_${SERVICE}.tar.gz not found"; \
			exit 1; \
		fi
		@echo "📦 Using backup file ./backup/${PROJECT}_${SERVICE}.tar.gz"
	${DOCKER_COMPOSE} down
	@docker run --rm -it -v ${PROJECT}_${SERVICE}:/volume -v ./backup:/backup alpine ash -c "cd /volume ; tar xzvf /backup/${PROJECT}_${SERVICE}.tar.gz -C /volume"
	${DOCKER_COMPOSE} up -d

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
	@NAMESPACE_FILE=${NAMESPACE_FILE} ./scripts/system/cloudflare--create.sh

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

.PHONY: env
env:
	@chmod +x ./scripts/system/env.sh
	@ENV_FILE=${ENV_FILE} ./scripts/system/env.sh

setup: cron proxy

# Docker compose

up: feedback--compose feedback--url
	${DOCKER_COMPOSE} up

re-up: feedback--compose feedback--url
	${DOCKER_COMPOSE} down
	${DOCKER_COMPOSE} up -d

up-d: feedback--compose feedback--url
	${DOCKER_COMPOSE} up -d

re-up-d: feedback--compose feedback--url
	${DOCKER_COMPOSE} down
	${DOCKER_COMPOSE} up -d

stop: feedback--compose
	${DOCKER_COMPOSE} stop

start: feedback--compose
	${DOCKER_COMPOSE} start

restart: feedback--compose
	${DOCKER_COMPOSE} restart

down: feedback--compose
	${DOCKER_COMPOSE} down

down--volumes: feedback--compose
	${DOCKER_COMPOSE} down --volumes

# Instances

.PHONY: deploy
deploy:
	@./scripts/system/deploy.sh

update: feedback--compose feedback--url
	@./scripts/system/update.sh

destroy: feedback--compose cloudflare--delete
	${DOCKER_COMPOSE} down --volumes
	@rm namespace/${NAMESPACE}

install: feedback--short
	docker exec -it --user ${DOCKER_USER} \
		${CONTAINER_BASENAME}_${SERVICE} \
		app/bin/cli -C install -u "${ADMIN_USER}" -e "${ADMIN_EMAIL}" -x "${ADMIN_PASSWORD}"

# Database

database-backup:
	@mkdir -p ./backup
	@docker exec ${CONTAINER_BASENAME}_database \
		sh -c 'if command -v mysqldump >/dev/null 2>&1; then \
			mysqldump -u root -ppassword chevereto; \
		elif command -v mariadb-dump >/dev/null 2>&1; then \
			mariadb-dump -u root -ppassword chevereto; \
		else \
			echo "No dump tool found in container" >&2; exit 1; \
		fi' \
	| gzip > ./backup/${NAMESPACE}_chevereto.sql.gz
	@echo "🐬 Database backup created at ./backup/${NAMESPACE}_chevereto.sql.gz"

database-restore:
	@mkdir -p ./backup
	@echo "🔍 Checking dump file..."
	@ls -lh ./backup/${NAMESPACE}_chevereto.sql.gz
	@echo "🔍 First 20 lines of decompressed dump:"
	@gzip -dc ./backup/${NAMESPACE}_chevereto.sql.gz | head -n 20
	@docker exec ${CONTAINER_BASENAME}_database sh -c 'command -v mysql || command -v mariadb || echo "no client found"'
	@gzip -dc ./backup/${NAMESPACE}_chevereto.sql.gz | \
		docker exec -i ${CONTAINER_BASENAME}_database \
		sh -c 'set -x; \
			if command -v mysql >/dev/null 2>&1; then \
				mysql -u root -ppassword chevereto; \
			elif command -v mariadb >/dev/null 2>&1; then \
				mariadb -u root -ppassword chevereto; \
			else \
				echo "Neither mysql nor mariadb client found in container" >&2; exit 1; \
			fi'

# kv

redis-flush:
	@docker exec -e REDISCLI_AUTH=redis_password -it ${CONTAINER_BASENAME}_redis redis-cli FLUSHALL

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

