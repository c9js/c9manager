#!/bin/bash
#┌────────────────────────────────────────────┐
#│ Путь к каталогу где расположен этот скрипт │
#└────────────────────────────────────────────┘
DIR_PATH="$(dirname $0)"

#┌──────────────────────┐
#│ Загружаем библиотеки │
#└──────────────────────┘
. $DIR_PATH/../cli/lib.base.sh
. $DIR_PATH/../cli/lib.stream.sh
. $DIR_PATH/../cli/gui.menu.sh
. $DIR_PATH/../cli/gui.input.sh
. $DIR_PATH/../cli/gui.notice.sh
. $DIR_PATH/../cli/mvNotice.sh
. $DIR_PATH/../cli/mvRunner.sh

#┌───────────────┐
#│ Загружаем MVC │
#└───────────────┘
# Models
. $DIR_PATH/models/modelCheck.sh
. $DIR_PATH/models/modelEdit.sh
. $DIR_PATH/models/modelLoad.sh
. $DIR_PATH/models/modelMenu.sh

# Runners
. $DIR_PATH/runners/runnerEdit.sh
. $DIR_PATH/runners/runnerNotice.sh

# Entrypoints
. $DIR_PATH/entrypoints/entrypointMenu.sh

# Controllers
. $DIR_PATH/controllers/controllerCheck.sh
. $DIR_PATH/controllers/controllerEdit.sh
. $DIR_PATH/controllers/controllerLoad.sh
. $DIR_PATH/controllers/controllerMenu.sh

# Views
. $DIR_PATH/views/view.sh
. $DIR_PATH/views/viewEdit.sh
. $DIR_PATH/views/viewMenu.sh
. $DIR_PATH/views/viewNotice.sh

#┌───────────────────┐
#│ Список переменных │
#└───────────────────┘
MAX_COMMIT=5 # Количество коммитов на странице
DEV_MODE=0   # Режим разаработки

#┌─────────────┐
#│ Точки входа │
#└─────────────┘
entrypoint:Menu
