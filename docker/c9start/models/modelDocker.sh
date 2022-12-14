#▄────────────────────▄
#█                    █
#█  Model: Docker     █
#█  • Докер (логика)  █
#█                    █
#▀────────────────────▀
model:Docker() { local i; case "$1" in
#┌───────────────────────────────┐
#│ Проверяет существует-ли образ │
#└───────────────────────────────┘
    'no_image')
        ! is_image "$IMAGE_RUN"
    ;;
    
#┌───────────────────────────────────┐
#│ Проверяет существует-ли контейнер │
#└───────────────────────────────────┘
    'no_container')
    # Получает информацию о запущенном контейнере
        getContainerInfo "$WORKSPACE"
        
    # Контейнер не найден
        [ -z "$RUN_IMAGE" ]
    ;;
    
#┌─────────────────────────────────────────────┐
#│ Получает список ID-образов и ID-контейнеров │
#└─────────────────────────────────────────────┘
    'get_ids')
    # Получаем список всех ID-образов
        if [[ "$3" == 'all' ]]; then
            getImageIDs "$2 1"
            
    # Получаем список ID-образов из списка $IMAGES
        else
            getImageIDs "$2 1" "${IMAGES[@]}"
        fi
        
    # Получаем список ID-контейнеров
        getContainerIDs "$2 2" "${imageIDs[@]}"
    ;;
    
#┌──────────────────────────┐
#│ Останавливает контейнеры │
#└──────────────────────────┘
    'stop_containers')
    # Проходим по списку ID-контейнеров
        for ((i = 0; i < ${#containerIDs[*]}; i++)); do
        # Обновляем текущий статус
            $2 \
                3 'Остановка контейнеров' $i ${#containerIDs[*]}
                
        # Останавливаем контейнер
            docker stop "${containerIDs[$i]}" &> '/dev/null'
        done
    ;;
    
#┌────────────────────┐
#│ Удаляет контейнеры │
#└────────────────────┘
    'remove_containers')
    # Проходим по списку ID-контейнеров
        for ((i = 0; i < ${#containerIDs[*]}; i++)); do
        # Обновляем текущий статус
            $2 \
                4 'Удаление контейнеров' $i ${#containerIDs[*]}
                
        # Удаляем контейнер
            docker rm "${containerIDs[$i]}" &> '/dev/null'
        done
    ;;
    
#┌────────────────┐
#│ Удаляет образы │
#└────────────────┘
    'remove_images')
    # Удаляем все образы
        for ((i = 0; i < ${#imageIDs[*]}; i++)); do
        # Обновляем текущий статус
            $2 \
                5 'Удаление образов' $i ${#imageIDs[*]}
                
        # Удаляем образ
            docker rmi "${imageIDs[$i]}" -f &> '/dev/null'
        done
    ;;
    
#┌──────────────────────────────────────────────────────┐
#│ Останавливает и удаляет контейнеры из списка $IMAGES │
#└──────────────────────────────────────────────────────┘
    'stop')
    # Получаем список ID-контейнеров
        model:Docker 'get_ids' "$2"
        
    # Останавливаем контейнеры
        model:Docker 'stop_containers' "$2"
        
    # Удаляем контейнеры
        model:Docker 'remove_containers' "$2"
    ;;
    
#┌────────────────────────────────────────┐
#│ Останавливает и удаляет все контейнеры │
#└────────────────────────────────────────┘
    'stop_all')
    # Получаем список всех ID-контейнеров
        model:Docker 'get_ids' "$2" 'all'
        
    # Останавливаем все контейнеры
        model:Docker 'stop_containers' "$2"
        
    # Удаляем все контейнеры
        model:Docker 'remove_containers' "$2"
    ;;
    
#┌────────────────────┐
#│ Удаляет все образы │
#└────────────────────┘
    'remove_all')
    # Получаем список ID-образов и ID-контейнеров
        model:Docker 'get_ids' "$2" 'all'
        
    # Останавливаем все контейнеры
        model:Docker 'stop_containers' "$2"
        
    # Удаляем все контейнеры
        model:Docker 'remove_containers' "$2"
        
    # Удаляем все образы
        model:Docker 'remove_images' "$2"
    ;;
    
#┌─────────────────┐
#│ Скачивает образ │
#└─────────────────┘
    'download')
    # Образ не найден
        if ! is_image "$IMAGE_RUN:$VERSION"; then
        # Скачиваем образ
            if ! docker pull "$IMAGE_RUN:$VERSION"; then
            # Образ не был скачан
                return 1
            fi
        fi
    ;;
    
#┌───────────────────────────┐
#│ Запускает новый контейнер │
#└───────────────────────────┘
    'start')
    # Локальные переменные
        local PORT1="$2"
        local PORT2=$(($2+1))
        local error_msg
        
    # Запускаем контейнер
        if ! error_msg=$(docker run \
            --name "$WORKSPACE" \
            --hostname "$WORKSPACE" \
            -p "$PORT1:$PORT1" \
            -p "$PORT2:$PORT2" \
            -e "C9_PORT=$PORT1" \
            -e "PORT=$PORT2" \
            -e "VERSION=$VERSION" \
            -e "PATH_VERSION=/$WORKSPACE/$PATH_VERSION" \
            -e "PATH_GIT_USER=/$WORKSPACE/$PATH_GIT_USER" \
            -e "PATH_GIT_REPO=/$WORKSPACE/$PATH_GIT_REPO" \
            -e "PATH_DOCKER_USER=/$WORKSPACE/$PATH_DOCKER_USER" \
            -e "PATH_DOCKER_PASS=/$WORKSPACE/$PATH_DOCKER_PASS" \
            -e "PATH_BAD_DEPLOY=/$WORKSPACE/$PATH_BAD_DEPLOY" \
            -e "GIT_URL=$GIT_URL" \
            -e "GIT_USER=$GIT_USER" \
            -e "GIT_REPO=$GIT_REPO" \
            -e "WORKSPACE=$WORKSPACE" \
            -e "DOCKER_USER=$DOCKER_USER" \
            -e "DOCKER_PWD=$DOCKER_PWD" \
            -v "$DOCKER_PWD:/$WORKSPACE" \
            -v "$DOCKER_PWD/ssh:/root/.sshsource" \
            -v '//var/run/docker.sock:/var/run/docker.sock' --privileged \
            --restart unless-stopped \
            --detach -it \
            "$IMAGE_RUN:$VERSION" 2>&1
        ); then
        # Выводим сообщение об ошибке
            echo "$error_msg"
            return 1
        fi
        
    # Контейнер успешно запущен
        return 0
    ;;
esac
}
