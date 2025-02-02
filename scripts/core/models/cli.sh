#▄─────────────────────────────▄1.0.1
#█                             █
#█  Core: Cli                  █
#█  • Командная строка (ядро)  █
#█                             █
#▀─────────────────────────────▀
core:Cli() { case "$1" in
#┌──────────────────────────────┐
#│ Выполняет переданную команду │
#└──────────────────────────────┘
    'run')
    # Выполняем переданную команду
        "${@:2}"
        
    # Сохраняем код выхода
        local code_exit=$?
        
    # Выводим финальное сообщение
        if no:opt 'quiet'; then
        # Очищаем экран
            reset
            
        # Выводим финальное сообщение
            menu:Message
        fi
        
    # Завершаем процесс
        exit $code_exit
    ;;
    
#┌───────────────────────────────┐
#│ Выводит справочную информацию │
#└───────────────────────────────┘
    'help')
    # Проверяем опции помощи "-h" или "--help"
        if is:opt 'help'; then
        # Выводим справочную информацию
            view:Cli "$@"
            
        # Выводим финальное сообщение
            menu:Message
            
        # Завершаем процесс
            exit
        fi
    ;;
    
#┌─────────────────────────────┐
#│ Выводит сообщение об ошибке │
#└─────────────────────────────┘
    'error')
    # Выводим сообщение об ошибке
        view:Cli "$@"
        
    # Выводим финальное сообщение
        menu:Message
        
    # Завершаем процесс
        exit 1
    ;;
esac
}
