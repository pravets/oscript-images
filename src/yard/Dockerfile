ARG DOCKER_REGISTRY_URL=docker.io
ARG DOCKER_LOGIN=sleemp
ARG BASE_IMAGE=oscript
ARG BASE_TAG=dev

FROM ${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/${BASE_IMAGE}:${BASE_TAG}
LABEL maintainer="Iosif Pravets <i@pravets.ru>"

RUN set -e; \
    apt-get update -qq; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        p7zip-rar \
        p7zip-full; \
    opm i yard; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /var/cache/debconf

ENTRYPOINT ["yard"]