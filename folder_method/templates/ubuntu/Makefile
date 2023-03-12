SELF_DIR := $(dir $(lastword $(CURDIR)))
NAME := $(notdir $(notdir $(patsubst %/,%,$(SELF_DIR))))

VERSION := $(or $(TARGET),$(notdir $(CURDIR)))

REPO := ucarepocimageregistry.azurecr.io

.PHONY: all cloud-build build scan tag test run liverun dep-pkg tag-latest

all: build

cloud-build:
	@echo Ready to build docker $(NAME):$(VERSION)

build:
	docker build -t $(NAME):$(VERSION) --rm .  --build-arg VERSION=$(VERSION)


scan:
	docker.exe scan $(NAME):$(VERSION)

tag:
	docker tag $(NAME):$(VERSION) $(REPO)/$(NAME):$(VERSION)
	#docker push $(REPO)/$(NAME):$(VERSION)

test: build
	docker run \
		-v $(target_dir)/exports:/usr/depot/exports \
		-it --rm $(NAME):$(VERSION) $(RUN_ARGS) perl test.pl

target_dir = $(shell pwd)

run:
	docker run \
		-v $(target_dir)/exports:/usr/depot/exports \
		-it --rm $(NAME):$(VERSION) $(RUN_ARGS)

liverun: build
	docker run \
		-v $(target_dir)/exports:/usr/depot/exports \
		-it --rm $(NAME):$(VERSION) $(RUN_ARGS)

dep-pkg:
	cd ../../buildfarm/pkg-perlenv \
    && $(MAKE) build deploy \
    && cp ~/adaar/buildfarm/pkg-perlenv/distro/pkg.perlenv_5.20.3.tgz .


tag-latest:
	docker tag  $(NAME):$(VERSION) $(NAME):latest
