#!/bin/bash
# reset
# exit
#┌──────────────────────┐
#│ Загружаем библиотеки │
#└──────────────────────┘
. /$WORKSPACE/scripts/cli/lib.base.sh
. /$WORKSPACE/scripts/cli/lib.stream.sh
. /$WORKSPACE/scripts/cli/gui.menu.sh
. /$WORKSPACE/scripts/cli/gui.input.sh
. /$WORKSPACE/scripts/cli/gui.notice.sh
. /$WORKSPACE/scripts/cli/mvNotice.sh
. /$WORKSPACE/scripts/cli/mvRunner.sh

#┌───────────────┐
#│ Загружаем MVC │
#└───────────────┘
# Models
. /$WORKSPACE/scripts/amend/models/modelCheck.sh
. /$WORKSPACE/scripts/amend/models/modelEdit.sh
. /$WORKSPACE/scripts/amend/models/modelLoad.sh
. /$WORKSPACE/scripts/amend/models/modelMenu.sh

# Entrypoints
. /$WORKSPACE/scripts/amend/entrypoints/entrypointMenu.sh

# Controllers
. /$WORKSPACE/scripts/amend/controllers/controllerCheck.sh
. /$WORKSPACE/scripts/amend/controllers/controllerEdit.sh
. /$WORKSPACE/scripts/amend/controllers/controllerLoad.sh
. /$WORKSPACE/scripts/amend/controllers/controllerMenu.sh

# Runners
. /$WORKSPACE/scripts/amend/runners/runnerEdit.sh
. /$WORKSPACE/scripts/amend/runners/runnerNotice.sh

# Views
. /$WORKSPACE/scripts/amend/views/view.sh
. /$WORKSPACE/scripts/amend/views/viewEdit.sh
. /$WORKSPACE/scripts/amend/views/viewLoad.sh
. /$WORKSPACE/scripts/amend/views/viewMenu.sh
. /$WORKSPACE/scripts/amend/views/viewNotice.sh

#┌───────────────────┐
#│ Список переменных │
#└───────────────────┘
MAX_COMMIT=5 # Количество коммитов на странице
DEV_MODE=0   # Режим разаработки

#┌─────────────┐
#│ Точки входа │
#└─────────────┘
entrypoint:Menu
