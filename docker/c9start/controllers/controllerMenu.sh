#▄───────────────────────▄
#█                       █
#█  Controller: Menu     █
#█  • Меню (управление)  █
#█                       █
#▀───────────────────────▀
controller:Menu() { CONTROLLER="$1"; case "$1" in
    'gitclone')     model:Menu "$@" ;; # Клонирует репозиторий
    'stop')         model:Menu "$@" ;; # Останавливает и удаляет контейнеры из списка $IMAGES
    'stop_all')     model:Menu "$@" ;; # Останавливает и удаляет все контейнеры
    'remove_all')   model:Menu "$@" ;; # Удаляет все образы
    'install')      model:Menu "$@" ;; # Запускает новый контейнер
    'restart')      model:Menu "$@" ;; # Перезагружен контейнер
    'start')        model:Menu "$@" ;; # Запускает новый контейнер
    'is_valid_ssh') model:Menu "$@" ;; # Проверяет верно-ли указано имя файла для ssh-ключа
    'ssh_keygen')   model:Menu "$@" ;; # Создает новый ssh-ключ
esac
}
