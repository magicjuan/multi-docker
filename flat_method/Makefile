# SET THESE TO OVERRIDE THE CALCULATED VERSIONS
#REPO        := $(NAME_PARENT_DIR)
#TARGET_NAME := $(NAME_SELF_DIR)

####################################
DEFAULT_TARGET ?= jammy
DEFAULT_FROM_TAG ?= jammy
DEFAULT_LABEL ?= latest
####################################

SELF_DIR := $(CURDIR)
PARENT_DIR := $(dir $(lastword $(CURDIR)))
PARENT_PARENT_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../..)


NAME_SELF_DIR := $(notdir $(notdir $(patsubst %/,%,$(SELF_DIR))))
NAME_PARENT_DIR := $(notdir $(notdir $(patsubst %/,%,$(PARENT_DIR))))


####################################
REPO ?= $(NAME_PARENT_DIR)
TARGET_NAME ?= $(NAME_SELF_DIR)
FROM_TARGET ?= base-os
####################################

NAME := $(subst img-,,$(TARGET_NAME))

_BUILD_ARGS_TAG ?= $(DEFAULT_LABEL)
_BUILD_ARGS_DOCKERFILE ?= Dockerfile


ALL_TARGETS ?= $(shell ls | grep .Dockerfile | cut -d. -f 1)

.PHONY: info build push scan runit _builder _scanner _pusher _runner build-all scan-all

all: build scan

info:
	@echo "	SELF_DIR         ${SELF_DIR}"
	@echo "	PARENT_DIR       ${PARENT_DIR}"
	@echo "	"
	@echo "	REPO             ${REPO}"
	@echo "	TARGET_NAME      ${NAME}"
	@echo "	"
	@echo "	FROM_IMAGE       ${FROM_TARGET}"
	@echo "	DEFAULT_FROM     ${FROM_TARGET}:${DEFAULT_FROM_TAG}"
	@echo "	"
	@echo "	TARGET LIST      ${ALL_TARGETS}"
	@echo "	DEFAULT_TARGET   ${DEFAULT_TARGET}:${DEFAULT_LABEL}"

scans:
	mkdir -p scans
test.env:
	touch test.env

_builder:
	docker build --tag ${REPO}/${NAME}:${_BUILD_ARGS_TAG} \
		--build-arg _BUILD_ARGS_REPO=${REPO} \
		--build-arg _BUILD_ARGS_FROM=${FROM_TARGET} \
		--build-arg _BUILD_ARGS_FROM_TAG=${_BUILD_ARGS_FROM_TAG} \
		-f ${_BUILD_ARGS_DOCKERFILE} .

_scanner: scans
	docker scout cves --format sarif --output scans/${_BUILD_ARGS_TAG}.sarif ${REPO}/${NAME}:${_BUILD_ARGS_TAG}
_runner: test.env
	docker run -it --rm --env-file test.env ${REPO}/${NAME}:${_BUILD_ARGS_TAG} bash
_tester:
	docker run -it --rm --env-file test.env ${REPO}/${NAME}:${_BUILD_ARGS_TAG} /scripts/mirror.sftp
_pusher:
	docker push ${REPO}/${NAME}:${_BUILD_ARGS_TAG}

build_%:
	$(MAKE) _builder \
		-e _BUILD_ARGS_TAG="$*" \
		-e _BUILD_ARGS_REPO="${REPO}" \
		-e _BUILD_ARGS_DOCKERFILE="$*.Dockerfile" \
		-e _BUILD_ARGS_FROM_TAG="$*"


scan_%: 
	$(MAKE) _scanner \
		 -e _BUILD_ARGS_TAG="$*" 
runit_%: 
	$(MAKE) _runner \
		 -e _BUILD_ARGS_TAG="$*" 
test_%: 
	$(MAKE) _tester \
		 -e _BUILD_ARGS_TAG="$*" 
push_%: 
	$(MAKE) _pusher \
		 -e _BUILD_ARGS_TAG="$*" 
		                     
build:
	$(MAKE) _builder \
		 -e _BUILD_ARGS_TAG="${DEFAULT_LABEL}" \
		 -e _BUILD_ARGS_FROM_TAG="${DEFAULT_FROM_TAG}" \
		 -e _BUILD_ARGS_DOCKERFILE="${DEFAULT_TARGET}.Dockerfile"
scan:
	$(MAKE) _scanner \
		 -e _BUILD_ARGS_TAG="${DEFAULT_LABEL}"	
runit:
	$(MAKE) _runner \
		 -e _BUILD_ARGS_TAG="${DEFAULT_LABEL}"
test:
	$(MAKE) _tester \
		 -e _BUILD_ARGS_TAG="${DEFAULT_LABEL}"
push:
	$(MAKE) _pusher \
		 -e _BUILD_ARGS_TAG="${DEFAULT_LABEL}"

build-all:
	for target in ${ALL_TARGETS} ; do \
    ${MAKE} build_$$target ; \
	done
	${MAKE} build
scan-all:
	for target in ${ALL_TARGETS} ; do \
    ${MAKE} scan_$$target ; \
	done
	${MAKE} scan
test-all:
	for target in ${ALL_TARGETS} ; do \
    ${MAKE} test_$$target ; \
	done
	${MAKE} test
push-all:
	for target in ${ALL_TARGETS} ; do \
    ${MAKE} push_$$target ; \
	done
	${MAKE} push
