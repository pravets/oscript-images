ARG DOCKER_REGISTRY_URL=docker.io
ARG DOCKER_LOGIN=sleemp
ARG BASE_IMAGE=oscript
ARG BASE_TAG=dev

FROM ${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/${BASE_IMAGE}:${BASE_TAG}
LABEL maintainer="Iosif Pravets <i@pravets.ru>"

RUN opm i winow winow-cli
WORKDIR /app
COPY ./src/winow/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
VOLUME [ "/app" ]
EXPOSE 3333

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]