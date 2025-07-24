#!/bin/bash
set -euo pipefail

git tag -f oscript_lts-dev && git push origin oscript_lts-dev -f