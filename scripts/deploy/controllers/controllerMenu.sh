#▄───────────────────────▄
#█                       █
#█  Controller: Menu     █
#█  • Меню (управление)  █
#█                       █
#▀───────────────────────▀
controller:Menu() { case "$1" in
    'save_git')    model:Menu "$@" ;; # Сохраняет настройки git-репозитория
    'save_docker') model:Menu "$@" ;; # Сохраняет настройки docker-репозитория
esac
}
