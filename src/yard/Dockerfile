ARG DOCKER_REGISTRY_URL=docker.io
ARG DOCKER_LOGIN=sleemp
ARG BASE_IMAGE=oscript
ARG BASE_TAG=dev

FROM ${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/${BASE_IMAGE}:${BASE_TAG}
LABEL maintainer="Iosif Pravets <i@pravets.ru>"

RUN apt update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        p7zip-rar \
        p7zip-full \
    && opm i yard \
    && rm -rf  \
        /var/lib/apt/lists/* \
        /var/cache/debconf

ENTRYPOINT ["yard"]