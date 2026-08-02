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

onec_installer_downloader_version="${ONEC_INSTALLER_DOWNLOADER_VERSION}"
image_name=onec-installer-downloader

docker build \
    --pull \
    --build-arg ONEC_INSTALLER_DOWNLOADER_VERSION="${onec_installer_downloader_version}" \
    --build-arg DOCKER_REGISTRY_URL="${DOCKER_REGISTRY_URL}" \
    --build-arg DOCKER_LOGIN="${DOCKER_LOGIN}" \
    -t "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/${image_name}:${onec_installer_downloader_version}" \
    -f "${SCRIPT_DIR}/onec-installer-downloader/Dockerfile" \
    ${last_arg}

if ${SCRIPT_DIR}/../tests/test-onec-installer-downloader.sh; then  
    if [[ "${PUSH_IMAGE:-true}" == "true" ]]; then
        docker push "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/${image_name}:${onec_installer_downloader_version}"

        docker tag "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/${image_name}:${onec_installer_downloader_version}" "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/${image_name}:latest"
        docker push "${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/${image_name}:latest"
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