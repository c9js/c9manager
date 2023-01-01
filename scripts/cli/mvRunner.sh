#▄────────────────────────────────────────────▄1.0.0
#█                                            █
#█  ModelView: Runner                         █
#█  • Запуск команд (управление интерфейсом)  █
#█                                            █
#▀────────────────────────────────────────────▀
modelView:Runner() { case "$1" in
#┌─────────────────────────┐
#│ Выполняет список команд │
#└─────────────────────────┘
    'run_list')
    # Локальные переменные
        local parent="${FUNCNAME[1]#*:}" # Имя функции родителя
        local i
        
    # Проходим по списку команд
        for ((i = 2; i <= $#; i++)); do
        # Выполняем команду
            if modelView:Runner 'run' "$parent" "${!i}" "$(($i-1))" "$(($#-1))"; then
            # Команда не была выполнена
                return 1
            fi
        done
        
    # Выводим сообщение об успешном завершении
        "view:$parent" 'success'
        
    # Все команды успешно выполнены
        return 0
    ;;
    
#┌───────────────────┐
#│ Выполняет команду │
#└───────────────────┘
    'run')
    # Список аргументов
        local parent="$2"  # Имя функции родителя
        local command="$3" # Текущая команда
        local now="$4"     # Текущий шаг
        local full="$5"    # Количество шагов
        
    # Создаем потоковый стрим
        local stream='stream'
        
    # Если в имени команды присутствует "void:command_name"
    # Это говорит о том, что в данной ситуации потоковый стрим не нужен
    # Так же это говорит о том, что в команде будут переопределены глобальные переменные
        if [[ "${command/:*}" == 'void' && "${command/:*}" != "$command" ]]; then
            stream='stream:Void'
        fi
        
    # Обновляем текущий статус
        modelView:Runner 'status' "$parent" "$command" "$now" "$full"
        
    # Выполняем команду
        if "$stream" "runner:$parent" "$command"; then
        # Выводим сообщение об ошибке
            "view:$parent" 'error' "$command"
            
        # Команда не была выполнена
            return 0
        fi
        
    # Команда успешно выполнена
        return 1
    ;;
    
#┌──────────────────────────┐
#│ Обновляет текущий статус │
#└──────────────────────────┘
    'status')
    # Список аргументов
        local parent="$2"  # Имя функции родителя
        local command="$3" # Текущая команда
        local now="$4"     # Текущий шаг
        local full="$5"    # Количество шагов
        
    # Очищаем экран
        reset
        
    # Обновляем заголовок
        "view:$parent" 'header'
        
    # Переносим строку
        printf '\n'
        
    # Обновляем шаг
        printf '[%d/%d] ' "$now" "$full"
        
    # Обновляем текущее состояние команды
        "view:$parent" 'state' "$command"
        
    # Переносим строку
        printf '\n'
        
    # Режим разаработки
        if [[ "$DEV_MODE" == 1 ]]; then
            read
        fi
    ;;
esac
}
