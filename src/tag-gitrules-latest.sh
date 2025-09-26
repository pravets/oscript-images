#!/bin/bash
set -euo pipefail

git tag -f gitrules && git push origin gitrules -f