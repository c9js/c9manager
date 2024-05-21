#!/bin/bash
#┌────────────────────────────────────────────┐
#│ Путь к каталогу где расположен этот скрипт │
#└────────────────────────────────────────────┘
PATH_DIR="$(dirname $0)"

#┌──────┐
#│ Ядро │
#└──────┘
. $PATH_DIR/../core/core.sh

#┌─────┐
#│ MVC │
#└─────┘
# Entrypoints
. $PATH_DIR/entrypoints/entrypointCli.sh
. $PATH_DIR/entrypoints/entrypointBuild.sh
. $PATH_DIR/entrypoints/entrypointStart.sh
. $PATH_DIR/entrypoints/entrypointProxy.sh

# Navigators
. $PATH_DIR/navigators/navigatorBuild.sh
. $PATH_DIR/navigators/navigatorStart.sh

# Controllers
. $PATH_DIR/controllers/controllerGit.sh
. $PATH_DIR/controllers/controllerSSH.sh
. $PATH_DIR/controllers/controllerDocker.sh

# Models
. $PATH_DIR/models/modelBuild.sh
. $PATH_DIR/models/modelGit.sh
. $PATH_DIR/models/modelSSH.sh
. $PATH_DIR/models/modelDocker.sh

# Runners
. $PATH_DIR/runners/runnerGit.sh
. $PATH_DIR/runners/runnerSSH.sh
. $PATH_DIR/runners/runnerDocker.sh
. $PATH_DIR/runners/runnerNotice.sh

# Views
. $PATH_DIR/views/viewCli.sh
. $PATH_DIR/views/viewGit.sh
. $PATH_DIR/views/viewSSH.sh
. $PATH_DIR/views/viewDocker.sh
. $PATH_DIR/views/viewNotice.sh

# Cli
. $PATH_DIR/cli/cliBuild.sh

#┌──────────────────┐
#│ Режим разработки │
#└──────────────────┘
DEV_MODE=0

#┌─────────────────────────┐
#│ Загружаем версию образа │
#└─────────────────────────┘
VERSION="$(get_file "$HOME/VERSION")"

#┌───────────────────────┐
#│ Имя рабочего каталога │
#└───────────────────────┘
WORKSPACE='c9manager'

#┌──────────────┐
#│ Список путей │
#└──────────────┘
PATH_PORTS='/.c9/ports'                                   # Список внешних портов
PATH_WORKSPACE="/$WORKSPACE"                              # Рабочий каталог
PATH_VERSION="$PATH_WORKSPACE/VERSION"                    # Номер версии
PATH_GIT_USER="$PATH_WORKSPACE/.c9/deploy/git_user"       # Имя git-юзера
PATH_GIT_REPO="$PATH_WORKSPACE/.c9/deploy/git_repo"       # Имя git-репозитория
PATH_DOCKER_USER="$PATH_WORKSPACE/.c9/deploy/docker_user" # Логин от docker-репозитория
PATH_DOCKER_PASS="$PATH_WORKSPACE/.c9/deploy/docker_pass" # Пароль от docker-репозитория
PATH_BAD_DEPLOY="$PATH_WORKSPACE/.c9/deploy/bad_deploy"   # Информация о последнем деплое

#┌───────────────┐
#│ Список портов │
#└───────────────┘
PORT_BASIC=80    # Внутренний порт (основной)
PORT_EXTRA=8080  # Внутренний порт (дополнительный)
PORT_PUBLIC=8000 # Внешний порт (по умолчанию)

#┌───────────────────┐
#│ Список переменных │
#└───────────────────┘
SSH_DIR='ssh'               # Имя каталога где хранятся SSH-ключи
PATH_CURRENT='/root/repo'   # Путь к текущему каталогу из docker-а
PATH_PROJECTS='/projects'   # Путь к списку проектов
GIT_URL='github.com'        # URL git-репозитория
DOCKER_USER='c9js'          # (по умолчанию) Логин от docker-репозитория
GIT_USER='c9js'             # (по умолчанию) Имя git-юзера
GIT_REPO='c9manager'        # (по умолчанию) Имя git-репозитория
IMAGE_START='c9js/c9docker' # Образ для работы с другими образами (для первого старта)
IMAGES_MAX=5                # Количество образов на странице

#┌───────────────────────────────────────────────────────────┐
#│ Список образов которые требуется запустить (после сборки) │
#└───────────────────────────────────────────────────────────┘
IMAGES_RUN=(
    'c9docker'            # Образ для работы с другими образами
    'c9open'              # Базовый образ
)

#┌───────────────────────────┐
#│ Список образов для сборки │
#└───────────────────────────┘
IMAGES_BUILD=(
    'c9docker'            # Образ для работы с другими образами
    'c9start'             # Образ для первого старта
    'c9open'              # Базовый образ
)

#┌───────────────────────────────────┐
#│ Список образов для hub.docker.com │
#└───────────────────────────────────┘
IMAGES_HUB=(
    'c9js/c9docker'       # Образ для работы с другими образами
    'c9js/c9start'        # Образ для первого старта
    'c9js/c9open'         # Базовый образ
)

#┌─────────────┐
#│ Точки входа │
#└─────────────┘
case "$#" in
# Прокси контейнер
    0) entrypoint:Proxy "$@" ;;
    
# Графические интерфейсы
    1) case "$1" in
        'build') entrypoint:Build "$@" ;; # Сборка образа
        'start') entrypoint:Start "$@" ;; # Первый старт
        *)       entrypoint:Cli   "$@" ;; # Интерфейс командной строки
    esac
    ;;
    
# Интерфейс командной строки
    *) entrypoint:Cli "$@" ;;
esac
