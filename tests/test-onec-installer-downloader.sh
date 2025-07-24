#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -z "${CI-}" ]; then
  echo "The script is not running in CI"
  if [ -f "${SCRIPT_DIR}/../.env" ]; then
    source "${SCRIPT_DIR}/../.env"
  else
    echo "Файл .env не найден по пути ${SCRIPT_DIR}/../.env"
    exit 1
  fi
else
  echo "The script is running in CI"
fi

source "${SCRIPT_DIR}/../tools/assert.sh"

test_onec_installer_downloader_is_running() {
  log_header "Test :: onec-installer-downloader is running"

  local expected actual

  expected="Usage: /app/downloader.sh <installer_type> <ONEC_VERSION>"
  actual=$(docker run --rm ${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/onec-installer-downloader:${ONEC_INSTALLER_DOWNLOADER_VERSION} 2>/dev/null | head -n1)

  if assert_eq "$expected" "$actual"; then
    log_success "onec-installer-downloader is running test passed"
  else
    log_failure "onec-installer-downloader is running test failed"
  fi
}

test_onec_installer_downloader_requires_credentials() {
  log_header "Test :: onec-installer-downloader requires credentials"

  local expected actual

  expected="Ошибка: Необходимо установить переменные среды YARD_RELEASES_USER и YARD_RELEASES_PWD"
  actual=$(docker run --rm ${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/onec-installer-downloader:${ONEC_INSTALLER_DOWNLOADER_VERSION} thin-client32 8.3.25.1445 2>/dev/null | head -n1)

  if assert_eq "$expected" "$actual"; then
    log_success "onec-installer-downloader requires credentials test passed"
  else
    log_failure "onec-installer-downloader requires credentials test failed"
  fi
}

# test calls
test_onec_installer_downloader_is_running
test_onec_installer_downloader_requires_credentials