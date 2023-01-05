#!/bin/bash
#┌────────────────────────────────────────────┐
#│ Путь к каталогу где расположен этот скрипт │
#└────────────────────────────────────────────┘
DIR_PATH="$(dirname $0)"

#┌──────────────────────┐
#│ Загружаем библиотеки │
#└──────────────────────┘
. $DIR_PATH/../cli/lib.base.sh
. $DIR_PATH/../cli/lib.filesystem.sh
. $DIR_PATH/../cli/lib.stream.sh
. $DIR_PATH/../cli/gui.menu.sh
. $DIR_PATH/../cli/gui.input.sh
. $DIR_PATH/../cli/gui.notice.sh
. $DIR_PATH/../cli/mvNotice.sh

#┌───────────────┐
#│ Загружаем MVC │
#└───────────────┘
# Models
. $DIR_PATH/models/modelDeploy.sh
. $DIR_PATH/models/modelSettings.sh
. $DIR_PATH/models/modelUpdate.sh

# Runners
. $DIR_PATH/runners/runnerDeploy.sh
. $DIR_PATH/runners/runnerNotice.sh

# Entrypoints
. $DIR_PATH/entrypoints/entrypointMenu.sh

# Controllers
. $DIR_PATH/controllers/controllerDeploy.sh
. $DIR_PATH/controllers/controllerSettings.sh
. $DIR_PATH/controllers/controllerUpdate.sh

# Views
. $DIR_PATH/views/view.sh
. $DIR_PATH/views/viewDeploy.sh
. $DIR_PATH/views/viewMenu.sh
. $DIR_PATH/views/viewNotice.sh
. $DIR_PATH/views/viewSettings.sh

#┌───────────────────────────────┐
#│ Версии: Micro / Minor / Major │
#└───────────────────────────────┘
micro="${VERSION#[0-9]*.[0-9]*.}"
minor="${VERSION#[0-9]*.}"
minor="${minor%.[0-9]*}"
major="${VERSION%.[0-9]*.[0-9]*}"

MICRO="$major.$minor.$(($micro+1))"
MINOR="$major.$(($minor+1)).0"
MAJOR="$(($major+1)).0.0"

#┌─────────────────────────────┐
#│ Переходим в рабочий каталог │
#└─────────────────────────────┘
cd "/$WORKSPACE"

#┌─────────────┐
#│ Точки входа │
#└─────────────┘
entrypoint:Menu # Меню
