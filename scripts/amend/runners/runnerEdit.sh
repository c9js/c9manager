#▄─────────────────────▄
#█                     █
#█  Список переменных  █
#█                     █
#▀─────────────────────▀
declare -a REFS_ALL     # Список всех ссылок (кроме текущей ветки)
declare -A COMMITS_ALL  # Список всех коммитов
declare -a COMMITS_EDIT # Список коммитов которые нужно пересоздать

#▄───────────────────────────────────▄
#█                                   █
#█  Runner: Edit                     █
#█  • Редактировать (запуск команд)  █
#█                                   █
#▀───────────────────────────────────▀
runner:Edit() { case "$1" in
#┌────────────────────────────┐
#│ Получает имя текущей ветки │
#└────────────────────────────┘
    'void:current_branch')
    # Сохраняем хэш текущего коммита
        CURRENT_COMMIT="$(git rev-parse HEAD 2> '/dev/null')"
        
    # Сохраняем имя текущей ветки
        CURRENT_BRANCH="$(git branch --show-current 2> '/dev/null')"
        
    # Сохраняем имя ветки для редактирования
        BRANCH_AMEND="${CURRENT_BRANCH}_${RANDOM}"
        
    # Проверяем текущую ветку
        [ -n "$CURRENT_BRANCH" ]
    ;;
    
#┌──────────────────────────┐
#│ Проверяет текущий статус │
#└──────────────────────────┘
    'is_status')
        [ -z "$(git status --porcelain)" ]
    ;;
    
#┌─────────────────────────────────┐
#│ Получает время создания коммита │
#└─────────────────────────────────┘
    'void:since')
    # Получаем время
        RUN git log -1 --pretty='%at' "$TARGET" && return 1
        
    # Сохраняем время
        SINCE="$RES"
    ;;
    
#┌───────────────────────────────────────────────────────┐
#│ Получает список всех ссылок (все кроме текущей ветки) │
#└───────────────────────────────────────────────────────┘
    'void:refs')
    # Обнуляем список ссылок
        REFS_ALL=()
        
    # Получаем список ссылок
        RUN git for-each-ref --format='%(objectname) %(HEAD)' && return 1
        
    # Информация о ссылке
        local ref
        
    # Проходим по списку ссылок
        while read -ra ref; do
        # Проверяем является-ли ссылка текущей веткой
            if [[ "${ref[1]}" != '*' ]]; then
            # Сохраняем ссылку в список ссылок (кроме ветки на которой мы сейчас находимся)
                REFS_ALL+=("${ref[0]}")
            fi
        done <<< "$RES"
    ;;
    
#┌───────────────────────────────┐
#│ Получает список всех коммитов │
#└───────────────────────────────┘
    'void:commits')
    # Обнуляем список всех коммитов
        COMMITS_ALL=()
        
    # Получаем список всех коммитов
        RUN git log --since="$SINCE" --pretty='%H:%P' --reverse --all && return 1
        
    # Информация о коммите
        local commit
        
    # Проходим по списку коммитов
        while IFS=':' read -ra commit; do
        # Обновляем информацию о коммите
            COMMITS_ALL["${commit[0]}"]="${commit[1]}"
        done <<< "$RES"
    ;;
    
#┌────────────────────────────────────────────────────┐
#│ Получает список коммитов которые нужно пересоздать │
#└────────────────────────────────────────────────────┘
    'void:commits_edit')
    # Обнуляем список коммитов
        COMMITS_EDIT=()
        
    # Локальные переменные
        local current # Текущий коммит
        local is_edit # Позиция после которой коммиты можно добавлять в массив
        
    # Получаем список коммитов
        RUN git log --since="$SINCE" --pretty='%H' --reverse && return 1
        
    # Проходим по списку коммитов
        while read -r current; do
        # Доходим до коммита который мы редактируем
            if [[ "$TARGET" == "$current" ]]; then
            # Помечаем, что все что после теперь можно добавлять в список коммитов
                is_edit=1
            fi
            
        # Позиция пройдена теперь можно добавлять все следующие коммиты в список коммитов
            if [ -n "$is_edit" ]; then
            # Добавляем коммит в список коммитов
                COMMITS_EDIT+=("$current")
            fi
        done <<< "$RES"
    ;;
    
#┌─────────────────────────────────────────┐
#│ Проверяет можно-ли редактировать коммит │
#└─────────────────────────────────────────┘
    'is_edit')
        controller:Check 'is_edit'
    ;;
    
#┌─────────────────────────┐
#│ Создает временную ветку │
#└─────────────────────────┘
    'add:branch_amend')
        git checkout -qB "$BRANCH_AMEND" "$TARGET"
    ;;
    
#┌──────────────────────────────────┐
#│ Сохраняет новое описание коммита │
#└──────────────────────────────────┘
    'save:new_message')
        git commit --amend -m "$NEW_MESSAGE"
    ;;
    
#┌───────────────────────────────────────┐
#│ Сохраняет новую дату создания коммита │
#└───────────────────────────────────────┘
    'save:new_date')
        git commit --amend --no-edit --date="$NEW_DATE"
    ;;
    
#┌───────────────────────────────┐
#│ Пересоздает остальные коммиты │
#└───────────────────────────────┘
    'edit:commits')
    # Локальные переменные
        local current # Текущий коммит
        local is_edit # Позиция после которой можно пересоздавать коммиты
        
    # Проходим по списку коммитов которые нужно пересоздать
        for current in "${COMMITS_EDIT[@]}"; do
        # Пересоздаем коммит
            if [ -n "$is_edit" ]; then
            # Получаем изменения из коммита $current 
                git cherry-pick -n "$current" || return
                
            # Сохраняем один из выбранных вариантов
                case "$PAGES_MENU" in
                    1) git commit -qC "$current"                    || return ;; # Описание из коммита
                    2) git commit -qC "$current" --date="$NEW_DATE" || return ;; # Дата созданя
                esac
            fi
            
        # Доходим до коммита который мы редактируем
            if [[ "$TARGET" == "$current" ]]; then
            # Помечаем, что все что после теперь можно пересоздавать
                is_edit=1
            fi
        done
    ;;
    
#┌───────────────────────────────┐
#│ Восстанавливает текущую ветку │
#└───────────────────────────────┘
    'edit:current_branch')
        git checkout -qB "$CURRENT_BRANCH"
    ;;
    
#┌─────────────────────────┐
#│ Удаляет временную ветку │
#└─────────────────────────┘
    'remove:branch_amend')
        git branch -qD "$BRANCH_AMEND"
    ;;
    
#┌────────────────────────┐
#│ Отменяет все изменения │
#└────────────────────────┘
    'void:backup')
        git checkout -B "$CURRENT_BRANCH" "$CURRENT_COMMIT" &> '/dev/null'
        git branch -D "$BRANCH_AMEND" &> '/dev/null'
        # Обязательно return 1, так как это все равно ошибка.
        # Кроме того мы не знаем какая часть скрипта уже выполнена, а какая еще нет.
        # По этому просто вернем все как было.
        return 1
    ;;
esac
}
