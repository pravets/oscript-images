#!/usr/bin/env bash
set -euo pipefail

# Разлогинивание из Docker (только если логинились — при PUSH_IMAGE=false логина не было)
if [[ "${PUSH_IMAGE:-true}" == "true" ]]; then
    if [ -n "${DOCKER_REGISTRY_URL:-}" ]; then
        docker logout "$DOCKER_REGISTRY_URL"
    else
        docker logout
    fi
fi

# Очистка переменных среды из .env
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$(cd "$SCRIPT_DIR/.." && pwd)/.env"
if [ -f "$ENV_FILE" ]; then
    while IFS='=' read -r var _; do
        # Удаляем пробелы и префикс export, если есть
        var=$(echo "$var" | sed -e 's/^export[[:space:]]*//')
        if [[ $var != "" && $var != \#* ]]; then
            unset "$var"
        fi
    done < "$ENV_FILE"
fi

echo "Очистка завершена."