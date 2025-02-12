#▄────────────────────────────▄
#█                            █
#█  Runner: Deploy            █
#█  • Деплой (запуск команд)  █
#█                            █
#▀────────────────────────────▀
runner:Deploy() { case "$1" in
#┌─────────────────────────────┐
#│ Проходит контройльную точку │
#└─────────────────────────────┘
    'no_stop') return 0 ;;
    
#┌─────────────────────────┐
#│ Проверяет текущую ветку │
#└─────────────────────────┘
    'is_branch')
        [ -n "$(git branch --show-current 2> '/dev/null')" ]
    ;;
    
#┌──────────────────────────┐
#│ Проверяет текущий статус │
#└──────────────────────────┘
    'is_status')
        [ -z "$(git status --porcelain)" ]
    ;;
    
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
        save_file "$PATH_VERSION" "$NEW_VERSION"
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
            docker login --username "$DOCKER_USER" --password-stdin
    ;;
    
#┌─────────────────────────────────────────┐
#│ Проверяет авторизацию в git-репозиторий │
#└─────────────────────────────────────────┘
    'git_login')
        git remote show origin
    ;;
    
#┌──────────────────┐
#│ Для тестирования │
#└──────────────────┘
    # *) return 0 ;;
    
#┌─────────────────────────────────┐
#│ Добавляет новую версию в индекс │
#└─────────────────────────────────┘
    'git_add')
        git add VERSION
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
    
#┌───────────────────────────────────────┐
#│ Удаляет старый тег из git-репозитория │
#└───────────────────────────────────────┘
    'tag_remove')
        git push origin --delete "$NEW_VERSION" &> '/dev/null'
        return 0 # Обязательно return 0, так как на сервере скорей всего нет такого тега
    ;;
    
#┌──────────────────────────────┐
#│ Создает тег для новой версии │
#└──────────────────────────────┘
    'tag_create')
        git tag "$NEW_VERSION" -f
    ;;
    
#┌─────────────────────────────────┐
#│ Загружает тег в git-репозиторий │
#└─────────────────────────────────┘
    'tag_push')
        git push origin "$NEW_VERSION"
    ;;
    
#┌──────────────────┐
#│ Создание образов │
#└──────────────────┘
    'build:c9docker') "$PATH_WORKSPACE/scripts/c9start/entrypoint.sh" 'build' "${1/*:}" ;;
    'build:c9start')  "$PATH_WORKSPACE/scripts/c9start/entrypoint.sh" 'build' "${1/*:}" ;;
    'build:c9open')   "$PATH_WORKSPACE/scripts/c9start/entrypoint.sh" 'build' "${1/*:}" ;;
    'build:c9vue')    "$PATH_WORKSPACE/scripts/c9start/entrypoint.sh" 'build' "${1/*:}" ;;
    
#┌────────────────┐
#│ Создание тегов │
#└────────────────┘
    'tag1:c9docker')  docker tag "${1/*:}" "$DOCKER_USER/${1/*:}:$NEW_VERSION" ;;
    'tag1:c9start')   docker tag "${1/*:}" "$DOCKER_USER/${1/*:}:$NEW_VERSION" ;;
    'tag1:c9open')    docker tag "${1/*:}" "$DOCKER_USER/${1/*:}:$NEW_VERSION" ;;
    'tag1:c9vue')     docker tag "${1/*:}" "$DOCKER_USER/${1/*:}:$NEW_VERSION" ;;
    'tag2:c9docker')  docker tag "${1/*:}" "$DOCKER_USER/${1/*:}:latest"       ;;
    'tag2:c9start')   docker tag "${1/*:}" "$DOCKER_USER/${1/*:}:latest"       ;;
    'tag2:c9open')    docker tag "${1/*:}" "$DOCKER_USER/${1/*:}:latest"       ;;
    'tag2:c9vue')     docker tag "${1/*:}" "$DOCKER_USER/${1/*:}:latest"       ;;
    
#┌───────────────────────────────────────┐
#│ Загрузка образов в docker-репозиторий │
#└───────────────────────────────────────┘
    'push1:c9docker') docker push "$DOCKER_USER/${1/*:}:$NEW_VERSION" ;;
    'push1:c9start')  docker push "$DOCKER_USER/${1/*:}:$NEW_VERSION" ;;
    'push1:c9open')   docker push "$DOCKER_USER/${1/*:}:$NEW_VERSION" ;;
    'push1:c9vue')    docker push "$DOCKER_USER/${1/*:}:$NEW_VERSION" ;;
    'push2:c9docker') docker push "$DOCKER_USER/${1/*:}:latest"       ;;
    'push2:c9start')  docker push "$DOCKER_USER/${1/*:}:latest"       ;;
    'push2:c9open')   docker push "$DOCKER_USER/${1/*:}:latest"       ;;
    'push2:c9vue')    docker push "$DOCKER_USER/${1/*:}:latest"       ;;
esac
}
