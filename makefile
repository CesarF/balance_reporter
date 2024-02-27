.PHONY: \
	build \
	push \
	login \
	test \

WORKSPACE := dev
PWD := $(shell pwd)
APP_VERSION := $(shell poetry --directory=${PWD}/app version --short)
APP_NAME := $(shell poetry --directory=${PWD}/app version | cut -d ' ' -f1)
CH_DIR := ${PWD}/infra/stacks/${STACK}
TF_VAR_FILE := ${CH_DIR}/workspaces/${WORKSPACE}/terraform.tfvars
TF_BACKEND_FILE := ${CH_DIR}/workspaces/${WORKSPACE}/backend.tfvars

EXTRA_VARS ?=
STAGE ?= local
REGION ?= us-east-1

login:
	aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com

build:
	docker build --rm --platform linux/amd64 -t ${APP_NAME}:${APP_VERSION} -f ${PWD}/app/Dockerfile --target ${STAGE} --label version=${APP_VERSION} ${PWD}/app

run:
	APP_IMAGE=${APP_NAME}:${APP_VERSION} VOLUME_PATH=${PWD}/data/ REGION=${REGION} docker compose --env-file local.env up

push:
	docker tag ${APP_NAME}:${APP_VERSION} ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${APP_NAME}-${WORKSPACE}:${APP_VERSION}
	docker push ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${APP_NAME}-${WORKSPACE}:${APP_VERSION}

test:
	docker build --rm --platform linux/amd64 -t local-test-${APP_NAME}:${APP_VERSION} -f ${PWD}/app/Dockerfile --target pytest ${PWD}/app
	docker run --rm -ti --platform linux/amd64 local-test-${APP_NAME}:${APP_VERSION}
	docker rmi -f local-test-${APP_NAME}:${APP_VERSION}
	docker rmi -f $(shell docker images -f "dangling=true" -q)

upload:
	aws s3 cp ${PWD}/data s3://${BUCKET} --recursive --acl public-read --region ${REGION}

tf-init:
	terraform -chdir=${CH_DIR} init -reconfigure
	terraform -chdir=${CH_DIR} workspace new ${WORKSPACE} || terraform -chdir=${CH_DIR} workspace select ${WORKSPACE}

tf-fmt:
	terraform fmt -write=true -recursive infra

tf-plan:
	terraform -chdir=${CH_DIR} plan ${EXTRA_VARS} -out=.plan

tf-deploy:
	terraform -chdir=${CH_DIR} apply .plan

tf-destroy:
	terraform -chdir=${CH_DIR} destroy ${EXTRA_VARS}

tf-validate:
	terraform -chdir=${CH_DIR} validate
