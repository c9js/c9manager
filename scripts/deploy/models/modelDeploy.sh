#▄─────────────────────▄
#█                     █
#█  Model: Deploy      █
#█  • Деплой (логика)  █
#█                     █
#▀─────────────────────▀
model:Deploy() { case "$1" in
#┌───────────────────────────────────┐
#│ Пробует еще раз продолжить деплой │
#└───────────────────────────────────┘
    'continue')
    # Сохраняем последнюю команду
        local error_command="$2"
        
    # Сохраняем последний вариант деплоя
        local error_selection="$SELECTION"
        
    # Обновляем выбранный вариант деплоя
        SELECTION=0
        
    # Выполняем список команд
        model:Deploy 'run_list' "${CONTINUE_LIST[@]}"
        
    # Пробуем еще раз продолжить деплой
        controller:Deploy 'start' "$error_selection" "$NEW_VERSION" "$error_command"
    ;;
    
#┌───────────────────────────────────┐
#│ Начинает один из вариантов деплоя │
#└───────────────────────────────────┘
    'start')
    # Сохраняем выбранный вариант деплоя
        SELECTION="$2"
        
    # Сохраняем новую версию
        NEW_VERSION="$3"
        
    # Сохраняем последнюю команду
        ERROR_COMMAND="$4"
        
    # Деплоит один из выбранных вариантов
        case "$SELECTION" in
        # Сразу в оба репозитория
            1) model:Deploy 'deploy_git'    && # Деплоим в git-репозиторий
               model:Deploy 'deploy_docker' && # Деплоим в docker-репозиторий
                view:Deploy 'success'       && # Выводим сообщение об успешном завершении
                return
            ;;
            
        # Только в git-репозиторий
            2) model:Deploy 'deploy_git'    && # Деплоим в git-репозиторий
                view:Deploy 'success'       && # Выводим сообщение об успешном завершении
                return
            ;;
            
        # Только в docker-репозиторий
            3) model:Deploy 'deploy_docker' && # Деплоим в docker-репозиторий
                view:Deploy 'success'       && # Выводим сообщение об успешном завершении
                return
            ;;
        esac
    ;;
    
#┌────────────────────────────────────────┐
#│ Деплоит новую версию в git-репозиторий │
#└────────────────────────────────────────┘
    'deploy_git')
    # Сохраняем текущий репозиторий
        CURRENT_REPO="$1"
        
    # Выполняем список команд
        model:Deploy 'run_list' "${GIT_LIST[@]}"
    ;;
    
#┌───────────────────────────────────────────┐
#│ Деплоит новую версию в docker-репозиторий │
#└───────────────────────────────────────────┘
    'deploy_docker')
    # Сохраняем текущий репозиторий
        CURRENT_REPO="$1"
         
    # Выполняем список команд
        model:Deploy 'run_list' "${DOCKER_LIST[@]}"
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
        if [[ "$command" == "$ERROR_COMMAND" ]]; then
        # Обнуляем последнюю команду и выполняем текущую команду
            ERROR_COMMAND=''
        else
        # Проверяем последнюю команду
            if [ -n "$ERROR_COMMAND" ]; then
            # Пропускаем текущую команду
                return 1
            fi
        fi
        
    # Обновляем текущий статус
        model:Deploy 'status' "$command" "$now"
        
    # Выполняем команду
        if controller:Run "$command"; then
        # Выводим сообщение об ошибке
            view:Deploy 'error' "$command"
            
        # Возвращаем старую версию
            controller:Run 'backup_version'
            
        # Предлагаем пользователю попробовать еще раз
            view:Menu 'continue' "$command"
            
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
        local continue_full=${#CONTINUE_LIST[*]}
        
    # Обновляем общее количество шагов
        case "$SELECTION" in
            1) let full=$git_full+$docker_full ;; # Сразу в оба репозитория
            2) let full=$git_full              ;; # Только в git-репозиторий
            3) let full=$docker_full           ;; # Только в docker-репозиторий
            0) let full=$continue_full         ;; # Пробуем еще раз
        esac
        
    # Добавляем шаги от deploy git
        if [[ "$SELECTION" == 1 && "$CURRENT_REPO" == 'deploy_docker' ]]; then
            let now+=$git_full
        fi
        
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
