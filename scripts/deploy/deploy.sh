#!/bin/bash
#┌────────────────────────────────────────────┐
#│ Путь к каталогу где расположен этот скрипт │
#└────────────────────────────────────────────┘
PATH_DIR="$(dirname $0)"

#┌──────────────────────┐
#│ Загружаем библиотеки │
#└──────────────────────┘
. $PATH_DIR/../cli/lib.base.sh
. $PATH_DIR/../cli/lib.filesystem.sh
. $PATH_DIR/../cli/lib.stream.sh
. $PATH_DIR/../cli/gui.menu.sh
. $PATH_DIR/../cli/gui.input.sh
. $PATH_DIR/../cli/gui.notice.sh
. $PATH_DIR/../cli/mvNotice.sh

#┌───────────────┐
#│ Загружаем MVC │
#└───────────────┘
# Entrypoints
. $PATH_DIR/entrypoints/entrypointMenu.sh

# Controllers
. $PATH_DIR/controllers/controllerDeploy.sh
. $PATH_DIR/controllers/controllerSettings.sh
. $PATH_DIR/controllers/controllerUpdate.sh

# Models
. $PATH_DIR/models/modelDeploy.sh
. $PATH_DIR/models/modelSettings.sh
. $PATH_DIR/models/modelUpdate.sh

# Runners
. $PATH_DIR/runners/runnerDeploy.sh
. $PATH_DIR/runners/runnerNotice.sh

# Views
. $PATH_DIR/views/view.sh
. $PATH_DIR/views/viewDeploy.sh
. $PATH_DIR/views/viewMenu.sh
. $PATH_DIR/views/viewNotice.sh
. $PATH_DIR/views/viewSettings.sh

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
