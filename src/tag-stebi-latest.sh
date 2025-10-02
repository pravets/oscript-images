#!/bin/bash
set -euo pipefail

git tag -f stebi && git push origin stebi -f
