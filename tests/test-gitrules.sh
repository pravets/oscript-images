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

# Global flag to mark if any test failed. At the end script will exit with non-zero
# status if any test set this flag. This ensures CI/build scripts stop on test failures.
TEST_FAILED=0

test_gitrules_is_running() {
  log_header "Test :: gitrules is running"

  local expected actual

  expected="Приложение: gitrules"
  actual=$(docker run --rm ${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/gitrules:latest 2>/dev/null | head -n1)

  if assert_eq "$expected" "$actual"; then
    log_success "gitrules is running test passed"
  else
    log_failure "gitrules is running test failed"
    TEST_FAILED=1
  fi
}

# test calls
test_gitrules_is_running

# Exit with non-zero if any test failed so callers (like build scripts) can stop further steps
if [[ "$TEST_FAILED" -ne 0 ]]; then
  exit 1
fi