# oscript-images

![CodeRabbit Pull Request Reviews](https://img.shields.io/coderabbit/prs/github/pravets/oscript-images?utm_source=oss&utm_medium=github&utm_campaign=pravets%2Foscript-images&labelColor=171717&color=FF570A&link=https%3A%2F%2Fcoderabbit.ai&label=CodeRabbit+Reviews)

Всё для сборки Docker-образов движка [OneScript](https://oscript.io/) и некоторых утилит на OneScript

Сборка происходит в GitHub Actions, чтобы максимально снизить порог входа и упростить вашу жизнь. Основной сценарий предполагает отправку образов в ваш личный приватный или публичный registry. Можно развернуть свой registry или арендовать в облаке, например в Яндексе или cloud.ru. Если вы решите пойти по пути своего registry, то он должен поддерживать авторизацию и быть доступен во внешней сети.

Необходимо выполнить [подготовительные шаги](#подготовительные-шаги) и шаги сборки требуемых вам утилит.

## Оглавление

- [oscript-images](#oscript-images)
- [Подготовительные шаги](#подготовительные-шаги)
- [oscript](#oscript)
- [yard](#yard)
- [onec-installer-downloader](#onec-installer-downloader)

## Подготовительные шаги

1. **Форкните** [этот репозиторий](https://github.com/pravets/oscript-images/).

1. **Включите GitHub Actions**
   - Перейдите во вкладку "Actions" в вашем форке и разрешите запуск workflow.

1. **Добавьте секреты для Docker Hub**
   - В настройках репозитория (Settings → Secrets and variables → Actions) добавьте переменные:
     - `DOCKER_REGISTRY_URL` — адрес реестра (например, `docker.io`)
     - `DOCKER_LOGIN` — ваш логин Docker Hub или в вашем приватном registry
     - `DOCKER_PASSWORD` — ваш пароль от вашего приватного registry или [токен Docker Hub](https://app.docker.com/settings/personal-access-tokens). Для Docker Hub нужны права Read и Write и рекомендуется использовать токен, вместо пароля.

    [↑ В начало](#oscript-images)

## oscript

[![Docker Pulls](https://img.shields.io/docker/pulls/sleemp/oscript)](https://hub.docker.com/r/sleemp/oscript)

Готовые собранные образы можно взять в [sleemp/oscript](https://hub.docker.com/r/sleemp/oscript)

### Назначение

Это базовые образы с движком oscript, для самостоятельного использования и сборки на их основе других образов.

### Сборка
1. [**Выполните подготовительные шаги**](#подготовительные-шаги), если не сделали это ранее

1. **Добавьте тег `oscript_Версия`**
   - Перейдите во вкладку "Tags" или используйте команду:
     ```bash
     git tag oscript_dev
     git push origin oscript_dev
     ```
      доступные к использованию версии:
      - stable
      - lts
      - lts-dev
      - dev
      - preview

      сборка с номерными версиями не тестировалась

   - либо клонируйте репозиторий к себе на Linux-хост (или используйте GitHub Codespaces) и запустите скрипт `./src/tag-oscript-Версия.sh` — он принудительно «перевесит» тег на последний коммит и запушит его. Доступны скрипты для всех допустимых тегов версий
   - Это необходимо для запуска сборки образа через GitHub Actions.

1. **Запустите сборку**
   - После пуша тега workflow автоматически соберёт и опубликует образ `oscript` в ваш Docker Registry.
   - будет опубликован образ с тегом выбранной версии, а также с номерной версией собранного `oscript` в двух вариантах - 3 и 4 разряда, то есть, например `1.9.3` и `1.9.3.15`
   - исключение составляют rc-версии: для них будет опубликован образ с символьной версией, например `dev` и `2.0.0-rc.8_614` (обратите внимание, что + заменяется на _).

1. **Проверьте результат**
   - Убедитесь, что образ появился в вашем Docker Registry с именем `oscript` и соответствующей версией.

### Зависимости

Каких-то явных зависимостей нет.

### Использование

Использовать как любой другой Docker-образ через `docker run` или как основу для своих образов.

### Ограничения

Явных ограничений нет.

[↑ В начало](#oscript-images)

## yard

[![Docker Pulls](https://img.shields.io/docker/pulls/sleemp/yard)](https://hub.docker.com/r/sleemp/yard)

Готовые собранные образы можно взять в [sleemp/yard](https://hub.docker.com/r/sleemp/yard)

### Назначение

Образ предназначем для скачивания файлов с сайта релизов фирмы 1С с помощью утилиты yard.

### Сборка

1. [**Выполните подготовительные шаги**](#подготовительные-шаги), если не сделали это ранее

1. **Добавьте тег `yard`**
   - Перейдите во вкладку "Tags" или используйте команду:
     ```bash
     git tag yard
     git push origin yard
     ```

   - либо клонируйте репозиторий к себе на Linux-хост (или используйте GitHub Codespaces) и запустите скрипт `./src/tag-yard-latest.sh` — он принудительно «перевесит» тег на последний коммит и запушит теги
   - Это необходимо для запуска сборки yard через GitHub Actions.

1. **Запустите сборку**
   - После пуша тега workflow автоматически соберёт и опубликует образ `yard` в ваш Docker Registry.
   - будет опубликован образ с тегом `latest`, а также с номерной версией собранного `yard`

1. **Проверьте результат**
   - Убедитесь, что образ появился в вашем Docker Registry с именем `yard` и соответствующей версией.

### Зависимости

Образ собирается на основе [oscript:dev](#oscript), он должен быть предварительно собран и запушен.

### Использование

1. Необходимо пробросить в контейнер каталог, в который будет загружен дистрибутив. Путь к каталогу внутри не регламентируеся, можете, например использовать `-v ./downloads:/tmp/downloads`.

1. Подробнее с использованием утилиты можно в репозитории [yard](https://github.com/arkuznetsov/yard/)

### Ограничения

1. В образе отсутствует платформа и EDT, а значит не будет работать связанный с ними функционал. Можно просто скачать и распаковать загруженные файлы.


[↑ В начало](#oscript-images)

## onec-installer-downloader

[![Docker Pulls](https://img.shields.io/docker/pulls/sleemp/onec-installer-downloader)](https://hub.docker.com/r/sleemp/onec-installer-downloader)

Готовые собранные образы можно взять в [sleemp/onec-installer-downloader](https://hub.docker.com/r/sleemp/onec-installer-downloader)

### Назначение

Образ предназначен для загрузки Linux-версий дистрибутивов платформы `1С:Предприятие` и `EDT`. Основная задача - скачивание дистрибутивов для целей сборки Docker-образов с платформой и EDT.

Образ основан на образе с [yard](#yard) и скрипте загрузки из [onec-docker](https://github.com/firstBitMarksistskaya/onec-docker)

### Сборка

1. [**Выполните подготовительные шаги**](#подготовительные-шаги), если не сделали это ранее

1. **Добавьте тег `onec-installer-downloader_НомерВерсии`**
   - Перейдите во вкладку "Tags" или используйте команду:
     ```bash
     git tag onec-installer-downloader_НомерВерсии
     git push origin onec-installer-downloader_НомерВерсии
     ```
   - `НомерВерсии` предлагается использовать вида `ГодМесяцДень`
   - либо клонируйте репозиторий к себе на Linux-хост (или используйте GitHub Codespaces) и запустите скрипт `./src/tag-onec-installer-downloader-latest.sh` — он принудительно создаст тег с текущей датой на последний коммит и запушит его
   - Это необходимо для запуска сборки через GitHub Actions.

1. **Запустите сборку**
   - После пуша тега workflow автоматически соберёт и опубликует образ `onec-installer-downloader` в ваш Docker Registry.
   - будет опубликован образ с тегом `НомерВерсии`, а также с тегом `latest`

1. **Проверьте результат**
   - Убедитесь, что образ появился в вашем Docker Registry с именем `onec-installer-downloader` и соответствующей версией.

### Зависимости

Образ собирается на основе образа [yard:latest](#yard), он должен быть предварительно собран и запушен.

### Использование

Для запуска образа необходимо учесть следующие моменты:

1. Необходимо пробросить в контейнер переменные среды `YARD_RELEASES_USER` и `YARD_RELEASES_PWD`, необходимые `yard` для авторизации на сайте релизов 1С

1. Также необходимо передать какой дистрибутив и версию нужно скачать, например `server 8.3.25.1445`. Список доступных дистрибутивов:
   - edt
   - server
   - server32 
   - client
   - client32 
   - thin-client
   - thin-client32

1. И, конечно, необходимо пробросить в контейнер каталог, в который будет загружен дистрибутив: `-v ./downloads:/tmp/downloads`.

1. Дополнительно можно пробросить каталог `/distr` с загруженными архивами дистрибутивов

1. Итоговая команда запуска может выглядеть примерно так:
```shell
docker run --rm \ 
-e YARD_RELEASES_USER=user
-e YARD_RELEASES_PWD=password \ 
-v ./downloads:/tmp/downloads \
sleemp/onec-installer-downloader:20250723 thin-client32 8.3.25.1445
```

### Ограничения

Ограничения аналогичны [базовому образу](#yard)

[↑ В начало](#oscript-images)