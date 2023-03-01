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
. $PATH_DIR/entrypoints/entrypointMenu.sh
. $PATH_DIR/entrypoints/entrypointProxy.sh

# Controllers
. $PATH_DIR/controllers/controllerGit.sh
. $PATH_DIR/controllers/controllerSSH.sh
. $PATH_DIR/controllers/controllerDocker.sh

# Models
. $PATH_DIR/models/modelGit.sh
. $PATH_DIR/models/modelSSH.sh
. $PATH_DIR/models/modelDocker.sh

# Runners
. $PATH_DIR/runners/runnerGit.sh
. $PATH_DIR/runners/runnerSSH.sh
. $PATH_DIR/runners/runnerDocker.sh
. $PATH_DIR/runners/runnerNotice.sh

# Views
. $PATH_DIR/views/view.sh
. $PATH_DIR/views/viewMenu.sh
. $PATH_DIR/views/viewGit.sh
. $PATH_DIR/views/viewSSH.sh
. $PATH_DIR/views/viewDocker.sh
. $PATH_DIR/views/viewNotice.sh

#┌───────────────────┐
#│ Режим разаработки │
#└───────────────────┘
DEV_MODE=0

#┌───────────────────┐
#│ Список переменных │
#└───────────────────┘
PATH_VERSION='VERSION'                    # Путь к файлу где хранится номер версии
PATH_GIT_USER='.c9/deploy/git_user'       # Путь к файлу где хранится имя git-юзера
PATH_GIT_REPO='.c9/deploy/git_repo'       # Путь к файлу где хранится имя git-репозитория
PATH_DOCKER_USER='.c9/deploy/docker_user' # Путь к файлу где хранится логин от docker-репозитория
PATH_DOCKER_PASS='.c9/deploy/docker_pass' # Путь к файлу где хранится пароль от docker-репозитория
PATH_BAD_DEPLOY='.c9/deploy/bad_deploy'   # Путь к файлу где хранится информация о последнем деплое

SSH_DIR='ssh'             # Путь к каталогу где хранятся SSH-ключи
CURRENT_PATH='/root/repo' # Путь к текущему каталогу из docker-а
GIT_URL='github.com'      # URL git-репозитория
PORT_DEFAULT='8000'       # (по умолчанию) Порт
DOCKER_USER='c9js'        # (по умолчанию) Логин от docker-репозитория
GIT_USER='c9js'           # (по умолчанию) Имя git-юзера
GIT_REPO='c9manager'      # (по умолчанию) Имя git-репозитория
WORKSPACE='c9manager'     # (по умолчанию) Имя рабочего каталога
IMAGE_RUN='c9js/c9docker' # Имя образа который запускаем
IMAGES=(                  # Список всех образов
    'c9js/c9docker'
    'c9js/c9start'
    'c9js/c9open'
    'c9docker'
    'c9start'
    'c9open'
)

#┌─────────────────────────┐
#│ Загружаем версию образа │
#└─────────────────────────┘
VERSION="$(get_file "$HOME/$PATH_VERSION")"

#┌─────────────┐
#│ Точки входа │
#└─────────────┘
case "$1" in
    'MENU') entrypoint:Menu       ;; # Меню
    *)      entrypoint:Proxy "$@" ;; # Прокси контейнер
esac
