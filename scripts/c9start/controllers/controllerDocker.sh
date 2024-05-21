#▄────────────────────────▄
#█                        █
#█  Controller: Docker    █
#█  • Докер (управление)  █
#█                        █
#▀────────────────────────▀
controller:Docker() { case "$1" in
# Проверки
    'no_image')      model:Docker "$@" ;; # Проверяет существует-ли образ
    'no_container')  model:Docker "$@" ;; # Проверяет существует-ли контейнер
    
# Сборка образа
    'create')        model:Docker 'build'         4 "${@:2}" ;; # Создает новый образ
    'remove')        model:Docker 'build'         5 "${@:2}" ;; # Удаляет старый образ
    
# Первый старт
    'install')       model:Docker 'run_c9start'   6 "${@:2}" ;; # Скачивает образ и запускает новый контейнер
    'restart')       model:Docker 'run_c9start'   7 "${@:2}" ;; # Перезагружет текущий контейнер
    'update')        model:Docker 'run_c9start'   8 "${@:2}" ;; # Обновляет контейнер
    'start_c9start') model:Docker 'run_c9start'   9 "${@:2}" ;; # Запускает новый контейнер
    'stop_c9start')  model:Docker 'stop_c9start' 10          ;; # Удаляет старый контейнер
    'stop_all')      model:Docker 'stop_all'     11          ;; # Удаляет все контейнеры
    'remove_all')    model:Docker 'remove_all'   12          ;; # Удаляет все образы
esac
}
