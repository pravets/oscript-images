#!/bin/bash
set -euo pipefail

git tag -f oscript_lts && git push origin oscript_lts -f