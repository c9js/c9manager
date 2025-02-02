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
. $PATH_DIR/entrypoints/entrypointDeploy.sh

# Controllers
. $PATH_DIR/controllers/controllerDeploy.sh
. $PATH_DIR/controllers/controllerUpdate.sh
. $PATH_DIR/controllers/controllerSettings.sh

# Models
. $PATH_DIR/models/modelDeploy.sh
. $PATH_DIR/models/modelUpdate.sh
. $PATH_DIR/models/modelSettings.sh

# Runners
. $PATH_DIR/runners/runnerDeploy.sh
. $PATH_DIR/runners/runnerNotice.sh

# Navigators
. $PATH_DIR/navigators/navigatorDeploy.sh

# Views
. $PATH_DIR/views/viewDeploy.sh
. $PATH_DIR/views/viewSettings.sh
. $PATH_DIR/views/viewNotice.sh

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
cd "$PATH_WORKSPACE"

#┌─────────────┐
#│ Точки входа │
#└─────────────┘
entrypoint:Deploy
