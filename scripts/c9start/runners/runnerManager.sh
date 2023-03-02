#▄─────────────────────────────────────▄
#█                                     █
#█  Runner: Manager                    █
#█  • Запуск проектов (запуск команд)  █
#█                                     █
#▀─────────────────────────────────────▀
runner:Manager() { case "$1" in
#┌───────────────────────────────────────────────┐
#│ Создание общего каталог для хранения проектов │
#└───────────────────────────────────────────────┘
    'add_dir')
    # Каталог не найден
        if ! is_dir "${PATH_WORKSPACE}${PATH_PROJECTS}"; then
        # Создаем каталог
            mkdir -p "${PATH_WORKSPACE}${PATH_PROJECTS}" || return 1
        fi
    ;;
    
#┌──────────────────────────────┐
#│ Проверка количества проектов │
#└──────────────────────────────┘
    'is_count')
        [ "$(dir_count "${PATH_WORKSPACE}${PATH_PROJECTS}")" != 0 ]
    ;;
    
#┌───────────────────────────┐
#│ Получение списка проектов │
#└───────────────────────────┘
    'void:get_projects')
    # Глобальные переменные
        PROJECTS_STATUS=() # Список статусов
        PROJECTS_INDEX=()  # Список порядковых номеров
        PROJECTS_NAME=()   # Список имен проектов
        PROJECTS_URL=()    # Список URL-адресов
        
    # Получаем список проектов
        RUN dir_list "${PATH_WORKSPACE}${PATH_PROJECTS}" && return 1
        
    # Переводим список проектов в массив
        readarray -t PROJECTS <<< "$RES"
    ;;
    
#┌─────────────────────┐
#│ Сортировка проектов │
#└─────────────────────┘
    'void:sort_projects')
    # Локальные переменные
        local sort=() # Отсортированный список
        local name    # Имя проекта
        
    # Отсортированный список не найден
        if ! is_file "$PATH_PROJECTS_SORT"; then
        # Создаем отсортированный список
            RUN save_file "$PATH_PROJECTS_SORT" "${PROJECTS[@]}" && return 1
            
        # Команда успешно выполнена
            return 0
        fi
        
    # Получаем отсортированный список
        RUN get_file "$PATH_PROJECTS_SORT" && return 1
        
    # Отсортированный список пуст
        if [ -z "$RES" ]; then
        # Создаем новый отсортированный список
            RUN save_file "$PATH_PROJECTS_SORT" "${PROJECTS[@]}" && return 1
            
        # Команда успешно выполнена
            return 0
        fi
        
    # Переводим отсортированный список в массив
        readarray -t sort <<< "$RES"
        
    # Локальные переменные
        local -A search_sort # Отсортированный список (для поиска)
        local -A search_list # Список проектов (для поиска)
        
    # Добавляем проект в отсортированный список (для поиска)
        for name in "${sort[@]}"; do
            search_sort[$name]=1
        done
        
    # Добавляем проект в список проектов (для поиска)
        for name in "${PROJECTS[@]}"; do
            search_list[$name]=1
        done
        
    # Локальные переменные
        local new=() # Список новых проектов
        local old=() # Список старых проектов
        
    # Добавляем проект в список новых проектов
        for name in "${PROJECTS[@]}"; do
            [ -z "${search_sort[$name]}" ] && new+=("$name")
        done
        
    # Добавляем проект в список старых проектов
        for name in "${sort[@]}"; do
            [ -n "${search_list[$name]}" ] && old+=("$name")
        done
        
    # Сохраняем отсортированный список
        sort=(
            "${new[@]}" # Список новых проектов
            "${old[@]}" # Список старых проектов
        )
        
    # Проверяем отсортированный список
        if [ "${PROJECTS[*]}" != "${sort[*]}" ]; then
        # Сохраняем отсортированный список
            RUN save_file "$PATH_PROJECTS_SORT" "${sort[@]}" && return 1
            
        # Обновляем список проектов
            PROJECTS=("${sort[@]}")
        fi
    ;;
    
