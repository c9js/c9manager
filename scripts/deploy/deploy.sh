#!/bin/bash
#┌──────────────────────┐
#│ Загружаем библиотеки │
#└──────────────────────┘
. /$WORKSPACE/scripts/cli/lib.base.sh
. /$WORKSPACE/scripts/cli/lib.filesystem.sh
. /$WORKSPACE/scripts/cli/lib.stream.sh
. /$WORKSPACE/scripts/cli/gui.menu.sh
. /$WORKSPACE/scripts/cli/gui.input.sh
. /$WORKSPACE/scripts/cli/gui.notice.sh
. /$WORKSPACE/scripts/cli/mvNotice.sh

#┌───────────────┐
#│ Загружаем MVC │
#└───────────────┘
# Models
. /$WORKSPACE/scripts/deploy/models/modelDeploy.sh
. /$WORKSPACE/scripts/deploy/models/modelSettings.sh
. /$WORKSPACE/scripts/deploy/models/modelUpdate.sh

# Runners
. /$WORKSPACE/scripts/deploy/runners/runnerDeploy.sh
. /$WORKSPACE/scripts/deploy/runners/runnerNotice.sh

# Entrypoints
. /$WORKSPACE/scripts/deploy/entrypoints/entrypointMenu.sh

# Controllers
. /$WORKSPACE/scripts/deploy/controllers/controllerDeploy.sh
. /$WORKSPACE/scripts/deploy/controllers/controllerSettings.sh
. /$WORKSPACE/scripts/deploy/controllers/controllerUpdate.sh

# Views
. /$WORKSPACE/scripts/deploy/views/view.sh
. /$WORKSPACE/scripts/deploy/views/viewDeploy.sh
. /$WORKSPACE/scripts/deploy/views/viewMenu.sh
. /$WORKSPACE/scripts/deploy/views/viewNotice.sh
. /$WORKSPACE/scripts/deploy/views/viewSettings.sh

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
