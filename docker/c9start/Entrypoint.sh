#!/bin/bash
#┌──────────────────────┐
#│ Загружаем библиотеки │
#└──────────────────────┘
. ~/cli/lib.base.sh
. ~/cli/lib.filesystem.sh
. ~/cli/lib.docker.sh
. ~/cli/lib.stream.sh
. ~/cli/gui.menu.sh
. ~/cli/gui.input.sh
. ~/cli/gui.notice.sh

#┌───────────────┐
#│ Загружаем MVC │
#└───────────────┘
# Models
. /models/modelAPI.sh
. /models/modelMenu.sh
. /models/modelNotice.sh
. /models/modelDocker.sh
. /models/modelRequest.sh

# Entrypoints
. /entrypoints/entrypointAPI.sh
. /entrypoints/entrypointMenu.sh

# Controllers
. /controllers/controllerMenu.sh
. /controllers/controllerNotice.sh
. /controllers/controllerDocker.sh
. /controllers/controllerRequest.sh

# Views
. /views/view.sh
. /views/viewMenu.sh
. /views/viewNotice.sh

#┌───────────────────────────────────────────────┐
#│ Путь к текущему каталогу вне docker-а         │
#├───────────────────────────────────────────────┤
#│ Конвертируем:                                 │
#│ Путь Windows -> "D:\MyProjects\project"       │
#│ в путь Linux -> "/d/MyProjects/project"       │
#│ 1. Переводим первый символ в нижний регистр   │
#│ 2. Переводим обратные слешы "\" в "/"         │
#│ 3. Добавляем в начало "/", (если его там нет) │
#│ 4. Удаляем ":"                                │
#└───────────────────────────────────────────────┘
DOCKER_PWD=$(echo "$CD" | sed \
    -e 's/[A-Z]/\L&/' \
    -e 's-\\-\/-g' \
    -e '/^\//!s-^-/-' \
    -e 's-:--' \
)

#┌─────────────┐
#│ Разделитель │
#└─────────────┘
[[ "${CD/\\}" != "$CD" ]] && SEP='\' || SEP='/'

#┌───────────────────┐
#│ Список переменных │
#└───────────────────┘
PATH_VERSION='VERSION'                 # Путь к файлу где хранится номер версии
PATH_GIT_USER='.c9/deploy/git_user'       # Путь к файлу где хранится имя git-юзера
PATH_GIT_REPO='.c9/deploy/git_repo'       # Путь к файлу где хранится имя git-репозитория
PATH_DOCKER_USER='.c9/deploy/docker_user' # Путь к файлу где хранится логин от docker-репозитория
PATH_DOCKER_PASS='.c9/deploy/docker_pass' # Путь к файлу где хранится пароль от docker-репозитория
PATH_LAST_DEPLOY='.c9/deploy/last_deploy' # Путь к файлу где хранится информация о последнем деплое

SSH_DIR='ssh'             # Путь к каталогу где хранятся ssh-ключи
CURRENT_PATH='/root/repo' # Путь к текущему каталогу из docker-а
GIT_URL='github.com'      # URL git-репозитория
PORT_DEFAULT='8000'       # (по умолчанию) Порт
DOCKER_USER='c9js'        # (по умолчанию) Логин от docker-репозитория
GIT_USER='c9js'           # (по умолчанию) Имя git-юзера
GIT_REPO='c9manager'      # (по умолчанию) Имя git-репозитория
WORKSPACE='c9manager'     # (по умолчанию) Имя рабочего каталога
IMAGE_RUN='c9js/c9docker' # Имя образа который запускаем
IMAGE_API='c9js/c9start'  # Имя текущего образа
# IMAGE_DEV='c9start'     # Имя текущего образа для тестирования
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
    'API') entrypoint:API "$@" ;; # Внутренний запрос
    *)     entrypoint:Menu     ;; # Меню
esac
