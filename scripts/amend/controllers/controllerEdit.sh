#▄────────────────────────────────▄
#█                                █
#█  Controller: Edit              █
#█  • Редактировать (управление)  █
#█                                █
#▀────────────────────────────────▀
controller:Edit() { case "$1" in
    'run') model:Edit "$@" ;; # Выполняет список команд (для выбранного меню)
    *)     pages:Menu "$@" ;; # Выводит список пунктов (для выбранного меню)
esac
}
