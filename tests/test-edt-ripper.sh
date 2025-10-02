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

test_edt_ripper_is_running() {
  log_header "Test :: edt-ripper is running"

  local expected actual

  expected="Приложение: edt-ripper"
  actual=$(docker run --rm ${DOCKER_REGISTRY_URL}/${DOCKER_LOGIN}/edt-ripper:latest 2>/dev/null | head -n1)

  if assert_eq "$expected" "$actual"; then
    log_success "edt-ripper is running test passed"
  else
    log_failure "edt-ripper is running test failed"
    TEST_FAILED=1
  fi
}

# test calls
test_edt_ripper_is_running

# Exit with non-zero if any test failed so callers (like build scripts) can stop further steps
if [[ "$TEST_FAILED" -ne 0 ]]; then
  exit 1
fi
