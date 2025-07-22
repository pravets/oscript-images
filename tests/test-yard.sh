#!/bin/bash
set -e

if [ -z "${CI-}" ]; then
  echo "The script is not running in CI"
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  source "${SCRIPT_DIR}/../.env"
else
  echo "The script is running in CI"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${SCRIPT_DIR}/../tools/assert.sh"


test_yard_is_running() {
  log_header "Test :: yard is running"

  local expected actual
  expected="ИНФОРМАЦИЯ - [СписокРелизов1С]: Инициализирован обработчик"
  actual=$(docker run --rm $DOCKER_REGISTRY_URL/${DOCKER_LOGIN}/yard:$YARD_VERSION)

  if assert_contain "$actual" "$expected"; then
    log_success "yard is running test passed"
  else
    log_failure "yard is running test failed"
  fi
}

# test calls
test_yard_is_running