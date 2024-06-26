#▄─────────────────────────────────▄
#█                                 █
#█  Runner: Notice                 █
#█  • Уведомление (запуск команд)  █
#█                                 █
#▀─────────────────────────────────▀
runner:Notice() { case "$1" in
#┌─────────────────────────┐
#│ Проверяет текущую ветку │
#└─────────────────────────┘
    'bad_branch')
        [ -z "$(git branch --show-current 2> '/dev/null')" ]
    ;;
    
#┌──────────────────────────┐
#│ Проверяет текущий статус │
#└──────────────────────────┘
    'bad_status')
        [ -n "$(git status --porcelain)" ]
    ;;
    
#┌─────────────────────────────────────────────────┐
#│ Проверяет задан-ли пароль от docker-репозитория │
#└─────────────────────────────────────────────────┘
    'bad_docker_pass')
        [ -z "$DOCKER_PASS" ]
    ;;
    
#┌──────────────────────────────────────┐
#│ Проверяет устарела-ли текущая версия │
#└──────────────────────────────────────┘
    'bad_current_version')
        [ "$REPO_VERSION" != "$VERSION" ]
    ;;
    
#┌────────────────────────────────────────┐
#│ Проверяет завершен-ли последний деплой │
#└────────────────────────────────────────┘
    'bad_deploy')
        [ -n "$LAST_SELECTION" ]
    ;;
    
#┌────────────────────────────────────────────────┐
#│ Проверяет проходит-ли валидацию текущая версия │
#└────────────────────────────────────────────────┘
    'bad_valid_version')
        ! isValidVersion "$VERSION"
    ;;
esac
}
