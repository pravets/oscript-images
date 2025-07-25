#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -z "${CI:-}" ]; then
    echo "The script is not running in CI"
    source "${SCRIPT_DIR}/../scripts/load_env.sh"	
else
    echo "The script is running in CI";
fi

source "${SCRIPT_DIR}/../scripts/docker_login.sh"
source "${SCRIPT_DIR}/../tools/assert.sh"

if [[ "${DOCKER_SYSTEM_PRUNE:-}" = "true" ]] ;
then
    docker system prune -af
fi

last_arg="."
if [[ ${NO_CACHE:-} = "true" ]] ; then
	last_arg="--no-cache ."
fi

oscript_version="${OSCRIPT_VERSION}"

docker build \
    --pull \
    --build-arg OSCRIPT_VERSION="${oscript_version}" \
    -t "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/oscript:${oscript_version}" \
    -f "${SCRIPT_DIR}/oscript/Dockerfile" \
    ${last_arg}

if ./tests/test-oscript.sh; then
    container_version=$(docker run --rm  "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/oscript:${oscript_version}" -v | head -n1 | awk '{print $NF}')

    if [[ -n "${container_version}" ]]; then
        docker push "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/oscript:${oscript_version}"

        container_version="$(echo "$container_version" | sed 's/+/_/g')"
        docker tag "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/oscript:${oscript_version}" "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/oscript:${container_version}"
        docker push "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/oscript:${container_version}"

        if ! [[ "${oscript_version}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] && ! [[ "${container_version}" =~ rc ]]; then
            semver_tag=$(echo "${container_version}" | awk -F. '{print $1"."$2"."$3}')
            if [[ -n "${semver_tag}" ]]; then
                docker tag "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/oscript:${oscript_version}" "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/oscript:${semver_tag}"
                docker push "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/oscript:${semver_tag}"
            else
                log_failure "Не удалось получить корректную semver версию из контейнера"
                exit 1
            fi
        fi

    else
        log_failure "Не удалось получить версию из контейнера"
        exit 1
    fi
    source "${SCRIPT_DIR}/../scripts/cleanup.sh"
else
    log_failure "ERROR: Тесты провалены. Образ не был запушен."
    source "${SCRIPT_DIR}/../scripts/cleanup.sh"
    exit 1
fi
exit 0