ARG DOCKER_REGISTRY_URL=docker.io
ARG DOCKER_LOGIN=sleemp
ARG BASE_IMAGE=oscript
ARG BASE_TAG=stable

FROM ${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/${BASE_IMAGE}:${BASE_TAG}
LABEL maintainer="Iosif Pravets <i@pravets.ru>"

RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/debconf \
    && opm i opm winow winow-cli
WORKDIR /app
COPY ./src/winow/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
VOLUME [ "/app" ]
EXPOSE 3333

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD curl -f http://localhost:3333/ || exit 1

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]