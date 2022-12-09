#▄────────────────────────▄
#█                        █
#█  Model: Settings       █
#█  • Настройки (логика)  █
#█                        █
#▀────────────────────────▀
model:Settings() { case "$1" in
#┌─────────────────────────────────────┐
#│ Сохраняет настройки git-репозитория │
#└─────────────────────────────────────┘
    'save_git')
   # Обновляем переменнуые
        GIT_USER="$2" # Новое имя git-юзера
        GIT_REPO="$3" # Новое имя git-репозитория
        
    # Сохраняем в файл
        save_file "$PATH_GIT_USER" "$GIT_USER"
        save_file "$PATH_GIT_REPO" "$GIT_REPO"
        
    # Выводим сообщение об успешном завершении
        view:Settings 'success' "$1"
    ;;
    
#┌────────────────────────────────────────┐
#│ Сохраняет настройки docker-репозитория │
#└────────────────────────────────────────┘
    'save_docker')
   # Обновляем переменнуые
        DOCKER_USER="$2" # Новый логин от docker-репозитория
        DOCKER_PASS="$3" # Новый пароль от docker-репозитория
        
    # Сохраняем в файл
        save_file "$PATH_DOCKER_USER" "$DOCKER_USER"
        save_file "$PATH_DOCKER_PASS" "$DOCKER_PASS"
        
    # Обновляем скрытый пароль
        model:Settings 'update_pass_hidden'
        
    # Выводим сообщение об успешном завершении
        view:Settings 'success' "$1"
    ;;
    
#┌──────────────────────────┐
#│ Обновляет скрытый пароль │
#└──────────────────────────┘
    'update_pass_hidden')
    # Пароль не задан
        if controller:Run 'is_docker_pass'; then
            view:Settings 'empty_pass'
            return
        fi
        
    # Создаем скрытый пароль
        DOCKER_PASS_HIDDEN="$(char ${#DOCKER_PASS} '*')"
    ;;
    
#┌─────────────────────────────────────┐
#│ Обновляет настройки git-репозитория │
#└─────────────────────────────────────┘
    'update_git')
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
    'update_docker')
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
        model:Settings 'update_pass_hidden'
    ;;
    
#┌──────────────────────────────┐
#│ Загружает версию репозитория │
#└──────────────────────────────┘
    'load_repo_version')
    # Загружаем версию из файла
        REPO_VERSION="$(< $PATH_VERSION)"
    ;;
esac
}
