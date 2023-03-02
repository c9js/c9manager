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
                (( ${#image_id} != 12 )) && break
                
            # Проверяем есть-ли в списке образ с таким ID
                if [ -z "${IMAGES_IDS[$image_id]}" ]; then
                # Добавляем ID-образа в список
                    IMAGES_IDS[$image_id]="$image_id"
                fi
            done <<< "$RES"
            
        # Вычисляем процент
            local procent="$(procent $(($i+1)) ${#IMAGES_SEARCH[*]} $RUNNER_NOW $DOCKER_FULL)"
            
        # Обновляем текущий прогресс
            progress "${#IMAGES_IDS[*]}" "$(progressBar 20 $procent)"
        done
    ;;
    
#┌──────────────────────┐
#│ Поиск ID-контейнеров │
#└──────────────────────┘
    'void:check_images')
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
                (( ${#container_id} != 12 )) && break
                
            # Нельзя останавливать текущий контейнер
                [[ "$HOSTNAME" == "$container_id" ]] && continue
                
            # Нельзя останавливать родительский контейнер
                [[ "$PARENT_HOSTNAME" == "$container_id" ]] && continue
                
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
        # Удаляем контейнер
            docker rm --force "${CONTAINER_IDS[$i]}" &> '/dev/null'
            
        # Вычисляем процент
            local procent="$(procent $(($i+1)) ${#CONTAINER_IDS[*]} $RUNNER_NOW $DOCKER_FULL)"
            
        # Обновляем текущий прогресс
            progress "$(($i+1))" "$(progressBar 20 $procent)"
        done
        
    # Обновляем текущий прогресс
        if (( ${#CONTAINER_IDS[*]} == 0 )); then
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
        # Удаляем образ
            docker rmi --force "$image_id" &> '/dev/null'
            
        # Увеличиваем порядковый номер
            let i++
            
        # Вычисляем процент
            local procent="$(procent $i ${#IMAGES_IDS[*]} $RUNNER_NOW $DOCKER_FULL)"
            
        # Обновляем текущий прогресс
            progress "$i" "$(progressBar 20 $procent)"
        done
        
    # Обновляем текущий прогресс
        if (( ${#IMAGES_IDS[*]} == 0 )); then
            progress 0 "$(progressBar 20 $(procent 100 100 $RUNNER_NOW $DOCKER_FULL))"
        fi
        
    # Команда успешно выполнена
        return 0
    ;;
    
#┌──────────────┐
#│ Поиск образа │
#└──────────────┘
    'void:search_image')
    # Получаем ID-образа
        RUN docker images -aq "$IMAGE_RUN:$VERSION" && return 1
        
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
        docker pull "$IMAGE_RUN:$VERSION"
    ;;
    
#┌───────────────────────────┐
#│ Запускает новый контейнер │
#└───────────────────────────┘
    'run')
    # Локальные переменные
        local PORT2=$(($PORT1+1))
        
    # Запускаем контейнер
        docker run \
            --name "$WORKSPACE" \
            --hostname "$WORKSPACE" \
            -p "$PORT1:$PORT1" \
            -p "$PORT2:$PORT2" \
            -e "C9_PORT=$PORT1" \
            -e "PORT=$PORT2" \
            -e "VERSION=$VERSION" \
            -e "PATH_WORKSPACE=$PATH_WORKSPACE" \
            -e "PATH_VERSION=$PATH_WORKSPACE/$PATH_VERSION" \
            -e "PATH_GIT_USER=$PATH_WORKSPACE/$PATH_GIT_USER" \
            -e "PATH_GIT_REPO=$PATH_WORKSPACE/$PATH_GIT_REPO" \
            -e "PATH_DOCKER_USER=$PATH_WORKSPACE/$PATH_DOCKER_USER" \
            -e "PATH_DOCKER_PASS=$PATH_WORKSPACE/$PATH_DOCKER_PASS" \
            -e "PATH_BAD_DEPLOY=$PATH_WORKSPACE/$PATH_BAD_DEPLOY" \
            -e "GIT_URL=$GIT_URL" \
            -e "GIT_USER=$GIT_USER" \
            -e "GIT_REPO=$GIT_REPO" \
            -e "WORKSPACE=$WORKSPACE" \
            -e "DOCKER_USER=$DOCKER_USER" \
            -e "DOCKER_PWD=$DOCKER_PWD" \
            -v "$DOCKER_PWD:$PATH_WORKSPACE" \
            -v "$DOCKER_PWD/ssh:/root/.sshsource" \
            -v '//var/run/docker.sock:/var/run/docker.sock' --privileged \
            --restart unless-stopped \
            --detach -it \
            "$IMAGE_RUN:$VERSION" 1> '/dev/null'
    ;;
esac
}
