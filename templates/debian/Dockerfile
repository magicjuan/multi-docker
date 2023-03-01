ARG VERSION=build
FROM debian:$VERSION as build_image
ARG DEBIAN_FRONTEND=noninteractive

LABEL maintainer="Juan Ingles <juan.ingles@unisys.com>"
ARG VERSION

RUN mkdir /scripts
WORKDIR /scripts

