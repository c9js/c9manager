#▄──────────────────────────────────────────▄1.0.1
#█                                          █
#█  ModelView: Notice                       █
#█  • Уведомление (управление интерфейсом)  █
#█                                          █
#▀──────────────────────────────────────────▀
modelView:Notice() { case "$1" in
#┌──────────────────────────────┐
#│ Проверяет список уведомлений │
#└──────────────────────────────┘
    'fatal_error') modelView:Notice 'run' "$1" "$2" "${FATAL_LIST[@]}"   ;; # Список фатальных ошибок
    'error')       modelView:Notice 'run' "$1" "$2" "${ERROR_LIST[@]}"   ;; # Список ошибок
    'warning')     modelView:Notice 'run' "$1" "$2" "${WARNING_LIST[@]}" ;; # Список предупреждений
    'info')        modelView:Notice 'run' "$1" "$2" "${INFO_LIST[@]}"    ;; # Список информационных сообщений
    
#┌───────────────────────────────────┐
#│ Проверяет список всех уведомлений │
#└───────────────────────────────────┘
    'check')
    # Проверяем списки уведомлений
        modelView:Notice 'run' 'fatal_error' "$2" "${FATAL_LIST[@]}"   && return 0 # Фатальные ошибки
        modelView:Notice 'run' 'error'       "$2" "${ERROR_LIST[@]}"   && return 0 # Ошибки
        modelView:Notice 'run' 'warning'     "$2" "${WARNING_LIST[@]}" && return 0 # Предупреждения
        modelView:Notice 'run' 'info'        "$2" "${INFO_LIST[@]}"    && return 0 # Информационные сообщения
        
    # Уведомления не найдены
        return 1
    ;;
    
#┌─────────────────────────┐
#│ Выполняет список команд │
#└─────────────────────────┘
    'run')
    # Список аргументов
        local notice="$2"  # Тип уведомления
        local command="$3" # Текущая команда
        
    # Локальные переменные
        local i
        
    # Проходим по списку команд
        for ((i = 4; i <= $#; i++)); do
        # Проверяем текущую команду
            if [[ "$command" == '' || "$command" == "${!i}" ]]; then
            # Выполняем команду
                if runner:Notice "${!i}"; then
                # Сохраняем информацию об уведомлении
                    NOTICE_COMMAND="${!i}"
                    
                # Выводим уведомление на экран
                    view:Notice "$notice" "${!i}"
                    
                # Уведомление найдено
                    return 0
                fi
            fi
        done
        
    # Уведомления не найдены
        return 1
    ;;
esac
}
