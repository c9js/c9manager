#▄───────────────────────▄
#█                       █
#█  View                 █
#█  • Общий (интерфейс)  █
#█                       █
#▀───────────────────────▀
view() { case "$1" in
#┌───────────────┐
#│ Инициализация │
#└───────────────┘
    'init')
    # Создаем заголовок меню
        view:Menu 'header'
        
    # Обновляем данные
        controller:Update 'git'          # Обновляем настройки git-репозитория
        controller:Update 'docker'       # Обновляем настройки docker-репозитория
        controller:Update 'bad_deploy'   # Обновляем информацию о последнем деплое
        controller:Update 'repo_version' # Обновляем версию репозитория
        
    # Проверяем список всех уведомлений
        modelView:Notice 'check'
    ;;
esac
}
