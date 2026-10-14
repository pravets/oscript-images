# AGENTS.md

## Что это за репозиторий

- Сборка Docker-образов движка [OneScript](https://oscript.io/) и утилит на нём: `oscript`, `yard`, `onec-installer-downloader`, `winow`, `gitrules`, `stebi`, `edt-ripper`.
- Каждый образ = триада: `src/<имя>/Dockerfile` + `src/build-<имя>.sh` + `tests/test-<имя>.sh`.
- `oscript` — базовый образ, от него зависят все остальные; `yard` — база для `onec-installer-downloader`.

## Локальная сборка (bash + docker, Linux/WSL)

- Скрипты при отсутствии `CI=true` требуют файл `.env` в корне (в `.gitignore`) и падают без него.
- Безопасный прогон без публикации:

  ```bash
  PUSH_IMAGE=false DOCKER_REGISTRY_URL=ci DOCKER_LOGIN=build OSCRIPT_VERSION=stable CI=true ./src/build-oscript.sh
  ```

- ⚠️ `PUSH_IMAGE` по умолчанию `true` — build-скрипты пушат образ в registry.
- Тесты запускаются внутри build-скриптов, отдельного test-раннера нет.
- Прочие переменные: `NO_CACHE=true`, `DOCKER_SYSTEM_PRUNE=true`, `ONEC_INSTALLER_DOWNLOADER_VERSION` (для oid).

## CI (.github/workflows/ci.yml)

- PR автоматически собирает и тестирует только затронутые образы (paths-filter), без пуша и секретов.
- Изменение `src/oscript/**`, `scripts/**`, `tools/**` или самого `ci.yml` → пересборка **всех** образов.
- Добавляя новый образ или переименовывая build/test файлы — обнови фильтры в `ci.yml` и таблицу путей в README.
- Buildx использует `driver: docker` — `docker-container` не видит локальные образы демона.
- При `PUSH_IMAGE != true` из `docker build` убирается `--pull`, иначе BuildKit игнорирует локальную базу и тянет из registry.

## Релизы

- Публикация по git-тегам: `oscript_<версия>` (`stable`|`lts`|`lts-dev`|`dev`|`preview`) или просто `<имя>` для остальных образов.
- `src/tag-*.sh` принудительно перевешивают тег на последний коммит и пушат его.
- `src/tag-*.sh` исключены из триггеров CI.

## Ветки и PR

- Новые фичи — в ветках `feature/имя_фичи`, затем PR.
- Дождись зелёного CI в PR перед мержем.
