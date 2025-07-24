ARG DOCKER_REGISTRY_URL=docker.io
ARG DOCKER_LOGIN=yourlogin
ARG BASE_IMAGE=yard
ARG BASE_TAG=latest

FROM ${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/${BASE_IMAGE}:${BASE_TAG}
LABEL maintainer="Iosif Pravets <i@pravets.ru>"
 
WORKDIR /app
COPY ./src/onec-installer-downloader/downloader.sh /app/downloader.sh
ENV PATH="/app:${PATH}"

VOLUME [ "/tmp/downloads" ]
VOLUME [ "/distr" ]

ENTRYPOINT ["downloader.sh"]