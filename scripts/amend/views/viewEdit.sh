#▄───────────────────────────────────────────▄
#█                                           █
#█  Список команд для отмены всех изменений  █
#█                                           █
#▀───────────────────────────────────────────▀
BACKUP_LIST=(
    'void:backup' # Отменяет все изменения
)

#▄──────────────────────────────────────────────────────────────▄
#█                                                              █
#█  Список команд для проверки (можно-ли редактировать коммит)  █
#█                                                              █
#▀──────────────────────────────────────────────────────────────▀
CHECK_LIST=(
    'void:current_branch' # Получает имя текущей ветки
    'is_status'           # Проверяет текущий статус
    'void:since'          # Получает время создания коммита
    'void:refs'           # Получает список всех ссылок (все кроме текущей ветки)
    'void:commits'        # Получает список всех коммитов
    'void:commits_edit'   # Получает список коммитов которые нужно пересоздать
    'is_edit'             # Проверяет можно-ли редактировать коммит
)

#▄─────────────────────────────────────────────────────▄
#█                                                     █
#█  Список команд для редактирования описания коммита  █
#█                                                     █
#▀─────────────────────────────────────────────────────▀
EDIT_LIST=(
    'add:branch_amend'    # Создает временную ветку
    'save:new_message'    # Сохраняет новое описание коммита
    'edit:commits'        # Пересоздает остальные коммиты
    'edit:current_branch' # Восстанавливает текущую ветку
    'remove:branch_amend' # Удаляет временную ветку
)

#▄──────────────────────────────────────────────────────────▄
#█                                                          █
#█  Список команд для редактирования даты создания коммита  █
#█                                                          █
#▀──────────────────────────────────────────────────────────▀
DATE_LIST=(
    'add:branch_amend'    # Создает временную ветку
    'save:new_date'       # Сохраняет новую дату создания коммита
    'edit:commits'        # Пересоздает остальные коммиты
    'edit:current_branch' # Восстанавливает текущую ветку
    'remove:branch_amend' # Удаляет временную ветку
)

#▄──────────────────────────▄
#█                          █
#█  Форируем списки команд  █
#█                          █
#▀──────────────────────────▀
EDIT_LIST=(            # Для редактирования описания коммита
    "${CHECK_LIST[@]}" # Проверка
    "${EDIT_LIST[@]}"  # Редактирование
)
DATE_LIST=(            # Для редактирования даты создания коммита
    "${CHECK_LIST[@]}" # Проверка
    "${DATE_LIST[@]}"  # Редактирование
)

#▄───────────────────────────────▄
#█                               █
#█  View: Edit                   █
#█  • Редактировать (интерфейс)  █
#█                               █
#▀───────────────────────────────▀
view:Edit() { case "$1" in
#┌─────────────────────┐
#│ Обновляет заголовок │
#└─────────────────────┘
    'header') case "$PAGES_MENU" in
        1) printf "Редактирование коммита '%s'" "$NEW_MESSAGE" ;;
        2) printf "Редактирование коммита '%s'" "$NEW_DATE" ;;
    esac
    ;;
    
#┌─────────────────────────────────────┐
#│ Обновляет текущее состояние команды │
#└─────────────────────────────────────┘
    'state') case "$2" in
        'void:current_branch') log 'Получаем имя текущей ветки...'                         ;;
        'is_status')           log 'Проверяем текущий статус...'                           ;;
        'void:since')          log 'Получаем время создания коммита...'                    ;;
        'void:refs')           log 'Получаем список всех ссылок...'                        ;;
        'void:commits')        log 'Получаем список всех коммитов...'                      ;;
        'void:commits_edit')   log 'Получаем список коммитов которые нужно пересоздать...' ;;
        'is_edit')             log 'Проверяем можно-ли редактировать коммит...'            ;;
        'add:branch_amend')    log 'Создаем временную ветку...'                            ;;
        'save:new_message')    log 'Сохраняем новое описание коммита...'                   ;;
        'save:new_date')       log 'Сохраняем новую дату создания коммита...'              ;;
        'edit:commits')        log 'Пересоздаем остальные коммиты...'                      ;;
        'edit:current_branch') log 'Восстанавливаем текущую ветку...'                      ;;
        'remove:branch_amend') log 'Удаляем временную ветку...'                            ;;
        'void:backup')         log 'Отменяем все изменения...'                             ;;
    esac
    ;;
    
#┌─────────────────────────────┐
#│ Выводит сообщение об ошибке │
#└─────────────────────────────┘
    'error') case "$2" in
        'void:current_branch') error 'Вы не находитесь на ветке!'                     ;;
        'is_status')           error "Ваш 'git status' должен быть пуст!"             ;;
        'void:since')          error 'Время создания коммита не было получено!'       ;;
        'void:refs')           error 'Список ссылок не был получен!'                  ;;
        'void:commits')        error 'Список коммитов не был получен!'                ;;
        'void:commits_edit')   error 'Список коммитов не был получен!'                ;;
        'is_edit')             error 'На коммит есть ссылки из других веток!'         ;;
        'add:branch_amend')    error 'Временная ветка не была создана!'               ;;
        'save:new_message')    error 'Новое описание коммита не было сохранено!'      ;;
        'save:new_date')       error 'Новая дата создания коммита не была сохранена!' ;;
        'edit:commits')        error 'Остальные коммиты не были пересозданы!'         ;;
        'edit:current_branch') error 'Текущая ветка не была восстановлена!'           ;;
        'remove:branch_amend') error 'Временная ветка не была удалена!'               ;;
    esac
    ;;
    
#┌──────────────────────────────────────────┐
#│ Выводит сообщение об успешном завершении │
#└──────────────────────────────────────────┘
    'success') case "$PAGES_MENU" in
        1) success 'Описание успешно отредактировано!' ;;
        2) success 'Дата успешно изменена!'            ;;
    esac
    ;;
esac
}
