#▄───────────────────────▄
#█                       █
#█  Controller: Menu     █
#█  • Меню (управление)  █
#█                       █
#▀───────────────────────▀
controller:Menu() { case "$1" in
    'edit')   model:Menu "$@" ;; # Сохраняет выбранный вариант "Редактировать описание"
    'date')   model:Menu "$@" ;; # Сохраняет выбранный вариант "Изменить дату создания"
    'choice') model:Menu "$@" ;; # Предлагает пользователю выбрать коммит
    'select') model:Menu "$@" ;; # Обрабатывает выбранный пункт
esac
}
