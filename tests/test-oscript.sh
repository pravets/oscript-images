#!/bin/bash
set -e

if [ -z "${CI-}" ]; then
  echo "The script is not running in CI"
  source .env
else
  echo "The script is running in CI"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${SCRIPT_DIR}/../tools/assert.sh"


test_oscript_is_running() {
  log_header "Test :: oscript is running"

  local expected actual
  expected="1Script Execution Engine"
  actual=$(docker run --rm $DOCKER_REGISTRY_URL/${DOCKER_LOGIN}/oscript:$OSCRIPT_VERSION)

  if assert_contain "$actual" "$expected"; then
    log_success "oscript is running test passed"
  else
    log_failure "oscript is running test failed"
  fi
}

# test calls
test_oscript_is_running