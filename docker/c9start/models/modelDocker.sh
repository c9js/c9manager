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
    
#┌───────────────────────────┐
#│ Запускает новый контейнер │
#└───────────────────────────┘
    'run')
    # Сохраняем выбранный порт
        PORT1="$2"
        
    # Сохраняем общее количество шагов для прогресс
        DOCKER_FULL=${#STOP_LIST[*]}
        
    # Поиск образов из списка $IMAGES
        SEARCH_IMAGES=("${IMAGES[@]}")
        
    # Выполняем список команд
        modelView:Runner 'run_list' "${RUN_LIST[@]}"
    ;;
    
#┌──────────────────────────────────────┐
#│ Удаляет контейнеры из списка $IMAGES │
#└──────────────────────────────────────┘
    'stop')
    # Поиск образов из списка $IMAGES
        SEARCH_IMAGES=("${IMAGES[@]}")
        
    # Сохраняем общее количество шагов для прогресс
        DOCKER_FULL=${#STOP_LIST[*]}
        
    # Выполняем список команд
        modelView:Runner 'run_list' "${STOP_LIST[@]}"
    ;;
    
#┌────────────────────────┐
#│ Удаляет все контейнеры │
#└────────────────────────┘
    'stop_all')
    # Поиск всех образов
        SEARCH_IMAGES=('')
        
    # Сохраняем общее количество шагов для прогресс
        DOCKER_FULL=${#STOP_LIST[*]}
        
    # Выполняем список команд
        modelView:Runner 'run_list' "${STOP_LIST[@]}"
    ;;
    
#┌────────────────────┐
#│ Удаляет все образы │
#└────────────────────┘
    'remove_all')
    # Поиск всех образов
        SEARCH_IMAGES=('')
        
    # Сохраняем общее количество шагов для прогресс
        DOCKER_FULL=${#REMOVE_LIST[*]}
        
    # Выполняем список команд
        modelView:Runner 'run_list' "${REMOVE_LIST[@]}"
    ;;
esac
}
