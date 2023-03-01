NAME := $(notdir $(CURDIR))

DIR_SOURCES := $(filter-out arch%,$(filter-out template%,$(wildcard */)))

.PHONY: all name build cloud-build clean clean-adaar docker-deps git-deps tag-all docker-deps $(DIR_SOURCES)

all: build

.ONESHELL:

$(NAME):
	@echo "************************************************************************************"
	@echo "** This looks like a new install."
	@echo "************************************************************************************"
	@echo ""
	@echo "** First make sure the parent folder is named as your docker image name"
	@echo ""
	@echo "** Edit the appropiate Docker file(s) in ./templates"
	@echo "   Create a new folder in ./templates/ for each [template_name] you want."
	@echo ""
	@echo "** Create a new image dir with:"
	@echo "   bash ./new.sh [template_name] [new_name]"
	@echo ""
	@echo "************************************************************************************"


$(DIR_SOURCES):
	cd $(NAME)/$@ \
	&& $(MAKE) cloud-build

clean:
	cd $(NAME) \
	&& $(MAKE) clean

git-deps:
	cd $(NAME) \
	&& $(MAKE) git-deps

docker-deps:
	cd $(NAME) \
	&& $(MAKE) docker-deps

cloud-prep:
	cd $(NAME) \
	&& $(MAKE) cloud-build

tag-all:
	cd $(NAME) \
	&& $(MAKE) tag-all

cloud-build: $(DIR_SOURCES)

build: $(NAME)
	cd $(NAME) \
	&& $(MAKE)
