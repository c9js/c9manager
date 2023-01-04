#▄────────────────────────────▄
#█                            █
#█  Model: Edit               █
#█  • Редактировать (логика)  █
#█                            █
#▀────────────────────────────▀
model:Edit() { case "$1" in
#┌─────────────────────────────────────────┐
#│ Проверяет можно-ли редактировать коммит │
#└─────────────────────────────────────────┘
    'is_edit')
    # Список аргументов
        local commit="$2"  # Выбранный коммит
        local select="$3"  # Выбранный пункт меню
        
    # Сохраняем хэш коммита
        TARGET="${COMMITS_HASH[$commit]}"
        
    # Сохраняем новую дату создания коммита
        NEW_DATE="$(date "+%Y-%m-%d %H:%M")"
        
    # Информация о коммите
        local text="${COMMITS_TEXT[$commit]}" # Текущее описание коммита
        local date="${COMMITS_DATE[$commit]}" # Текущая дата создания коммита
        
    # Коммит нельзя редактировать
        if ! modelView:Runner 'run_list' "${CHECK_LIST[@]}"; then
        # Предлагаем пользователю выбрать коммит
            controller:Menu 'choice' "$PAGE" "0" "$select"
            
    # Коммит можно редактировать
        else
        # Предлагаем пользователю подтвердить редактирование
            case "$SELECTION" in
                1) view:Menu 'confirm_edit' "$commit" "$text" "$select" ;; # Описание коммита
                2) view:Menu 'confirm_date' "$commit" "$date" "$select" ;; # Дата созданя коммита
            esac
        fi
    ;;
    
#┌───────────────────────────────────────┐
#│ Сохраняет один из выбранных вариантов │
#└───────────────────────────────────────┘
    'save')
    # Список аргументов
        local commit="$2"  # Выбранный коммит
        local select="$4"  # Выбранный пункт меню
        
    # Сохраняем новое описание коммита
        NEW_MESSAGE="$3"
        
    # Сохраняем хэш коммита
        TARGET="${COMMITS_HASH[$commit]}"
        
    # Сохраняем один из выбранных вариантов
        case "$SELECTION" in
            1) modelView:Runner 'run_list' "${EDIT_LIST[@]}" ;; # Описание коммита
            2) modelView:Runner 'run_list' "${DATE_LIST[@]}" ;; # Дата созданя коммита
        esac
        
    # Редактирование не было завершено
        if [[ $? != 0 ]]; then
        # Отменяем все изменения
            modelView:Runner 'run_list' "${BACKUP_LIST[@]}"
        fi
        
    # Предлагаем пользователю выбрать коммит
        controller:Menu 'choice' "$PAGE" '0' "$select"
    ;;
esac
}
