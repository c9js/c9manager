#▄────────────────────────▄
#█                        █
#█  Controller: Docker    █
#█  • Докер (управление)  █
#█                        █
#▀────────────────────────▀
controller:Docker() { case "$1" in
# Проверки
    'no_image')     model:Docker "$@" ;; # Проверяет существует-ли образ
    'no_container') model:Docker "$@" ;; # Проверяет существует-ли контейнер
    
# Список команд
    'install')    SELECTION=1; model:Docker 'run' "$2" ;; # Скачивает образ и запускает новый контейнер
    'restart')    SELECTION=2; model:Docker 'run' "$2" ;; # Перезагружет текущий контейнер
    'update')     SELECTION=3; model:Docker 'run' "$2" ;; # Обновляет контейнер
    'start')      SELECTION=4; model:Docker 'run' "$2" ;; # Запускает новый контейнер
    'stop')       SELECTION=5; model:Docker "$@"       ;; # Удаляет контейнеры из списка $IMAGES
    'stop_all')   SELECTION=6; model:Docker "$@"       ;; # Удаляет все контейнеры
    'remove_all') SELECTION=7; model:Docker "$@"       ;; # Удаляет все образы
esac
}
