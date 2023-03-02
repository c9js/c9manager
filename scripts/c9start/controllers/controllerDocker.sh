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
    
# Сборка образа
    'create')     model:Docker 'build'        2 "${@:2}" ;; # Создает новый образ
    'remove')     model:Docker 'build'        3 "${@:2}" ;; # Удаляет старый образ
    
# Первый старт
    'install')    model:Docker 'run_c9start'  4 "${@:2}" ;; # Скачивает образ и запускает новый контейнер
    'restart')    model:Docker 'run_c9start'  5 "${@:2}" ;; # Перезагружет текущий контейнер
    'update')     model:Docker 'run_c9start'  6 "${@:2}" ;; # Обновляет контейнер
    'start')      model:Docker 'run_c9start'  7 "${@:2}" ;; # Запускает новый контейнер
    'stop')       model:Docker 'stop_c9start' 8          ;; # Удаляет старый контейнер
    'stop_all')   model:Docker 'stop_all'     9          ;; # Удаляет все контейнеры
    'remove_all') model:Docker 'remove_all'  10          ;; # Удаляет все образы
esac
}
