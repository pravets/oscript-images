#!/bin/bash
set -euo pipefail

git tag -f oscript_stable && git push origin oscript_stable -f