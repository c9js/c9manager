#▄────────────────────────────────────▄
#█                                    █
#█  Controller: Update                █
#█  • Обновление данных (управление)  █
#█                                    █
#▀────────────────────────────────────▀
controller:Update() { case "$1" in
    'pass_hidden')  model:Update "$@" ;; # Обновляет скрытый пароль
    'git')          model:Update "$@" ;; # Обновляет настройки git-репозитория
    'docker')       model:Update "$@" ;; # Обновляет настройки docker-репозитория
    'repo_version') model:Update "$@" ;; # Обновляет версию репозитория
    'bad_deploy')   model:Update "$@" ;; # Обновляет информацию о последнем деплое
esac
}
