#!/bin/bash
set -euo pipefail

git tag -f oscript_preview && git push origin oscript_preview -f