#┌────────────────────────────┐
#│ Изменение позиции в списке │
#└────────────────────────────┘
    'void:set_position')
    # Локальные переменные
        local j=0 # Новая позиция
        local i   # Текущая позиция
        
    # Проходим по списку позиций
        for i in "${!PROJECTS[@]}"; do
        # Позиция найдена
            if [ "${PROJECTS[$i]}" == "$PROJECT_NAME" ]; then
            # Проверяем текущую позицию
                (( $PAGES_MENU == 1 && $i == 0 )) && return
                (( $PAGES_MENU == 2 && $i == ${#PROJECTS[*]}-1 )) && return
                
            # Создаем новую позицию
                case "$PAGES_MENU" in
                    1) let j=$i-1 ;; # Вверх
                    2) let j=$i+1 ;; # Вниз
                esac
                
            # Обновляем номер страницы
                let PAGES_PAGE=$j/$PROJECTS_MAX
                
            # Сохраняем новую позицию в список
                PROJECTS[$i]="${PROJECTS[$j]}"
                PROJECTS[$j]="$PROJECT_NAME"
                
            # Сохраняем отсортированный список
                RUN save_file "$PATH_PROJECTS_SORT" "${PROJECTS[@]}" && return 1
                
            # Команда успешно выполнена
                return 0
            fi
        done
    ;;
    
#┌──────────────────────────┐
#│ Получение списка позиций │
#└──────────────────────────┘
    'void:get_positions')
    # Порядковый номер
        local i
        
    # Проходим по списку проектов
        for i in "${!PROJECTS[@]}"; do
        # Добавляем информацию о проекте в список
            PROJECTS_NAME+=("${PROJECTS[$i]}") # Имя проекта
            PROJECTS_INDEX+=($i)               # Порядковый номер
        done
    ;;
    
#┌───────────────────────────┐
#│ Получение списка статусов │
#└───────────────────────────┘
    'void:get_status')
    # Локальные переменные
        local status=() # Список статусов
        local index=()  # Список порядковых номеров
        local names=()  # Список имен проектов
        local urls=()   # Список URL-адресов
        local port      # Внешний порт
        local i         # Порядковый номер
        
    # Проходим по списку проектов
        for i in "${!PROJECTS[@]}"; do
        # Добавляем порядковый номер в список
            PROJECTS_INDEX+=($i)
            
        # Получаем внешний порт
            port="$(docker:getPort "${PROJECTS[$i]}" "$PORT_BASIC")"
            
        # Добавляем онлайн проекты в начало списка
            if [ -n "$port" ]; then
                PROJECTS_STATUS+=('online')                # Текущий статус
                PROJECTS_NAME+=("${PROJECTS[$i]}")         # Имя проекта
                PROJECTS_URL+=("http://localhost:$port") # URL-адрес
                continue
            fi
            
        # Сохраняем оффлайн проекты
            status+=('offline')        # Текущий статус
            names+=("${PROJECTS[$i]}") # Имя проекта
            urls+=('')                 # URL-адрес
        done
        
    # Добавляем оффлайн проекты в конец списка
        PROJECTS_STATUS+=("${status[@]}") # Список статусов
        PROJECTS_NAME+=("${names[@]}")    # Список имен проектов
        PROJECTS_URL+=("${urls[@]}")      # Список URL-адресов
    ;;
    
#┌───────────────────────────┐
#│ Изменение номера страницы │
#└───────────────────────────┘
    'void:set_page')
    # Обнуляем номер страницы
        PAGES_PAGE=0
        
    # Проект не выбран
        [ -z "$PROJECT_NAME" ] && return 0
        
   # Порядковый номер
        local i
        
    # Проходим по списку порядковых номеров
        for i in "${PROJECTS_INDEX[@]}"; do
        # Проект найден
            if [ "${PROJECTS_NAME[$i]}" == "$PROJECT_NAME" ]; then
            # Изменяем номер страницы
                let PAGES_PAGE=$i/$PROJECTS_MAX
                
            # Команда успешно выполнена
                return 0
            fi
        done
    ;;
    
#┌──────────────────────────┐
#│ Проверка текущего образа │
#└──────────────────────────┘
    'void:is_image')
    # Обнуляем номер страницы
        PAGES_PAGE=0
        
   # Порядковый номер
        local i
        
    # Проходим по списку образов
        for i in "${!IMAGES_MANAGER[@]}"; do
        # Образ найден
            if [ "${IMAGES_MANAGER[$i]}" == "$PROJECT_IMAGE" ]; then
            # Изменяем номер страницы
                let PAGES_PAGE=$i/$IMAGES_MAX
                
            # Команда успешно выполнена
                return 0
            fi
        done
        
    # Образ не найден
        return 1
    ;;
esac
}
