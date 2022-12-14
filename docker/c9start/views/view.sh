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
        
    # Получает информацию о запущенном контейнере
        getContainerInfo "$WORKSPACE"
        
    # Проверяем списки уведомлений
        modelView:Notice 'fatal_error' # Фатальные ошибки
        modelView:Notice 'info'        # Информационные сообщения
    ;;
    
#┌──────────────────────────┐
#│ Обновляет текущий статус │
#└──────────────────────────┘
    'status')
    # Количество шагов
        local full
        
    # Очищаем экран
        reset
        
    # Заголовок
        case "$CONTROLLER" in
            'gitclone')   full=2; printf "Клонирование '%s'" "$GIT_URL/$GIT_USER/$GIT_REPO" ;;
            'install')    full=5; printf "Установка '%s'"    "$IMAGE_RUN:$VERSION"          ;;
            'restart')    full=5; printf "Перезагрузка '%s'" "$IMAGE_RUN:$VERSION"          ;;
            'start')      full=5; printf "Запуск '%s'"       "$IMAGE_RUN:$VERSION"          ;;
            'stop')       full=4; printf "Остановка '%s'"    "$RUN_IMAGE:$RUN_VERSION"      ;;
            'stop_all')   full=4; printf 'Остановка всех контейнеров'                       ;;
            'remove_all') full=5; printf 'Удаление всех образов'                            ;;
            'ssh_keygen') full=2; printf 'Создание ssh-ключа'                               ;;
        esac
        
    # Статус
        if (( $# <= 3 )); then
            printf '\n[%d/%d] %s\n' "$2" "$full" "$3"
        else
            printf '\n[%d/%d] %s (%d/%d) \n' "$2" "$full" "$3" "$(($4+1))" "$5"
        fi
    ;;
esac
}
