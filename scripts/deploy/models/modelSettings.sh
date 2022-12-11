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
    # Список аргументов
        local new_user="$2" # Новое имя git-юзера
        local new_repo="$3" # Новое имя git-репозитория
        
    # Проверяем изменилось-ли имя git-юзера
        if [ "$GIT_USER" != "$new_user" ]; then
            save_file "$PATH_GIT_USER" "$new_user" # Сохраняем в файл
            GIT_USER="$new_user"                   # Обновляем переменную
        fi
        
    # Проверяем изменилось-ли имя git-репозитория
        if [ "$GIT_REPO" != "$new_repo" ]; then
            save_file "$PATH_GIT_REPO" "$new_repo" # Сохраняем в файл
            GIT_REPO="$new_repo"                   # Обновляем переменную
        fi
        
    # Выводим сообщение об успешном завершении
        view:Settings 'success' "$1"
    ;;
    
#┌────────────────────────────────────────┐
#│ Сохраняет настройки docker-репозитория │
#└────────────────────────────────────────┘
    'save_docker')
    # Список аргументов
        local new_user="$2" # Новый логин от docker-репозитория
        local new_pass="$3" # Новый пароль от docker-репозитория
        
    # Проверяем изменился-ли логин
        if [ "$DOCKER_USER" != "$new_user" ]; then
            save_file "$PATH_DOCKER_USER" "$new_user" # Сохраняем в файл
            DOCKER_USER="$new_user"                   # Обновляем переменную
        fi
        
    # Проверяем изменился-ли пароль
        if [ "$DOCKER_PASS" != "$new_pass" ]; then
            save_file "$PATH_DOCKER_PASS" "$new_pass" # Сохраняем в файл
            DOCKER_PASS="$new_pass"                   # Обновляем переменную
        fi
        
    # Обновляем скрытый пароль
        controller:Update 'pass_hidden'
        
    # Выводим сообщение об успешном завершении
        view:Settings 'success' "$1"
    ;;
esac
}
