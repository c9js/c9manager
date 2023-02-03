#▄──────────────────────▄
#█                      █
#█  Controller: Git     █
#█  • Гит (управление)  █
#█                      █
#▀──────────────────────▀
controller:Git() { case "$1" in
    'gitclone') model:Git "$@" ;; # Клонирует репозиторий
esac
}
