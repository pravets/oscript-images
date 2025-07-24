#!/bin/bash

# Путь к .env файлу
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

# Проверяем, существует ли файл
if [ ! -f "$ENV_FILE" ]; then
    echo "Файл $ENV_FILE не найден."
    exit 1
fi

# Загружаем переменные окружения из .env файла
set -a
source "$ENV_FILE"
set +a

echo "Переменные окружения загружены из $ENV_FILE"