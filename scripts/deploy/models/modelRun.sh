#▄────────────────────────────▄
#█                            █
#█  Model: Run                █
#█  • Запуск команд (логика)  █
#█                            █
#▀────────────────────────────▀
model:Run() { case "$1" in
#┌────────────────────────┐
#│ Проверяет новую версию │
#└────────────────────────┘
    'is_new_version')
        isValidVersion "$NEW_VERSION"
    ;;
    
#┌────────────────────────┐
#│ Сохраняет новую версию │
#└────────────────────────┘
    'save_version')
        save_file "$PATH_VERSION" "$NEW_VERSION" 2>&1
    ;;
    
#┌─────────────────────────────┐
#│ Переходит в рабочий каталог │
#└─────────────────────────────┘
    'cd_workspace')
        cd "/$WORKSPACE"
    ;;
    
#┌─────────────────────────┐
#│ Проверяет имя git-юзера │
#└─────────────────────────┘
    'is_git_user')
        [ -n "$GIT_USER" ]
    ;;
    
#┌───────────────────────────────┐
#│ Проверяет имя git-репозитория │
#└───────────────────────────────┘
    'is_git_repo')
        [ -n "$GIT_REPO" ]
    ;;
    
#┌───────────────────────────────────────┐
#│ Проверяет логин от docker-репозитория │
#└───────────────────────────────────────┘
    'is_docker_user')
        [ -n "$DOCKER_USER" ]
    ;;
    
#┌────────────────────────────────────────┐
#│ Проверяет пароль от docker-репозитория │
#└────────────────────────────────────────┘
    'is_docker_pass')
        [ -n "$DOCKER_PASS" ]
    ;;
    
#┌───────────────────────────────────────────┐
#│ Проходит авторизацию в docker-репозиторий │
#└───────────────────────────────────────────┘
    'docker_login')
        printf '%s' "$DOCKER_PASS" | \
            docker login --username "$DOCKER_USER" --password-stdin 2>&1
    ;;
    
#┌─────────────────────────────────────────┐
#│ Проверяет авторизацию в git-репозиторий │
#└─────────────────────────────────────────┘
    'git_login')
        git remote show origin
    ;;
    # *) return 0; ;; # Для тестирования
    
#┌────────────────────────────────────┐
#│ Добавляет рабочий каталог в индекс │
#└────────────────────────────────────┘
    'git_add')
        git add .
    ;;
    
#┌──────────────────────┐
#│ Создает новый коммит │
#└──────────────────────┘
    'git_commit')
        git commit -m "$NEW_VERSION"
    ;;
    
#┌────────────────────────────────────┐
#│ Загружает коммит в git-репозиторий │
#└────────────────────────────────────┘
    'git_push')
        git push
    ;;
    
#┌──────────────────┐
#│ Создание образов │
#└──────────────────┘
    'build:c9open')   "/$WORKSPACE/docker/c9.sh" 'build' "${1/*:}" ;;
    'build:c9start')  "/$WORKSPACE/docker/c9.sh" 'build' "${1/*:}" ;;
    'build:c9docker') "/$WORKSPACE/docker/c9.sh" 'build' "${1/*:}" ;;
    
#┌────────────────┐
#│ Создание тегов │
#└────────────────┘
    'tag1:c9open')    docker tag "${1/*:}" "$DOCKER_USER/${1/*:}:$NEW_VERSION" ;;
    'tag1:c9start')   docker tag "${1/*:}" "$DOCKER_USER/${1/*:}:$NEW_VERSION" ;;
    'tag1:c9docker')  docker tag "${1/*:}" "$DOCKER_USER/${1/*:}:$NEW_VERSION" ;;
    'tag2:c9open')    docker tag "${1/*:}" "$DOCKER_USER/${1/*:}:latest"       ;;
    'tag2:c9start')   docker tag "${1/*:}" "$DOCKER_USER/${1/*:}:latest"       ;;
    'tag2:c9docker')  docker tag "${1/*:}" "$DOCKER_USER/${1/*:}:latest"       ;;
    
#┌───────────────────────────────────────┐
#│ Загрузка образов в docker-репозиторий │
#└───────────────────────────────────────┘
    'push1:c9open')   docker push "$DOCKER_USER/${1/*:}:$NEW_VERSION" ;;
    'push1:c9start')  docker push "$DOCKER_USER/${1/*:}:$NEW_VERSION" ;;
    'push1:c9docker') docker push "$DOCKER_USER/${1/*:}:$NEW_VERSION" ;;
    'push2:c9open')   docker push "$DOCKER_USER/${1/*:}:latest"       ;;
    'push2:c9start')  docker push "$DOCKER_USER/${1/*:}:latest"       ;;
    'push2:c9docker') docker push "$DOCKER_USER/${1/*:}:latest"       ;;
esac
}
