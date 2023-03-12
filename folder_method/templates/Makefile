NAME := $(notdir $(CURDIR))
DIR_SOURCES := $(filter-out arch%,$(filter-out template%,$(wildcard */)))


.PHONY: all name build cloud-build docker-deps tag-all $(xlist) $(DIR_SOURCES)

all: build

name:
	@echo $(NAME)

$(DIR_SOURCES):
	cd $@ \
	&& $(MAKE) build

docker-deps:
	# ubuntu
	docker pull ubuntu:18.04
	docker pull ubuntu:20.04

	# debian
	docker pull debian:jessie-slim
	docker pull debian:buster-slim
	docker pull debian:bullseye-slim

	# centos
	docker pull centos:centos7
	docker pull centos:centos7.3.1611
	docker pull centos:centos8

tag-all:
	for dir in $(DIR_SOURCES) ; do \
		cd $$dir && $(MAKE) tag && cd .. ; \
	done

build:  $(DIR_SOURCES)
	@echo done.
