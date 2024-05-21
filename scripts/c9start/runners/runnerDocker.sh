#▄─────────────────────▄
#█                     █
#█  Список переменных  █
#█                     █
#▀─────────────────────▀
declare -A IMAGES_IDS # Список ID-образов

#▄───────────────────────────▄
#█                           █
#█  Runner: Docker           █
#█  • Докер (запуск команд)  █
#█                           █
#▀───────────────────────────▀
runner:Docker() { case "$1" in
#┌──────────────────────┐
#│ Проверяет имя образа │
#└──────────────────────┘
    'check_image')
        array:includes "$IMAGE_NAME" "${IMAGES_BUILD[@]}"
    ;;
    
#┌──────────────────┐
#│ Поиск ID-образов │
#└──────────────────┘
    'void:search_images')
    # Обновляем текущий прогресс
        progress 0 "$(progressBar 20 $(procent 0 100 $RUNNER_NOW $DOCKER_FULL))"
        
    # Создаем список ID-образов
        IMAGES_IDS=()
        
    # Локальные переменные
        local i
        
    # Проходим по списку выбранных образов
        for ((i = 0; i < ${#IMAGES_SEARCH[*]}; i++)); do
        # Получаем список ID-образов
            RUN docker images -aq "${IMAGES_SEARCH[$i]}" && return 1
            
        # ID-образа
            local image_id
            
        # Проходим по списку ID-образов
            while read -r image_id; do
            # Проверяем длину ID-образа
                [ ${#image_id} != 12 ] && break
                
            # Проверяем есть-ли в списке образ с таким ID
                if [ -z "${IMAGES_IDS[$image_id]}" ]; then
                # Добавляем ID-образа в список
                    IMAGES_IDS[$image_id]="$image_id"
                fi
            done <<< "$RES"
            
        # Вычисляем процент
            local procent="$(procent $(($i + 1)) ${#IMAGES_SEARCH[*]} $RUNNER_NOW $DOCKER_FULL)"
            
        # Обновляем текущий прогресс
            progress "${#IMAGES_IDS[*]}" "$(progressBar 20 $procent)"
        done
    ;;
    
#┌──────────────────────┐
#│ Поиск ID-контейнеров │
#└──────────────────────┘
    'void:search_containers')
    # Обновляем текущий прогресс
        progress 0 "$(progressBar 20 $(procent 0 100 $RUNNER_NOW $DOCKER_FULL))"
        
    # Создаем список ID-контейнеров
        CONTAINER_IDS=()
        
    # Локальные переменные
        local image_id # ID-образа
        local i=0      # Порядковый номер образа
        
    # Проходим по списку ID-образов
        for image_id in "${!IMAGES_IDS[@]}"; do
        # Получаем список ID-контейнеров
            RUN docker ps -aq --filter "ancestor=$image_id" && return 1
            
        # ID-контейнера
            local container_id
            
        # Проходим по списку ID-контейнеров
            while read -r container_id; do
            # Проверяем длину ID-контейнера
                [ ${#container_id} != 12 ] && break
                
            # Нельзя останавливать текущий контейнер
                [ "$HOSTNAME" == "$container_id" ] && continue
                
            # Нельзя останавливать родительский контейнер
                [ "$PARENT_HOSTNAME" == "$container_id" ] && continue
                
            # Добавляем ID-контейнера в список
                CONTAINER_IDS+=("$container_id")
            done <<< "$RES"
            
        # Увеличиваем порядковый номер
            let i++
            
        # Вычисляем процент
            local procent="$(procent $i ${#IMAGES_IDS[*]} $RUNNER_NOW $DOCKER_FULL)"
            
        # Обновляем текущий прогресс
            progress "$i" "$(progressBar 20 $procent)"
        done
    ;;
    
#┌─────────────────────┐
#│ Поиск ID-контейнера │
#└─────────────────────┘
    'void:search_container')
    # Обновляем текущий прогресс
        progress 0 "$(progressBar 20 $(procent 0 100 $RUNNER_NOW $DOCKER_FULL))"
        
    # Создаем список ID-контейнеров
        CONTAINER_IDS=()
        
    # Получаем ID-контейнера
        RUN docker ps -aq --filter "name=^${PROJECT_NAME}$" && return 1
        
    # Добавляем ID-контейнера в список
        [ -n "$RES" ] && CONTAINER_IDS+=("$RES")
        
    # Вычисляем процент
        local procent="$(procent 100 100 $RUNNER_NOW $DOCKER_FULL)"
        
    # Обновляем текущий прогресс
        progress ${#CONTAINER_IDS[*]} "$(progressBar 20 $procent)"
        
    # Команда успешно выполнена
        return 0
    ;;
    
#┌────────────────────┐
#│ Удаляет контейнеры │
#└────────────────────┘
    'remove_containers')
    # Обновляем текущий прогресс
        progress 0 "$(progressBar 20 $(procent 0 100 $RUNNER_NOW $DOCKER_FULL))"
        
    # Локальные переменные
        local i
        
    # Проходим по списку ID-контейнеров
        for ((i = 0; i < ${#CONTAINER_IDS[*]}; i++)); do
        # Вычисляем процент
            local procent="$(procent $(($i + 1)) ${#CONTAINER_IDS[*]} $RUNNER_NOW $DOCKER_FULL)"
            
        # Обновляем текущий прогресс
            progress "$(($i + 1))" "$(progressBar 20 $procent)"
            
        # Удаляем контейнер
            docker rm --force "${CONTAINER_IDS[$i]}" &> '/dev/null'
        done
        
    # Обновляем текущий прогресс
        if [ ${#CONTAINER_IDS[*]} == 0 ]; then
            progress 0 "$(progressBar 20 $(procent 100 100 $RUNNER_NOW $DOCKER_FULL))"
        fi
        
    # Команда успешно выполнена
        return 0
    ;;
    
#┌────────────────┐
#│ Удаляет образы │
#└────────────────┘
    'remove_images')
    # Обновляем текущий прогресс
        progress 0 "$(progressBar 20 $(procent 0 100 $RUNNER_NOW $DOCKER_FULL))"
        
    # Локальные переменные
        local image_id # ID-образа
        local i=0      # Порядковый номер образа
        
    # Проходим по списку ID-образов
        for image_id in "${!IMAGES_IDS[@]}"; do
        # Увеличиваем порядковый номер
            let i++
            
        # Вычисляем процент
            local procent="$(procent $i ${#IMAGES_IDS[*]} $RUNNER_NOW $DOCKER_FULL)"
            
        # Обновляем текущий прогресс
            progress "$i" "$(progressBar 20 $procent)"
            
        # Удаляем образ
            docker rmi --force "$image_id" &> '/dev/null'
        done
        
    # Обновляем текущий прогресс
        if [ ${#IMAGES_IDS[*]} == 0 ]; then
            progress 0 "$(progressBar 20 $(procent 100 100 $RUNNER_NOW $DOCKER_FULL))"
        fi
        
    # Команда успешно выполнена
        return 0
    ;;
    
#┌──────────────────────────┐
#│ Копирует временные файлы │
#└──────────────────────────┘
    'copy_temp_files')
    # Создаем временный каталог
        mkdir -p "$PATH_WORKSPACE/docker/temp/scripts"
        
    # Копируем версию
        cp -r "$PATH_VERSION" "$PATH_WORKSPACE/docker/temp/VERSION"
        
    # Копируем bash-скрипты
        cp -r "$PATH_WORKSPACE/scripts/." "$PATH_WORKSPACE/docker/temp/scripts"
        
    # Копируем настройки редактора и bash-профиль 
        cp -r "$PATH_WORKSPACE/c9settings/." "$PATH_WORKSPACE/docker/temp"
        
    # Проверяем предусмотрены-ли для образа дополнительные алиасы
        if [ -s "$PATH_WORKSPACE/docker/$IMAGE_NAME/alias" ]; then
        # Добавляем алиасы в bash-профиль
            cat "$PATH_WORKSPACE/docker/$IMAGE_NAME/alias" >> "$PATH_WORKSPACE/docker/temp/bash_profile"
        fi
    ;;
    
#┌─────────────────────────┐
#│ Удаляет временные файлы │
#└─────────────────────────┘
    'remove_temp_files')
        rm -r "$PATH_WORKSPACE/docker/temp"
    ;;
    
#┌─────────────────────┐
#│ Создает новый образ │
#└─────────────────────┘
    'build')
        docker build \
            --build-arg "entrypoint=$IMAGE_NAME" \
            -f "$PATH_WORKSPACE/docker/$IMAGE_NAME/Dockerfile" \
            -t "$IMAGE_NAME" \
            "$PATH_WORKSPACE/docker"
    ;;
    
#┌─────────────────┐
#│ Поиск ID-образа │
#└─────────────────┘
    'void:search_image')
    # Получаем ID-образа
        RUN docker images -aq "$IMAGE_RUN" && return 1
        
    # Сохраняем результат
        IS_IMAGE="$RES"
    ;;
    
#┌─────────────────┐
#│ Скачивает образ │
#└─────────────────┘
    'download')
    # Образ уже загружен
        [ -n "$IS_IMAGE" ] && return 0
        
    # Скачиваем образ
        docker pull "$IMAGE_RUN"
    ;;
    
#┌───────────────────────────┐
#│ Запускает новый контейнер │
#└───────────────────────────┘
    'run')
    # Запускаем контейнер
        docker run \
            -p "${RUN_PORTS[@]}"                            \
            -e "PORT=$PORT_EXTRA"                           \
            -e "PORT_BASIC=$PORT_BASIC"                     \
            -e "VERSION=$VERSION"                           \
            -e "GIT_URL=$GIT_URL"                           \
            -e "GIT_USER=$GIT_USER"                         \
            -e "GIT_REPO=$GIT_REPO"                         \
            -e "WORKSPACE=$PROJECT_NAME"                    \
            -e "DOCKER_USER=$DOCKER_USER"                   \
            -e "DOCKER_PWD=$DOCKER_PWD"                     \
            -e "PATH_PORTS=$PATH_PORTS"                     \
            -e "PATH_VERSION=$PATH_VERSION"                 \
            -e "PATH_WORKSPACE=$PATH_PROJECT"               \
            -e "PATH_GIT_USER=$PATH_GIT_USER"               \
            -e "PATH_GIT_REPO=$PATH_GIT_REPO"               \
            -e "PATH_DOCKER_USER=$PATH_DOCKER_USER"         \
            -e "PATH_DOCKER_PASS=$PATH_DOCKER_PASS"         \
            -e "PATH_BAD_DEPLOY=$PATH_BAD_DEPLOY"           \
            -v "$PATH_PROJECT_PWD:$PATH_PROJECT"            \
            -v "$DOCKER_PWD/$SSH_DIR:/root/.sshsource"      \
            -v '//var/run/docker.sock:/var/run/docker.sock' \
            --detach -it --privileged                       \
            --restart unless-stopped                        \
            --name "$PROJECT_NAME"                          \
            "$IMAGE_RUN" 1> '/dev/null'
    ;;
    
#┌─────────────────────────┐
#│ Удаляет порты из списка │
#└─────────────────────────┘
    'remove_ports')
        save_file "$PATH_PROJECT_PORTS"
    ;;
    
#┌────────────────────────┐
#│ Получает список портов │
#└────────────────────────┘
    'void:get_ports')
    # Получаем основной порт
        RUN docker:getPort "$PROJECT_NAME" "$PORT_BASIC" && return 1
        
    # Сохраняем основной порт
        PORT="$RES"
        
    # Добавлям основной порт в список портов
        PORTS="$PORT:$PORT_BASIC"
        
    # Локальные переменные
        local port # Внутренний порт
        local i
        
    # Проходим по списку внутренних портов
        for ((i = 0; i < $PORTS_COUNT; i++)); do
        # Получаем внутренний порт
            let port=$PORT_EXTRA+$i
            
        # Получаем внешний порт
            RUN docker:getPort "$PROJECT_NAME" "$port" && return 1
            
        # Добавлям внешний порт в список портов
            PORTS="$PORTS,$RES:$port"
        done
    ;;
    
#┌─────────────────────────┐
#│ Сохраняет список портов │
#└─────────────────────────┘
    'save_ports')
        save_file "$PATH_PROJECT_PORTS" "$PORTS"
    ;;
esac
}
