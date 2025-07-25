#!/bin/bash

# Проверяем наличие параметра -deps
check_deps=false
for arg in "$@"; do
  if [ "$arg" = "-deps" ]; then
    check_deps=true
    break
  fi
done

# Если передан -deps И существует packagedef, выполняем opm i
if [ "$check_deps" = true ]; then
  if [ -f "packagedef" ]; then
    echo "Файл packagedef найден. Устанавливаем зависимости с помощью opm i."
    opm i
  else
    echo "Файл packagedef НЕ найден. Параметр -deps не может быть использован без него."
    exit 1
  fi
fi

winow start