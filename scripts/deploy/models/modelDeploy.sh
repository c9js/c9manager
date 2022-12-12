#▄─────────────────────▄
#█                     █
#█  Model: Deploy      █
#█  • Деплой (логика)  █
#█                     █
#▀─────────────────────▀
model:Deploy() { case "$1" in
#┌───────────────────────┐
#│ Деплой прошел успешно │
#└───────────────────────┘
    'success')
    # Удаляем информацию о последнем деплое
        remove_file "$PATH_BAD_DEPLOY"
        
    # Обнуляем последний вариант деплоя
        LAST_SELECTION=''
        
    # Обнуляем последнюю контройльную точку
        NO_STOP=''
        
    # Выводим сообщение об успешном завершении
        view:Deploy 'success'
    ;;
    
#┌────────────────────────┐
#│ Деплой не был завершен │
#└────────────────────────┘
    'error')
    # Последняя команда
        local last_command="$2"
        
    # Сохраняем информацию о последнем деплое
        if [ -n "$SELECTION" ]; then
        # Обновляем информацию
            LAST_COMMAND="$last_command" # Последняя команда
            LAST_SELECTION="$SELECTION"  # Последний вариант деплоя
            SELECTION=''                 # Обнуляем выбранный вариант деплоя
            
        # Сохраняем информацию в файл
            save_file "$PATH_BAD_DEPLOY" "$NEW_VERSION $LAST_COMMAND $LAST_SELECTION $NO_STOP"
        fi
        
    # Возвращаем старую версию
        save_file "$PATH_VERSION" "$VERSION"
        
    # Выводим сообщение об ошибке
        view:Deploy 'error' "$last_command"
        
    # Добавляем задержку для визуального восприятия
        sleep 0.5
    ;;
    
#┌──────────────────────┐
#│ Останавливает деплой │
#└──────────────────────┘
    'stop')
    # Контройльная точка уже пройдена
        if [ -n "$NO_STOP" ]; then
        # Выводим сообщение об ошибке
            view:Deploy 'error' "$NO_STOP"
            
    # Контройльная точка еще не была пройдена
        else
        # Выводим сообщение об успешном завершении
            model:Deploy 'success'
        fi
    ;;
    
#┌───────────────────────────────────┐
#│ Пробует еще раз продолжить деплой │
#└───────────────────────────────────┘
    'continue')
    # Выполняем список команд
        model:Deploy 'run_list' "${GENERAL_LIST[@]}"
        
    # Проверка прошла успешно
        if [[ $? == 0 ]]; then
        # Пробуем еще раз продолжить деплой
            model:Deploy 'start' "$LAST_SELECTION" "$NEW_VERSION"
        fi
    ;;
    
#┌───────────────────────────────────┐
#│ Начинает один из вариантов деплоя │
#└───────────────────────────────────┘
    'start')
    # Сохраняем выбранный вариант деплоя
        SELECTION="$2"
        
    # Сохраняем новую версию
        NEW_VERSION="$3"
        
    # Деплоит один из выбранных вариантов
        case "$SELECTION" in
            1) model:Deploy 'run_list' "${ALL_LIST[@]}"    ;; # Сразу в оба репозитория
            2) model:Deploy 'run_list' "${GIT_LIST[@]}"    ;; # Только в git-репозиторий
            3) model:Deploy 'run_list' "${DOCKER_LIST[@]}" ;; # Только в docker-репозиторий
        esac
        
    # Деплой прошел успешно
        if [[ $? == 0 ]]; then
             model:Deploy 'success'
        fi
    ;;
    
#┌─────────────────────────┐
#│ Выполняет список команд │
#└─────────────────────────┘
    'run_list')
    # Локальные переменные
        local i
        
    # Проходим по списку команд
        for ((i = 2; i <= $#; i++)); do
        # Выполняем команду
            if model:Deploy 'run' "${!i}" "$(($i-1))"; then
            # Команда не была выполнена
                return 1
            fi
        done
        
    # Команда успешно выполнена
        return 0
    ;;
    
#┌───────────────────┐
#│ Выполняет команду │
#└───────────────────┘
    'run')
    # Список аргументов
        local command="$2" # Текущая команда
        local now="$3"     # Текущий шаг
        
    # Проверяем текущую команду
        if [[ "$command" == "$LAST_COMMAND" ]]; then
        # Обнуляем последнюю команду и выполняем текущую команду
            LAST_COMMAND=''
            
    # Проверяем последнюю команду
        elif [[ "$SELECTION" != '' && "$LAST_COMMAND" != '' ]]; then
        # Пропускаем текущую команду
            return 1
        fi
        
    # Сохраняем контройльную точку
        if [[ "$command" == 'no_stop' ]]; then
            NO_STOP="$command"
        fi
        
    # Обновляем текущий статус
        model:Deploy 'status' "$command" "$now"
        
    # Выполняем команду
        if controller:Run "$command"; then
        # Деплой не был завершен
            model:Deploy 'error' "$command"
            
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
        local command="$2" # Текущая команда
        local now="$3"     # Текущий шаг
        local full         # Количество шагов
        
    # Очищаем экран
        reset
        
    # Обновляем заголовок
        view:Deploy 'header'
        
    # Количество шагов
        local git_full=${#GIT_LIST[*]}
        local docker_full=${#DOCKER_LIST[*]}
        local general_full=${#GENERAL_LIST[*]}
        
    # Обновляем общее количество шагов
        case "$SELECTION" in
            1) let full=$git_full+$docker_full ;; # Сразу в оба репозитория
            2) let full=$git_full              ;; # Только в git-репозиторий
            3) let full=$docker_full           ;; # Только в docker-репозиторий
            *) let full=$general_full          ;; # Пробуем еще раз
        esac
        
    # Переносим строку
        printf '\n'
        
    # Обновляем шаг
        printf '[%d/%d] ' "$now" "$full"
        
    # Обновляем текущее состояние команды
        view:Deploy 'state' "$command"
        
    # Переносим строку
        printf '\n'
    ;;
esac
}
