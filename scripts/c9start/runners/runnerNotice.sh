#▄─────────────────────────────────▄
#█                                 █
#█  Runner: Notice                 █
#█  • Уведомление (запуск команд)  █
#█                                 █
#▀─────────────────────────────────▀
runner:Notice() { case "$1" in
#┌────────────────────────────────┐
#│ Проверяет запущен-ли контейнер │
#└────────────────────────────────┘
    'run')
        [ -n "$RUN_IMAGE" ]
    ;;
    
#┌───────────────────────────────────────┐
#│ Проверяет запущен-ли старый контейнер │
#└───────────────────────────────────────┘
    'run_old')
        [[ -n "$RUN_IMAGE" && "$RUN_VERSION" != "$VERSION" ]]
    ;;
    
#┌───────────────────────────┐
#│ Проверяет текущий каталог │
#└───────────────────────────┘
    'dir_empty')
        is_empty_dir "$CURRENT_PATH"
    ;;
    
#┌─────────────────────────────────┐
#│ Проверяет локальный репозиторий │
#└─────────────────────────────────┘
    'dir_error')
        ! is_empty_dir "$CURRENT_PATH" && ! is_dir "$CURRENT_PATH/.git"
    ;;
    
#┌─────────────────────────────────────┐
#│ Проверяет задана-ли переменная '$P' │
#└─────────────────────────────────────┘
    'bad_p')
        [ -z "$P" ]
    ;;
esac
}