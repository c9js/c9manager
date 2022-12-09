#▄────────────────────────────▄
#█                            █
#█  Controller: Settings      █
#█  • Настройки (управление)  █
#█                            █
#▀────────────────────────────▀
controller:Settings() { case "$1" in
    'save_git')          model:Settings "$@" ;; # Сохраняет настройки git-репозитория
    'save_docker')       model:Settings "$@" ;; # Сохраняет настройки docker-репозитория
    'update_git')        model:Settings "$@" ;; # Обновляет настройки git-репозитория
    'update_docker')     model:Settings "$@" ;; # Обновляет настройки docker-репозитория
    'load_repo_version') model:Settings "$@" ;; # Загружает версию репозитория
esac
}
