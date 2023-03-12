
SELF_DIR := $(CURDIR)
PARENT_DIR := $(dir $(lastword $(CURDIR)))
PARENT_PARENT_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../..)


NAME_SELF_DIR := $(notdir $(notdir $(patsubst %/,%,$(SELF_DIR))))
NAME_PARENT_DIR := $(notdir $(notdir $(patsubst %/,%,$(PARENT_DIR))))


####################################
REPO := $(NAME_PARENT_DIR)
NAME := $(NAME_SELF_DIR)
DEFAULT_TARGET := alpine
DEFAULT_LABEL := latest
####################################

_BUILD_ARGS_TAG ?= $(DEFAULT_LABEL)
_BUILD_ARGS_DOCKERFILE ?= Dockerfile


ALL_TARGETS ?= $(shell ls | grep Dockerfile. | cut -d. -f 2)

.PHONY: info build push scan runit _builder _scanner _pusher _runner build-all scan-all

all: build scan

info:
	@echo "	SELF_DIR         ${SELF_DIR}"
	@echo "	PARENT_DIR       ${PARENT_DIR}"
	@echo "	"
	@echo "	REPO             ${REPO}"
	@echo "	NAME             ${NAME}"
	@echo "	"
	@echo "	TARGETS          ${ALL_TARGETS}"
	@echo "	DEFAULT_TARGET   ${DEFAULT_TARGET}"
	@echo "	DEFAULT_LABEL    ${DEFAULT_LABEL}"

scans:
	mkdir -p scans
	
_builder:
	docker build --tag ${REPO}/${NAME}:${_BUILD_ARGS_TAG} -f ${_BUILD_ARGS_DOCKERFILE} .

_scanner: scans
	docker scout cves --format sarif --output scans/${_BUILD_ARGS_TAG}.sarif ${REPO}/${NAME}:${_BUILD_ARGS_TAG}
 
_runner:
	docker run -it --rm ${REPO}/${NAME}:${_BUILD_ARGS_TAG}

build_%:
	$(MAKE) _builder \
		 -e _BUILD_ARGS_TAG="$*" \
		 -e _BUILD_ARGS_DOCKERFILE="Dockerfile.$*"
		 
scan_%: 
	$(MAKE) _scanner \
		 -e _BUILD_ARGS_TAG="$*" 
		 
runit_%: 
	$(MAKE) _runner \
		 -e _BUILD_ARGS_TAG="$*" 
		                     

build:
	$(MAKE) _builder \
		 -e _BUILD_ARGS_TAG="${DEFAULT_LABEL}" \
		 -e _BUILD_ARGS_DOCKERFILE="Dockerfile.${DEFAULT_TARGET}"
	
scan:
	$(MAKE) _scanner \
		 -e _BUILD_ARGS_TAG="${DEFAULT_LABEL}"	
runit:
	$(MAKE) _runner \
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