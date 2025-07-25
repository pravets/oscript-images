#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -z "${CI-}" ]; then
  echo "The script is not running in CI"
  source "${SCRIPT_DIR}/../.env"
else
  echo "The script is running in CI"
fi

source "${SCRIPT_DIR}/../tools/assert.sh"

test_winow_is_running() {
  log_header "Test :: winow is running"

  local expected actual
  local container_name="winow_test_running_$(date +%s)"

  expected="ИНФОРМАЦИЯ - Используется нативный веб-сервер"
  actual=$(docker run --rm --name $container_name ${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/winow:latest 2>/dev/null | head -n1)
  
  if assert_eq "$expected" "$actual"; then
    log_success "winow is running test passed"
  else
    log_failure "winow is running test failed"
  fi

  docker stop $container_name > /dev/null 2>&1

}

test_winow_is_responsible() {
  log_header "Test :: winow is responsible"

  local expected actual
  local container_name="winow_test_responsible_$(date +%s)"

  expected="hello"
  docker run \
    --rm \
    --name $container_name \
    -p 3333:3333 \
    -v "${SCRIPT_DIR}/../tests/winow/hello:/app" \
    -d \
    ${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/winow:latest > /dev/null 2>&1
  sleep 5
  
  actual=$(curl -s http://localhost:3333/)

  if assert_eq "$expected" "$actual"; then
    log_success "winow is responsible test passed"
  else
    log_failure "winow is responsible test failed"
  fi

  docker stop $container_name > /dev/null 2>&1

}

test_winow_is_stopped_without_packagedef() {
  log_header "Test :: winow is stopped without packagedef"

  local expected actual
  local container_name="winow_test_stopped_without_packagedef_$(date +%s)"

  expected="Файл packagedef НЕ найден. Параметр -deps не может быть использован без него."
  actual=$(docker run --rm --name $container_name ${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/winow:latest -deps 2>/dev/null | head -n1)
  
  if assert_eq "$expected" "$actual"; then
    log_success "winow is stopped without packagedef test passed"
  else
    log_failure "winow is stopped without packagedef test failed"
  fi

}

test_winow_is_installing_deps() {
  log_header "Test :: winow is installing deps"

  local expected actual
  local container_name="winow_test_installing_deps_$(date +%s)"

  expected="Файл packagedef найден. Устанавливаем зависимости с помощью opm i."
  actual=$(docker run \
    --rm \
    --name $container_name \
    -v "${SCRIPT_DIR}/../tests/winow/hello:/app" \
    ${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/winow:latest -deps 2>/dev/null | head -n1)

  if assert_eq "$expected" "$actual"; then
    log_success "winow is installing deps test passed"
  else
    log_failure "winow is installing deps test failed"
  fi

  docker stop $container_name > /dev/null 2>&1

}

# test calls
test_winow_is_running
test_winow_is_responsible
test_winow_is_stopped_without_packagedef
test_winow_is_installing_deps
