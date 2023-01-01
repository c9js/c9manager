#▄───────────────────▄
#█                   █
#█  Model: Menu      █
#█  • Меню (логика)  █
#█                   █
#▀───────────────────▀
model:Menu() { case "$1" in
#┌──────────────────────┐
#│ Создает кнопку назад │
#└──────────────────────┘
    'back')
    # Это не первая страница
        if (( $PAGE != 0 )); then
        # Добавляем кнопку назад
            MENU_ITEMS+=('←')
        fi
    ;;
    
#┌───────────────────────┐
#│ Создает кнопку вперед │
#└───────────────────────┘
    'next')
    # Это не последняя страница
        if [ -n "$PARENT_HASH" ]; then
        # Добавляем кнопку вперед
            MENU_ITEMS+=('→')
        fi
    ;;
    
#┌─────────────────────────┐
#│ Создает список коммитов │
#└─────────────────────────┘
    'commits_list')
    # Локальные переменные
        local i
        
    # Проходим по списку коммитов
        for i in "${!COMMITS_HASH[@]}"; do
        # Получаем информацию о коммите
            local hash="${COMMITS_HASH[$i]:0:6}" # Хэш
            local text="${COMMITS_TEXT[$i]}"     # Описание
            local date="${COMMITS_DATE[$i]}"     # Дата создания
            
        # Добавляем пункт с информацией о коммите
            # MENU_ITEMS+=("$hash $date $text")
            MENU_ITEMS+=("$hash $text")
        done
    ;;

#┌────────────────────────────────────────┐
#│ Предлагает пользователю выбрать коммит │
#└────────────────────────────────────────┘
    'choice')
    # Список аргументов
        local page="$2"        # Номер страницы
        local select="$3"      # Пункт меню (по умолчанию)
        local last_select="$4" # Пункт меню (выбранный ранее)
        
    # Загружаем список коммитов
        controller:Load 'load' "$2"
        
    # Обнуляем сохраненные состояния пунктов меню
        reset:Menu
        
    # Обнуляем список пунктов меню
        MENU_ITEMS=()
        
    # Создаем выбранный пункт по умолчанию
        local defaultSelection="$(number "$3")"
        
    # Пункт по умолчанию не указан
        if (( $defaultSelection == 0 && $PAGE != 0 )); then
        # Следующей страницы не существует
            if [ -z "$PARENT_HASH" ]; then
            # Обновляем пункт по умолчанию
                defaultSelection=1
                
        # Следующая страница существует
            else
            # Обновляем пункт по умолчанию
                let defaultSelection=${#COMMITS_HASH[*]}+2
            fi
        fi
        
    # Следующая страница существует
        if [ -n "$PARENT_HASH" ] && (( $PAGE == 0 )); then
        # Обновляем пункт по умолчанию
            let defaultSelection=${#COMMITS_HASH[*]}+1
        fi
        
    # Проверяем пункт меню (выбранный ранее)
        if [ -n "$last_select" ]; then
            defaultSelection="$last_select"
        fi
        
    # Создаем кнопку назад
        model:Menu 'back'
        
    # Создаем список коммитов
        model:Menu 'commits_list'
        
    # Создаем кнопку вперед
        model:Menu 'next'
        
    # Выводим меню на экран
        view:Menu 'choice' "$defaultSelection"
    ;;
    
#┌──────────────────────────────┐
#│ Обрабатывает выбранный пункт │
#└──────────────────────────────┘
    'select')
    # Список аргументов
        local select="$2" # Выбранный пункт
        
    # Создаем ID пункта вперед
        local nextID=${#COMMITS_HASH[*]}
        
    # Это не первая страница
        if (( $PAGE != 0 )); then
        # Выбран пункт "Назад"
            if (( $select == 1 )); then
            # Переходим на предыдущюю страницу
                controller:Menu 'choice' "$(($PAGE-1))" 1
                return
            fi
            
        # Увеличиваем ID пункта вперед
            let nextID++
        fi
        
    # Выбран пункт "Вперед"
        if (( $select == $nextID+1 )) && [ -n "$PARENT_HASH" ]; then
        # Переходим на следующюю страницу
            controller:Menu 'choice' "$(($PAGE+1))"
            return
        fi
        
    # Это первая страница
        if [[ "$PAGE" == 0 ]]; then
        # Проверяем можно-ли редактировать коммит
            controller:Edit 'is_edit' "$(($select-1))" "${COMMITS_TEXT[$select-1]}" "$select"
            
    # Это не первая страница
        else
        # Проверяем можно-ли редактировать коммит
            controller:Edit 'is_edit' "$(($select-2))" "${COMMITS_TEXT[$select-2]}" "$select"
        fi
    ;;
esac
}
