#▄────────────────────────────────▄
#█                                █
#█  Controller: Edit              █
#█  • Редактировать (управление)  █
#█                                █
#▀────────────────────────────────▀
controller:Edit() { case "$1" in
    'is_edit') model:Edit "$@" ;; # Проверяет можно-ли редактировать коммит
    'save')    model:Edit "$@" ;; # Сохраняет описание коммита
esac
}
