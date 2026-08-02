#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
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

last_arg="${PROJECT_ROOT}"
if [[ ${NO_CACHE:-} = "true" ]] ; then
	last_arg="--no-cache ${PROJECT_ROOT}"
fi

# В CI (PUSH_IMAGE=false) база уже подготовлена локально — --pull заставил бы BuildKit
# игнорировать локальный образ и тянуть из registry
pull_arg="--pull"
if [[ "${PUSH_IMAGE:-true}" != "true" ]]; then
	pull_arg=""
fi

winow_version="latest"

docker build \
    ${pull_arg} \
    --build-arg WINOW_VERSION="${winow_version}" \
    --build-arg DOCKER_REGISTRY_URL="${DOCKER_REGISTRY_URL}" \
    --build-arg DOCKER_LOGIN="${DOCKER_LOGIN}" \
    -t "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/winow:${winow_version}" \
    -f "${SCRIPT_DIR}/winow/Dockerfile" \
    ${last_arg}

if ./tests/test-winow.sh; then
    opm_output=$(docker run --rm --entrypoint "opm" "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/winow:${winow_version}" ls)
    container_version=$(echo "$opm_output" | awk -F '|' '/^winow[[:space:]]+\|/ {gsub(/ /, "", $3); print $3}')

    if [[ -z "${container_version}" ]]; then
        log_failure "Не удалось получить версию из контейнера"
        exit 1
    fi

    if [[ "${PUSH_IMAGE:-true}" == "true" ]]; then
        docker push "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/winow:${winow_version}"

        docker tag "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/winow:${winow_version}" "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/winow:${container_version}"
        docker push "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/winow:${container_version}"
    else
        echo "PUSH_IMAGE != true — push пропущен (теги не создаём)"
    fi

    source "${SCRIPT_DIR}/../scripts/cleanup.sh"
else
    log_failure "ERROR: Тесты провалены. Образ не был запушен."
    source "${SCRIPT_DIR}/../scripts/cleanup.sh"
    exit 1
fi
exit 0