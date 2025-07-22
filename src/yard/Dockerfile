ARG DOCKER_REGISTRY_URL
ARG BASE_IMAGE=oscript
ARG BASE_TAG=dev

FROM ${DOCKER_REGISTRY_URL}/${BASE_IMAGE}:${BASE_TAG}
LABEL maintainer="Iosif Pravets <i@pravets.ru>"

RUN opm i yard

ENTRYPOINT ["yard"]