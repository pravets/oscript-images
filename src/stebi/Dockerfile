ARG DOCKER_REGISTRY_URL=docker.io
ARG DOCKER_LOGIN=sleemp
ARG BASE_IMAGE=oscript
ARG BASE_TAG=dev

FROM ${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/${BASE_IMAGE}:${BASE_TAG}
LABEL maintainer="Iosif Pravets <i@pravets.ru>"

RUN opm i stebi; 

ENTRYPOINT ["stebi"]
CMD ["--help"]
