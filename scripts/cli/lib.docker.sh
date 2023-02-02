#▄──────────▄1.0.3
#█          █
#█  Docker  █
#█          █
#▀──────────▀
#┌─────────────────────────────────────────────────┐
#│ Проверяет существуют-ли образы,                 │
#│ далее добавляет найденые ID в массив $GLOBAL_ID │
#│ docker:is_image "$IMAGE_RUN"                    │
#└─────────────────────────────────────────────────┘
docker:is_image() {
# Получаем ID-образов
    GLOBAL_ID=$(docker images -aq "$1" 2>&1)
    
# Переводим в массив
    GLOBAL_ID=($GLOBAL_ID)
    
# Массив пуст
    if (( ${#GLOBAL_ID[*]} == 0 )); then
        return 1
    fi
    
# Локальные переменные
    local id
    
# Проходим по списку ID-образов
    for id in "${GLOBAL_ID[@]}"; do
    # Проверяем длину ID
        if (( ${#id} != 12 )); then
            return 1
        fi
    done
    
# Образы существуют
    return 0
}

#┌─────────────────────────────────────────────────┐
#│ Проверяет существуют-ли контейнеры,             │
#│ далее добавляет найденые ID в массив $GLOBAL_ID │
#│ docker:is_container "ancestor=$IMAGE_RUN"       │
#│ docker:is_container "name=$IMAGE_RUN"           │
#└─────────────────────────────────────────────────┘
docker:is_container() {
# Локальные переменные
    local ids
    local id
    
# Создаем массив
    GLOBAL_ID=()
    
# Получаем ID-контейнеров
    ids=$(docker ps -aq --filter "$1" 2>&1)
    
# Переводим в массив
    for id in $ids; do
    # Проверяем длину ID
        if (( ${#id} != 12 )); then
            return 1
        fi
        
    # Нельзя останавливать текущий контейнер
        if [[ "$HOSTNAME" != "$id" ]]; then
            GLOBAL_ID+=("$id")
        fi
    done
    
# Массив пуст
    if (( ${#GLOBAL_ID[*]} == 0 )); then
        return 1
    fi
    
# Контейнеры существуют
    return 0
}

#┌─────────────────────────────────────────────┐
#│ Получает информацию о запущенном контейнере │
#│ docker:containerInfo "$WORKSPACE"           │
#└─────────────────────────────────────────────┘
docker:containerInfo() {
# Получаем информацию по имени контейнера
    local res="$(docker ps --filter "name=$1" --format='{{.Image}}={{.Ports}}')"
    
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
}
