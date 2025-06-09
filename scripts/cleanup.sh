#!/usr/bin/env bash
set -euo pipefail

# Разлогинивание из Docker
if [ -n "$DOCKER_REGISTRY_URL" ]; then
    docker logout "$DOCKER_REGISTRY_URL"
else
    docker logout
fi

# Очистка переменных среды из .env
if [ -f .env ]; then
    while IFS='=' read -r var _; do
        # Удаляем пробелы и префикс export, если есть
        var=$(echo "$var" | sed -e 's/^export[[:space:]]*//')
        if [[ $var != "" && $var != \#* ]]; then
            unset "$var"
        fi
    done < .env
fi

echo "Очистка завершена."