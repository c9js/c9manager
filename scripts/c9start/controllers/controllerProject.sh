#▄───────────────────────────────────▄
#█                                   █
#█  Controller: Project              █
#█  • Выбранный проект (управление)  █
#█                                   █
#▀───────────────────────────────────▀
controller:Project() { case "$1" in
    'is:Name')      model:Project "$@" ;; # Проверяет существует-ли проект с таким именем
    'get:Info')     model:Project "$@" ;; # Получает информацию о проекте
    'edit:Name')    model:Project "$@" ;; # Переименовывает проект
    'edit:Ports')   model:Project "$@" ;; # Изменяет количество портов
    'edit:Image')   model:Project "$@" ;; # Изменяет текущий образ
    'toggle:State') model:Project "$@" ;; # Переключает состояние контейнера
esac
}
