#!/bin/bash
set -euo pipefail

git tag -f edt-ripper && git push origin edt-ripper -f
