#▄────────────────────────────────▄
#█                                █
#█  Model: Update                 █
#█  • Обновление данных (логика)  █
#█                                █
#▀────────────────────────────────▀
model:Update() { case "$1" in
#┌──────────────────────────┐
#│ Обновляет скрытый пароль │
#└──────────────────────────┘
    'pass_hidden')
    # Пароль не задан
        if stream 'runner:Deploy' 'is_docker_pass'; then
            DOCKER_PASS_HIDDEN="$(view:Settings 'empty_pass')"
            return
        fi
        
    # Создаем скрытый пароль
        DOCKER_PASS_HIDDEN="$(char ${#DOCKER_PASS} '*')"
    ;;
    
#┌─────────────────────────────────────┐
#│ Обновляет настройки git-репозитория │
#└─────────────────────────────────────┘
    'git')
    # Локальные переменные
        local new_user # Новое имя git-юзера
        local new_repo # Новое имя git-репозитория
        
    # Получаем имя git-юзера
        if new_user="$(get_file "$PATH_GIT_USER")"; then
        # Сохраняем новое имя git-юзера
            GIT_USER="$new_user"
        fi
        
    # Получаем имя git-репозитория
        if new_repo="$(get_file "$PATH_GIT_REPO")"; then
        # Сохраняем новое имя git-репозитория
            GIT_REPO="$new_repo"
        fi
    ;;
    
#┌────────────────────────────────────────┐
#│ Обновляет настройки docker-репозитория │
#└────────────────────────────────────────┘
    'docker')
    # Локальные переменные
        local new_user # Новый логин от docker-репозитория
        local new_pass # Новый пароль от docker-репозитория
        
    # Получаем логин от docker-репозитория
        if new_user="$(get_file "$PATH_DOCKER_USER")"; then
        # Сохраняем новый логин от docker-репозитория
            DOCKER_USER="$new_user"
        fi
        
    # Получаем пароль от docker-репозитория
        if new_pass="$(get_file "$PATH_DOCKER_PASS")"; then
        # Сохраняем новый пароль от docker-репозитория
            DOCKER_PASS="$new_pass"
        fi
        
    # Обновляем скрытый пароль
        controller:Update 'pass_hidden'
    ;;
    
#┌──────────────────────────────┐
#│ Обновляет версию репозитория │
#└──────────────────────────────┘
    'repo_version')
    # Загружаем версию из файла
        REPO_VERSION="$(get_file "$PATH_VERSION")"
    ;;
    
#┌─────────────────────────────────────────┐
#│ Обновляет информацию о последнем деплое │
#└─────────────────────────────────────────┘
    'bad_deploy')
    # Загружаем информацию из файла
        local res=($(get_file "$PATH_BAD_DEPLOY"))
        NEW_VERSION="${res[0]}"    # Последняя версия
        LAST_COMMAND="${res[1]}"   # Последняя команда
        LAST_SELECTION="${res[2]}" # Последний вариант деплоя
        NO_STOP="${res[3]}"        # Последняя контройльная точка
        SELECTION=''               # Обнуляем выбранный вариант деплоя
    ;;
esac
}
