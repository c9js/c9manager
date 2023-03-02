#▄──────────────────────────────────────▄
#█                                      █
#█  Runner: Project                     █
#█  • Выбранный проект (запуск команд)  █
#█                                      █
#▀──────────────────────────────────────▀
runner:Project() { case "$1" in
#┌────────────────────────────────────┐
#│ Получение пути к текущему каталогу │
#└────────────────────────────────────┘
    'void:get_path')
        PATH_PROJECT="/$PROJECT_NAME"
    ;;
    
#┌──────────────────────────────────┐
#│ Получение пути к новому каталогу │
#└──────────────────────────────────┘
    'void:get_path_new')
        PATH_PROJECT_NEW="/$PROJECT_NAME_NEW"
    ;;
    
#┌─────────────────────────┐
#│ Проверка текущего имени │
#└─────────────────────────┘
    'is_name')
        [ -n "$PROJECT_NAME" ]
    ;;
    
#┌───────────────────────┐
#│ Проверка нового имени │
#└───────────────────────┘
    'is_name_new')
        [ -n "$PROJECT_NAME_NEW" ]
    ;;
    
#┌────────────────────────────┐
#│ Проверка текущего каталога │
#└────────────────────────────┘
    'is_dir')
        is_dir "${PATH_WORKSPACE}${PATH_PROJECTS}${PATH_PROJECT}"
    ;;
    
#┌──────────────────────────┐
#│ Проверка нового каталога │
#└──────────────────────────┘
    'is_dir_new')
        ! is_exists "${PATH_WORKSPACE}${PATH_PROJECTS}${PATH_PROJECT_NEW}"
    ;;
    
#┌───────────────────────────┐
#│ Получение текущего образа │
#└───────────────────────────┘
    'void:get_image')
    # Получаем текущий образ
        RUN get_file "${PATH_WORKSPACE}${PATH_PROJECTS}${PATH_PROJECT}${PATH_IMAGE}" && return 1
        
    # Обновляем информацию о проекте
        PROJECT_VERSION="${RES##*:}" # Версия образа
        PROJECT_IMAGE="${RES%%:*}"   # Имя образа
    ;;
    
#┌─────────────────────────┐
#│ Получение списка портов │
#└─────────────────────────┘
    'void:get_ports')
    # Получаем количество дополнительных портов
        RUN get_file "${PATH_WORKSPACE}${PATH_PROJECTS}${PATH_PROJECT}${PATH_PORTS_COUNT}" && return 1
        
    # Сохраняем количество дополнительных портов
        PROJECT_PORTS_COUNT="$RES"
    ;;
    
#┌────────────────────────────┐
#│ Получение текущего статуса │
#└────────────────────────────┘
    'void:get_status')
    # Обнуляем текущий статус
        PROJECT_STATUS='offline'
        
    # Получаем внешний порт
        local port="$(docker:getPort "$PROJECT_NAME" "$PORT_BASIC")"
        
    # Обновляем текущий статус
        [ -n "$port" ] && PROJECT_STATUS='online'
        
    # Команда успешно выполнена
        return 0
    ;;
    
#┌──────────────────┐
#│ Проверка статуса │
#└──────────────────┘
    'is_status')
        [ "$PROJECT_STATUS" == 'offline' ]
    ;;
    
#┌──────────────────────────────────────────┐
#│ Переименование каталога текущего проекта │
#└──────────────────────────────────────────┘
    'set_name')
        rename_dir \
        "${PATH_WORKSPACE}${PATH_PROJECTS}${PATH_PROJECT}" \
        "${PATH_WORKSPACE}${PATH_PROJECTS}${PATH_PROJECT_NEW}"
    ;;
    
#┌───────────────────────────────────┐
#│ Изменение отсортированного списка │
#└───────────────────────────────────┘
    'set_sort')
    # Отсортированный список не найден
        ! is_file "$PATH_PROJECTS_SORT" && return 0
        
    # Получаем отсортированный список
        local res="$(get_file "$PATH_PROJECTS_SORT")"
        
    # Отсортированный список пуст
        [ -z "$res" ] && return 0
        
    # Переводим список проектов в массив
        readarray -t res <<< "$res"
        
    # Локальные переменные
        local i
        
    # Проходим по списку проектов
        for i in "${!res[@]}"; do
        # Проект найден
            if [ "${res[$i]}" == "$PROJECT_NAME" ]; then
            # Обновляем имя в списке
                res[$i]="$PROJECT_NAME_NEW"
                
            # Сохраняем отсортированный список
                save_file "$PATH_PROJECTS_SORT" "${res[@]}"
                
            # Команда успешно выполнена
                return 0
            fi
        done
    ;;
    
#┌────────────────────────────────────────────┐
#│ Изменение количества дополнительных портов │
#└────────────────────────────────────────────┘
    'set_ports')
        save_file \
        "${PATH_WORKSPACE}${PATH_PROJECTS}${PATH_PROJECT}${PATH_PORTS_COUNT}" \
        "$PROJECT_PORTS_COUNT_NEW"
    ;;
    
#┌────────────────────────┐
#│ Проверка нового образа │
#└────────────────────────┘
    'is_image_new')
   # Порядковый номер
        local i
        
    # Проходим по списку образов
        for i in "${!IMAGES_MANAGER[@]}"; do
        # Образ найден
            [ "${IMAGES_MANAGER[$i]}" == "$PROJECT_IMAGE_NEW" ] && return 0
        done
        
    # Образ не найден
        return 1
    ;;
    
#┌───────────────────────────┐
#│ Изменение текущего образа │
#└───────────────────────────┘
    'set_image')
        save_file \
        "${PATH_WORKSPACE}${PATH_PROJECTS}${PATH_PROJECT}${PATH_IMAGE}" \
        "$PROJECT_IMAGE_NEW:$PROJECT_VERSION"
    ;;
esac
}
