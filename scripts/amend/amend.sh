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

# Controllers
. $PATH_DIR/controllers/controllerCheck.sh
. $PATH_DIR/controllers/controllerEdit.sh

# Models
. $PATH_DIR/models/modelCheck.sh
. $PATH_DIR/models/modelEdit.sh

# Runners
. $PATH_DIR/runners/runnerEdit.sh
. $PATH_DIR/runners/runnerNotice.sh

# Views
. $PATH_DIR/views/view.sh
. $PATH_DIR/views/viewMenu.sh
. $PATH_DIR/views/viewEdit.sh
. $PATH_DIR/views/viewNotice.sh

#┌──────────────────┐
#│ Режим разработки │
#└──────────────────┘
DEV_MODE=0

#┌───────────────────┐
#│ Список переменных │
#└───────────────────┘
COMMITS_MAX=5 # Количество коммитов на странице

#┌─────────────┐
#│ Точки входа │
#└─────────────┘
entrypoint:Menu
