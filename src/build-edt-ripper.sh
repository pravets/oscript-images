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

edt_ripper_version="latest"

docker build \
    --pull \
    --build-arg EDT_RIPPER_VERSION="${edt_ripper_version}" \
    --build-arg DOCKER_REGISTRY_URL="${DOCKER_REGISTRY_URL}" \
    --build-arg DOCKER_LOGIN="${DOCKER_LOGIN}" \
    -t "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/edt-ripper:${edt_ripper_version}" \
    -f "${SCRIPT_DIR}/edt-ripper/Dockerfile" \
    ${last_arg}

if ./tests/test-edt-ripper.sh; then
    container_version=$(docker run --rm  "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/edt-ripper:${edt_ripper_version}" --version | tail -n1)

    if [[ -n "${container_version}" ]]; then
        docker push "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/edt-ripper:${edt_ripper_version}"

        docker tag "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/edt-ripper:${edt_ripper_version}" "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/edt-ripper:${container_version}"
        docker push "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/edt-ripper:${container_version}"

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
