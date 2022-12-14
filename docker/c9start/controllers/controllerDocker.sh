#▄────────────────────────▄
#█                        █
#█  Controller: Docker    █
#█  • Докер (управление)  █
#█                        █
#▀────────────────────────▀
controller:Docker() { case "$1" in
    'no_image')     model:Docker "$@"        ;; # Проверяет существует-ли образ
    'no_container') model:Docker "$@"        ;; # Проверяет существует-ли контейнер
    'stop')         model:Docker "$@"        ;; # Останавливает и удаляет контейнеры из списка $IMAGES
    'stop_all')     model:Docker "$@"        ;; # Останавливает и удаляет все контейнеры
    'remove_all')   model:Docker "$@"        ;; # Удаляет все образы
    'start')        model:Docker "$@"        ;; # Запускает новый контейнер
    'download')     stream "model:Docker $@" ;; # Скачивает образ
esac
}
