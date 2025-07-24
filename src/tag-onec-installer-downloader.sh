#!/bin/bash
set -euo pipefail

VERSION=$(date +%Y%m%d)
TAG="onec-installer-downloader_${VERSION}"

git tag -f $TAG
git push origin $TAG -f