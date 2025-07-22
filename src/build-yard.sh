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

yard_version="latest"

docker build \
    --pull \
    --build-arg YARD_VERSION="${yard_version}" \
    --build-arg DOCKER_REGISTRY_URL="${DOCKER_REGISTRY_URL}" \
    -t "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/yard:${yard_version}" \
    -f "${SCRIPT_DIR}/yard/Dockerfile" \
    ${last_arg}

if ./tests/test-yard.sh; then
    container_version=$(docker run --rm  "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/yard:${yard_version}" -v | tail -n1)

    if [[ -n "${container_version}" ]]; then
        docker push "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/yard:${yard_version}"

        docker tag "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/yard:${yard_version}" "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/yard:${container_version}"
        docker push "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/yard:${container_version}"

    else
        echo "Не удалось получить версию из контейнера"
        exit 1
    fi

    source "${SCRIPT_DIR}/../scripts/cleanup.sh"
else
    log_failure "ERROR: Tests failed. Docker image will not be pushed."
    source "${SCRIPT_DIR}/../scripts/cleanup.sh"
    exit 1
fi
exit 0