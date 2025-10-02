# oscript-images

![CodeRabbit Pull Request Reviews](https://img.shields.io/coderabbit/prs/github/pravets/oscript-images?utm_source=oss&utm_medium=github&utm_campaign=pravets%2Foscript-images&labelColor=171717&color=FF570A&link=https%3A%2F%2Fcoderabbit.ai&label=CodeRabbit+Reviews)
![License](https://img.shields.io/github/license/pravets/oscript-images)
[![Telegram](https://telegram-badge.vercel.app/api/telegram-badge?channelId=@pravets_IT)](https://t.me/pravets_it)


Всё для сборки Docker-образов движка [OneScript](https://oscript.io/) и некоторых утилит на OneScript

Сборка происходит в GitHub Actions, чтобы максимально снизить порог входа и упростить вашу жизнь. Основной сценарий предполагает отправку образов в ваш личный приватный или публичный registry. Можно развернуть свой registry или арендовать в облаке, например в Яндексе или cloud.ru. Если вы решите пойти по пути своего registry, то он должен поддерживать авторизацию и быть доступен во внешней сети.

Необходимо выполнить [подготовительные шаги](#подготовительные-шаги) и шаги сборки требуемых вам утилит.

## Оглавление

- [oscript-images](#oscript-images)
- [Подготовительные шаги](#подготовительные-шаги)
- [oscript](#oscript)
- [yard](#yard)
- [onec-installer-downloader](#onec-installer-downloader)
- [winow](#winow)
- [gitrules](#gitrules)
- [stebi](#stebi)
- [edt-ripper](#edt-ripper)

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

[![Docker Version](https://img.shields.io/docker/v/sleemp/oscript/lts?label=lts)](https://hub.docker.com/r/sleemp/oscript)
[![Docker Version](https://img.shields.io/docker/v/sleemp/oscript/lts-dev?label=lts-dev)](https://hub.docker.com/r/sleemp/oscript)
[![Docker Version](https://img.shields.io/docker/v/sleemp/oscript/stable?label=stable)](https://hub.docker.com/r/sleemp/oscript)
[![Docker Version](https://img.shields.io/docker/v/sleemp/oscript/dev?label=dev)](https://hub.docker.com/r/sleemp/oscript)
[![Docker Version](https://img.shields.io/docker/v/sleemp/oscript/preview?label=preview)](https://hub.docker.com/r/sleemp/oscript)


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
[![Docker Version](https://img.shields.io/docker/v/sleemp/yard/latest)](https://hub.docker.com/r/sleemp/yard)

Готовые собранные образы можно взять в [sleemp/yard](https://hub.docker.com/r/sleemp/yard)

### Назначение

Образ предназначен для скачивания файлов с сайта релизов фирмы 1С с помощью утилиты yard.

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

1. Необходимо пробросить в контейнер каталог, в который будет загружен дистрибутив. Путь к каталогу внутри не регламентируеся, вы можете, например, использовать `-v ./downloads:/tmp/downloads`.

1. Подробнее с использованием утилиты можно в репозитории [yard](https://github.com/arkuznetsov/yard/)

### Ограничения

1. В образе отсутствует платформа и EDT, а значит не будет работать связанный с ними функционал. Можно просто скачать и распаковать загруженные файлы.


[↑ В начало](#oscript-images)

## onec-installer-downloader

[![Docker Pulls](https://img.shields.io/docker/pulls/sleemp/onec-installer-downloader)](https://hub.docker.com/r/sleemp/onec-installer-downloader)
[![Docker Version](https://img.shields.io/docker/v/sleemp/onec-installer-downloader/latest)](https://hub.docker.com/r/sleemp/onec-installer-downloader)

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

## winow

[![Docker Pulls](https://img.shields.io/docker/pulls/sleemp/winow)](https://hub.docker.com/r/sleemp/winow)
[![Docker Version](https://img.shields.io/docker/v/sleemp/winow/latest)](https://hub.docker.com/r/sleemp/winow)

Готовые собранные образы можно взять в [sleemp/winow](https://hub.docker.com/r/sleemp/winow)

### Назначение

Образ предназначен для запуска веб-приложений на фреймворке [winow](https://github.com/autumn-library/winow).

### Сборка

1. [**Выполните подготовительные шаги**](#подготовительные-шаги), если не сделали это ранее

1. **Добавьте тег `winow`**
   - Перейдите во вкладку "Tags" или используйте команду:
     ```bash
     git tag winow
     git push origin winow
     ```

   - либо клонируйте репозиторий к себе на Linux-хост (или используйте GitHub Codespaces) и запустите скрипт `./src/tag-winow-latest.sh` — он принудительно «перевесит» тег на последний коммит и запушит теги
   - Это необходимо для запуска сборки yard через GitHub Actions.

1. **Запустите сборку**
   - После пуша тега workflow автоматически соберёт и опубликует образ `winow` в ваш Docker Registry.
   - будет опубликован образ с тегом `latest`, а также с номерной версией собранного `winow`

1. **Проверьте результат**
   - Убедитесь, что образ появился в вашем Docker Registry с именем `winow` и соответствующей версией.

### Зависимости

Образ собирается на основе [oscript:dev](#oscript), он должен быть предварительно собран и запушен.

### Использование

1. Есть два варианта использования образа - для запуска как есть и для сборки на его основе образа вашего приложения

1. В любом случае, необходимо добавить в контейнер каталог c вашим приложением. Для запуска как есть используйте ключ `-v ./app:/app`.

1. Также необходимо пробросить из контейнера порт `3333`, например так `-p 8080:3333`

1. В образе реализована возможность при запуске доустанавливать зависимости вашего приложения с помощью ключа `-deps`. Но нужно помнить, что "прибитые молотком" версии пакетов `autumn`, `winow`, `winow-cli` и их зависимостей могут привести к непредсказуемым последствиям.

### Ограничения

1. Явных ограничений вроде бы нет.

[↑ В начало](#oscript-images)

## gitrules

[![Docker Pulls](https://img.shields.io/docker/pulls/sleemp/gitrules)](https://hub.docker.com/r/sleemp/gitrules)
[![Docker Version](https://img.shields.io/docker/v/sleemp/gitrules/latest)](https://hub.docker.com/r/sleemp/gitrules)

Готовые собранные образы можно взять в [sleemp/gitrules](https://hub.docker.com/r/sleemp/gitrules)

### Назначение

Образ предназначен для сборки/разборки правил конвертации в формате Конвертации данных 2.0 с помощью утилиты [gitrules](https://github.com/oscript-library/gitrules).

### Сборка

1. [**Выполните подготовительные шаги**](#подготовительные-шаги), если не сделали это ранее

1. **Добавьте тег `gitrules`**
   - Перейдите во вкладку "Tags" или используйте команду:
     ```bash
     git tag -f gitrules
     git push origin gitrules -f
     ```

   - либо клонируйте репозиторий к себе на Linux-хост (или используйте GitHub Codespaces) и запустите скрипт `./src/tag-gitrules-latest.sh` — он принудительно «перевесит» тег на последний коммит и запушит теги
   - Это необходимо для запуска сборки gitrules через GitHub Actions.

1. **Запустите сборку**
   - После пуша тега workflow автоматически соберёт и опубликует образ `gitrules` в ваш Docker Registry.
   - будет опубликован образ с тегом `latest`, а также с номерной версией собранного `gitrules`

1. **Проверьте результат**
   - Убедитесь, что образ появился в вашем Docker Registry с именем `gitrules` и соответствующей версией.

### Зависимости

Образ собирается на основе [oscript:dev](#oscript), он должен быть предварительно собран и запушен.

### Использование

1. Необходимо пробросить в контейнер каталог, в котором находятся ваши правила и где будет происходить сборка. Путь к каталогу внутри не регламентируеся, вы можете, например, использовать `-v ./:/tmp/rules`.

1. Подробнее с использованием утилиты можно в репозитории [gitrules](https://github.com/oscript-library/gitrules)

1. Также, например, образ используется в CI/CD [компоненте для сборки правил конвертации для Gitlab CI](https://gitlab.com/explore/catalog/onec-components/onec-gitrules). Репозиторий данной компоненты есть и [на GitHub](https://github.com/onec-components/onec-gitrules)

[↑ В начало](#oscript-images)

## stebi

[![Docker Pulls](https://img.shields.io/docker/pulls/sleemp/stebi)](https://hub.docker.com/r/sleemp/stebi)
[![Docker Version](https://img.shields.io/docker/v/sleemp/stebi/latest)](https://hub.docker.com/r/sleemp/stebi)

Готовые собранные образы можно взять в [sleemp/stebi](https://hub.docker.com/r/sleemp/stebi)

### Назначение

Образ предназначен для экспорта диагностик 1С: EDT в формат SonarQube 1C (BSL) Community Plugin с помощью утилиты [stebi](https://github.com/Stepa86/stebi). Утилита позволяет конвертировать результаты проверки проекта 1С:EDT, трансформировать диагностики, изменять параметры и получать версию конфигурации.

### Сборка

1. [**Выполните подготовительные шаги**](#подготовительные-шаги), если не сделали это ранее

1. **Добавьте тег `stebi`**
   - Перейдите во вкладку "Tags" или используйте команду:
     ```bash
     git tag -f stebi
     git push origin stebi -f
     ```

   - либо клонируйте репозиторий к себе на Linux-хост (или используйте GitHub Codespaces) и запустите скрипт `./src/tag-stebi-latest.sh` — он принудительно «перевесит» тег на последний коммит и запушит теги
   - Это необходимо для запуска сборки stebi через GitHub Actions.

1. **Запустите сборку**
   - После пуша тега workflow автоматически соберёт и опубликует образ `stebi` в ваш Docker Registry.
   - будет опубликован образ с тегом `latest`, а также с номерной версией собранного `stebi`

1. **Проверьте результат**
   - Убедитесь, что образ появился в вашем Docker Registry с именем `stebi` и соответствующей версией.

### Зависимости

Образ собирается на основе [oscript:dev](#oscript), он должен быть предварительно собран и запушен.

### Использование

1. Образ можно использовать для конвертации результатов проверки EDT в формат JSON для SonarQube:
   ```bash
   docker run --rm -v ./:/workspace sleemp/stebi:latest convert ./edt-result.out ./edt-json.json ./src
   ```

1. Для просмотра всех доступных команд запустите образ без параметров или с ключом `--help`:
   ```bash
   docker run --rm sleemp/stebi:latest
   ```

1. Подробнее с использованием утилиты можно ознакомиться в репозитории [stebi](https://github.com/Stepa86/stebi)

### Ограничения

Явных ограничений нет.

[↑ В начало](#oscript-images)

## edt-ripper

[![Docker Pulls](https://img.shields.io/docker/pulls/sleemp/edt-ripper)](https://hub.docker.com/r/sleemp/edt-ripper)
[![Docker Version](https://img.shields.io/docker/v/sleemp/edt-ripper/latest)](https://hub.docker.com/r/sleemp/edt-ripper)

Готовые собранные образы можно взять в [sleemp/edt-ripper](https://hub.docker.com/r/sleemp/edt-ripper)

### Назначение

Образ предназначен для разборки/сборки EDT-проектов с помощью утилиты [edt-ripper](https://github.com/bia-technologies/edt_ripper). Утилита позволяет разобрать проект EDT в исходники и собрать обратно, что полезно для версионного контроля и автоматизации.

### Сборка

1. [**Выполните подготовительные шаги**](#подготовительные-шаги), если не сделали это ранее

1. **Добавьте тег `edt-ripper`**
   - Перейдите во вкладку "Tags" или используйте команду:
     ```bash
     git tag -f edt-ripper
     git push origin edt-ripper -f
     ```

   - либо клонируйте репозиторий к себе на Linux-хост (или используйте GitHub Codespaces) и запустите скрипт `./src/tag-edt-ripper-latest.sh` — он принудительно «перевесит» тег на последний коммит и запушит теги
   - Это необходимо для запуска сборки edt-ripper через GitHub Actions.

1. **Запустите сборку**
   - После пуша тега workflow автоматически соберёт и опубликует образ `edt-ripper` в ваш Docker Registry.
   - будет опубликован образ с тегом `latest`, а также с номерной версией собранного `edt-ripper`

1. **Проверьте результат**
   - Убедитесь, что образ появился в вашем Docker Registry с именем `edt-ripper` и соответствующей версией.

### Зависимости

Образ собирается на основе [oscript:dev](#oscript), он должен быть предварительно собран и запушен.

### Использование

1. Образ можно использовать для разборки EDT-проекта в исходники:
   ```bash
   docker run --rm -v ./:/workspace sleemp/edt-ripper:latest unpack ./project.edt ./src
   ```

1. Для просмотра всех доступных команд запустите образ без параметров или с ключом `--help`:
   ```bash
   docker run --rm sleemp/edt-ripper:latest
   ```

1. Подробнее с использованием утилиты можно ознакомиться в репозитории [edt-ripper](https://github.com/bia-technologies/edt_ripper)

### Ограничения

Явных ограничений нет.

[↑ В начало](#oscript-images)
