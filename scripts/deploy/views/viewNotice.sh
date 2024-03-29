#▄─────────────────────────▄
#█                         █
#█  Список предупреждений  █
#█                         █
#▀─────────────────────────▀
WARNING_LIST=(
    'bad_branch'          # Проверяет текущую ветку
    'bad_status'          # Проверяет текущий статус
    'bad_docker_pass'     # Проверяет задан-ли пароль от docker-репозитория
    'bad_current_version' # Проверяет устарела-ли текущая версия
)

#▄─────────────────▄
#█                 █
#█  Список ошибок  █
#█                 █
#▀─────────────────▀
ERROR_LIST=(
    'bad_deploy' # Проверяет завершен-ли последний деплой
)

#▄───────────────────────────▄
#█                           █
#█  Список фатальных ошибок  █
#█                           █
#▀───────────────────────────▀
FATAL_LIST=(
    'bad_valid_version' # Проверяет проходит-ли валидацию текущая версия
)

#▄─────────────────────────────▄
#█                             █
#█  View: Notice               █
#█  • Уведомление (интерфейс)  █
#█                             █
#▀─────────────────────────────▀
view:Notice() { case "$1" in
#┌───────────────────────┐
#│ Список предупреждений │
#└───────────────────────┘
    'warning') case "$2" in
        'bad_branch')          warning 'Вы не находитесь на ветке!'              ;;
        'bad_status')          warning "Ваш 'git status' должен быть пуст!"      ;;
        'bad_docker_pass')     warning 'Пароль для docker-репозитория не задан!' ;;
        'bad_current_version') warning "Внимание! Текущая версия '$VERSION' устарела!" "Новая версия: '$REPO_VERSION'" ;;
    esac
    ;;
    
#┌───────────────┐
#│ Список ошибок │
#└───────────────┘
    'error') case "$2" in
        'bad_deploy') view:Deploy 'error' "$LAST_COMMAND" ;;
    esac
    ;;
    
#┌─────────────────────────┐
#│ Список фатальных ошибок │
#└─────────────────────────┘
    'fatal_error') case "$2" in
        'bad_valid_version') fatal_error "Версия '$VERSION' не прошла валидацию!" ;;
    esac
    ;;
esac
}
