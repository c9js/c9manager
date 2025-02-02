#▄──────────────────▄1.0.2
#█                  █
#█  Core: Docker    █
#█  • Докер (ядро)  █
#█                  █
#▀──────────────────▀
core:Docker() { case "$1" in
#┌─────────────────────────────────────────────────┐
#│ Проверяет существуют-ли образы,                 │
#│ далее добавляет найденые ID в массив $GLOBAL_ID │
#│ docker:isImage "$IMAGE_RUN"                     │
#└─────────────────────────────────────────────────┘
    'isImage')
    # Создаем список ID-образов
        GLOBAL_ID=()
        
    # Получаем список ID-образов
        local ids=$(docker images -aq "$2" 2>&1)
        
    # ID-образа
        local image_id
        
    # Проходим по списку ID-образов
        while read -r image_id; do
        # Проверяем длину ID-образа
            [ ${#image_id} != 12 ] && return 1
            
        # Добавляем ID-образа в список
            GLOBAL_ID+=("$image_id")
        done <<< "$ids"
        
    # Список пуст
        if [ ${#GLOBAL_ID[*]} == 0 ]; then
            return 1
        fi
        
    # Образы существуют
        return 0
    ;;
    
#┌─────────────────────────────────────────────────┐
#│ Проверяет существуют-ли контейнеры,             │
#│ далее добавляет найденые ID в массив $GLOBAL_ID │
#│ docker:isContainer "ancestor=$IMAGE_RUN"        │
#│ docker:isContainer "name=^${IMAGE_RUN}$"        │
#└─────────────────────────────────────────────────┘
    'isContainer')
    # Создаем список ID-контейнеров
        GLOBAL_ID=()
        
    # Получаем список ID-контейнеров
        local ids=$(docker ps -aq --filter "$2" 2>&1)
        
    # ID-контейнера
        local container_id
        
    # Проходим по списку ID-контейнеров
        while read -r container_id; do
        # Проверяем длину ID
            [ ${#container_id} != 12 ] && return 1
            
        # Нельзя останавливать текущий контейнер
            [ "$HOSTNAME" == "$container_id" ] && continue
            
        # Добавляем ID-контейнера в список
            GLOBAL_ID+=("$container_id")
        done <<< "$ids"
        
    # Список пуст
        if [ ${#GLOBAL_ID[*]} == 0 ]; then
            return 1
        fi
        
    # Контейнеры существуют
        return 0
    ;;
    
#┌─────────────────────────────────────────────┐
#│ Получает информацию о запущенном контейнере │
#│ docker:containerInfo "$WORKSPACE"           │
#└─────────────────────────────────────────────┘
    'containerInfo')
    # Список аргументов
        local name="$2" # Имя контейнера
        
    # Получаем информацию по имени контейнера
        local res="$(docker ps               \
            --filter "name=^${name}$"        \
            --format='{{.Image}}={{.Ports}}' \
        )"
        
    # Получаем имя образа
        RUN_IMAGE="${res/=*}"
        
    # Получаем версию
        RUN_VERSION="${RUN_IMAGE/*:}"
        
    # Получаем имя образа
        RUN_IMAGE="${RUN_IMAGE/:*}"
        
    # Получаем порт
        RUN_PORT="${res/*=}"
        
    # Удаляем все символы слева от порта
        RUN_PORT="${RUN_PORT/*:}"
        
    # Удаляем все символы справа от порта
        RUN_PORT="${RUN_PORT/-*}"
    ;;
    
#┌─────────────────────────────────────┐
#│ Получает внешний порт               │
#│ docker:getPort "$WORKSPACE" "$PORT" │
#└─────────────────────────────────────┘
    'getPort')
    # Список аргументов
        local name="$2" # Имя контейнера
        local port="$3" # Внутренний порт
        
    # Получаем информацию о внешних портах
        port="$(docker port \
            "$name"         \
            "$port"         \
            2> '/dev/null'
        )"
        
    # Получаем порт
        port="${port##*:}"
        
    # Возвращаем внешний порт
        echo "$port"
        
    # Внешний порт существуют
        [ -n "$port" ]
    ;;
esac
}
