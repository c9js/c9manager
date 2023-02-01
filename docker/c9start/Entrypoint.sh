#!/bin/bash
#┌──────────────────────┐
#│ Загружаем библиотеки │
#└──────────────────────┘
. $HOME/scripts/cli/lib.base.sh
. $HOME/scripts/cli/lib.filesystem.sh
. $HOME/scripts/cli/lib.docker.sh
. $HOME/scripts/cli/lib.stream.sh
. $HOME/scripts/cli/gui.menu.sh
. $HOME/scripts/cli/gui.input.sh
. $HOME/scripts/cli/gui.notice.sh
. $HOME/scripts/cli/mvNotice.sh
. $HOME/scripts/cli/mvRunner.sh

#┌───────────────┐
#│ Загружаем MVC │
#└───────────────┘
# Models
. /models/modelGit.sh
. /models/modelSSH.sh
. /models/modelDocker.sh

# Runners
. /runners/runnerGit.sh
. /runners/runnerSSH.sh
. /runners/runnerNotice.sh
. /runners/runnerDocker.sh

# Entrypoints
. /entrypoints/entrypointMenu.sh
. /entrypoints/entrypointProxy.sh

# Controllers
. /controllers/controllerGit.sh
. /controllers/controllerSSH.sh
. /controllers/controllerDocker.sh

# Views
. /views/view.sh
. /views/viewGit.sh
. /views/viewSSH.sh
. /views/viewMenu.sh
. /views/viewNotice.sh
. /views/viewDocker.sh

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
