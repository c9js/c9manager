#▄────────────────────▄
#█                    █
#█  Model: Docker     █
#█  • Докер (логика)  █
#█                    █
#▀────────────────────▀
model:Docker() { case "$1" in
#┌───────────────────────────────┐
#│ Проверяет существует-ли образ │
#└───────────────────────────────┘
    'no_image')
        ! docker:isImage "$IMAGE_START"
    ;;
    
#┌───────────────────────────────────┐
#│ Проверяет существует-ли контейнер │
#└───────────────────────────────────┘
    'no_container')
    # Получаем информацию о запущенном контейнере
        docker:containerInfo "$WORKSPACE"
        
    # Контейнер не найден
        [ -z "$RUN_IMAGE" ]
    ;;
    
#┌─────────────────────────┐
#│ Сохраняет список портов │
#└─────────────────────────┘
    'run_ports')
    # Список аргументов
        local count="$2" # Количество дополнительных портов
        local port="$3"  # Выбранный порт
        
    # Создаем список портов (добавляем основной порт)
        RUN_PORTS=("$PORT_BASIC")
        
    # Добавляем выбранный порт
        [ -n "$port" ] && RUN_PORTS=("$port:$PORT_BASIC")
        
    # Проверяем дополнительные порты
        if [ $count != 0 ]; then
        # Получаем диапазон портов
            let PORTS_COUNT=$PORT_EXTRA+$count-1
            
       # Добавляем дополнительные порты
            RUN_PORTS+=('-p' "$PORT_EXTRA-$PORTS_COUNT")
        fi
        
    # Сохраняем количество дополнительных портов
        PORTS_COUNT="$count"
        
    # Обнуляем основной порт
        PORT=''
    ;;
    
#┌─────────────────────────────┐
#│ Сохраняет список аргументов │
#└─────────────────────────────┘
    'run_args')
    # Сохраняем список портов
        model:Docker 'run_ports' 1
        
    # Сохраняем выбранный вариант
        SELECTION="$2"
        
    # Сохраняем имя образа
        IMAGE_NAME="$3"
        
    # Сохраняем имя проекта
        PROJECT_NAME="$4"
        
    # Сохраняем имя образа (для запуска)
        IMAGE_RUN="$IMAGE_NAME:$VERSION"
        
    # Сохраняем путь к рабочему каталогу (из docker-а)
        PATH_PROJECT="/$PROJECT_NAME"
        
    # Сохраняем путь к рабочему каталогу (вне docker-а)
        PATH_PROJECT_PWD="${DOCKER_PWD}${PATH_PROJECTS}${PATH_PROJECT}"
        
    # Сохраняем путь к списоку внешних портов
        PATH_PROJECT_PORTS="${PATH_WORKSPACE}${PATH_PROJECTS}${PATH_PROJECT}${PATH_PORTS}"
        
    # Поиск только выбранного образа
        IMAGES_SEARCH=(
            "$IMAGE_NAME" # Имя образа
        )
        
    # Сохраняем общее количество шагов для прогресс
        DOCKER_FULL="${#CONTAINER_REMOVE[*]}"
    ;;
    
#┌─────────────────────┐
#│ Создает новый образ │
#└─────────────────────┘
    'build')
    # Список аргументов
        local selection="$2"  # Выбранный вариант
        local image_name="$3" # Имя образа
        
    # Локальные переменные
        local project_name="$image_name" # Имя проекта
        
    # Сохраняет список аргументов
        model:Docker 'run_args' "$selection" "$image_name" "$project_name"
        
    # Сохраняем имя образа (для запуска)
        IMAGE_RUN="$IMAGE_NAME"
        
    # Сохраняем общее количество шагов для прогресс
        DOCKER_FULL="${#DELETE_LIST[*]}"
        
    # Удаляем старый образ
        if [ $SELECTION == 3 ]; then
            runner "${DELETE_LIST[@]}"
            return
        fi
        
    # Запускаем новый контейнер (после сборки)
        if array:includes "$IMAGE_NAME" "${IMAGES_RUN[@]}"; then
            runner "${RUN_BUILD[@]}"
            return
        fi
        
    # Создаем новый образ
        runner "${CREATE_LIST[@]}"
    ;;
    
#┌────────────────────────────────────────────────┐
#│ Запускает новый контейнер (для первого старта) │
#└────────────────────────────────────────────────┘
    'run_c9start')
    # Список аргументов
        local selection="$2" # Выбранный вариант
        local port="$3"      # Выбранный порт
        
    # Локальные переменные
        local project_name="$WORKSPACE" # Имя проекта
        local image_name="$IMAGE_START" # Имя образа
        
    # Сохраняет список аргументов
        model:Docker 'run_args' "$selection" "$image_name" "$project_name"
        
    # Сохраняем список портов
        model:Docker 'run_ports' 0 "$port"
        
    # Сохраняем путь к рабочему каталогу (вне docker-а)
        PATH_PROJECT_PWD="$DOCKER_PWD"
        
    # Сохраняем путь к списоку внешних портов
        PATH_PROJECT_PORTS="${PATH_WORKSPACE}${PATH_PORTS}"
        
    # Выполняем список команд
        runner "${RUN_LIST[@]}"
    ;;
    
#┌───────────────────────────────────────────────┐
#│ Удаляет старый контейнер (для первого старта) │
#└───────────────────────────────────────────────┘
    'stop_c9start')
    # Сохраняем выбранный вариант
        SELECTION="$2"
        
    # Сохраняем имя проекта
        PROJECT_NAME="$WORKSPACE"
        
    # Сохраняем общее количество шагов для прогресс
        DOCKER_FULL="${#CONTAINER_REMOVE[*]}"
        
    # Выполняем список команд
        runner "${CONTAINER_REMOVE[@]}"
    ;;
    
#┌────────────────────────┐
#│ Удаляет все контейнеры │
#└────────────────────────┘
    'stop_all')
    # Сохраняем выбранный вариант
        SELECTION="$2"
        
    # Поиск всех образов
        IMAGES_SEARCH=('')
        
    # Сохраняем общее количество шагов для прогресс
        DOCKER_FULL="${#CONTAINERS_REMOVE[*]}"
        
    # Выполняем список команд
        runner "${CONTAINERS_REMOVE[@]}"
    ;;
    
#┌────────────────────┐
#│ Удаляет все образы │
#└────────────────────┘
    'remove_all')
    # Сохраняем выбранный вариант
        SELECTION="$2"
        
    # Поиск всех образов
        IMAGES_SEARCH=('')
        
    # Сохраняем общее количество шагов для прогресс
        DOCKER_FULL="${#IMAGES_REMOVE[*]}"
        
    # Выполняем список команд
        runner "${IMAGES_REMOVE[@]}"
    ;;
esac
}
