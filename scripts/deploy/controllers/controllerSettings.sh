#▄────────────────────────────▄
#█                            █
#█  Controller: Settings      █
#█  • Настройки (управление)  █
#█                            █
#▀────────────────────────────▀
controller:Settings() { case "$1" in
    'save_git')    model:Settings "$@" ;; # Сохраняет настройки git-репозитория
    'save_docker') model:Settings "$@" ;; # Сохраняет настройки docker-репозитория
esac
}
