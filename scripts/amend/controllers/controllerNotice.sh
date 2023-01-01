#▄──────────────────────────────▄
#█                              █
#█  Controller: Notice          █
#█  • Уведомление (управление)  █
#█                              █
#▀──────────────────────────────▀
controller:Notice() { case "$1" in
    'bad_commit') model:Notice "$@" ;; # Проверяет хэш текущего коммита
    'bad_branch') model:Notice "$@" ;; # Проверяет находитя-ли HEAD на ветке
esac
}
