#!/bin/bash
#┌────────────────────────────────────────────┐
#│ Путь к каталогу где расположен этот скрипт │
#└────────────────────────────────────────────┘
PATH_DIR="$(dirname $0)"

#┌──────────────────────┐
#│ Загружаем библиотеки │
#└──────────────────────┘
. $PATH_DIR/../cli/lib.base.sh
. $PATH_DIR/../cli/lib.stream.sh
. $PATH_DIR/../cli/gui.menu.sh
. $PATH_DIR/../cli/gui.input.sh
. $PATH_DIR/../cli/gui.notice.sh
. $PATH_DIR/../cli/mvNotice.sh
. $PATH_DIR/../cli/mvRunner.sh

#┌───────────────┐
#│ Загружаем MVC │
#└───────────────┘
# Entrypoints
. $PATH_DIR/entrypoints/entrypointMenu.sh

# Controllers
. $PATH_DIR/controllers/controllerCheck.sh
. $PATH_DIR/controllers/controllerEdit.sh
. $PATH_DIR/controllers/controllerLoad.sh
. $PATH_DIR/controllers/controllerMenu.sh

# Models
. $PATH_DIR/models/modelCheck.sh
. $PATH_DIR/models/modelEdit.sh
. $PATH_DIR/models/modelLoad.sh
. $PATH_DIR/models/modelMenu.sh

# Runners
. $PATH_DIR/runners/runnerEdit.sh
. $PATH_DIR/runners/runnerNotice.sh

# Views
. $PATH_DIR/views/view.sh
. $PATH_DIR/views/viewEdit.sh
. $PATH_DIR/views/viewMenu.sh
. $PATH_DIR/views/viewNotice.sh

#┌───────────────────┐
#│ Список переменных │
#└───────────────────┘
MAX_COMMIT=5 # Количество коммитов на странице
DEV_MODE=0   # Режим разаработки

#┌─────────────┐
#│ Точки входа │
#└─────────────┘
entrypoint:Menu
