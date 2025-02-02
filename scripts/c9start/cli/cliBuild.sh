#▄──────────────────────────────────────▄
#█                                      █
#█  Cli: Build                          █
#█  • Сборка образа (командная строка)  █
#█                                      █
#▀──────────────────────────────────────▀
cli:Build() {
#┌──────────────┐
#│ Список опций │
#└──────────────┘
    opts:add 'h'  'help'    # Справка
    opts:add 'q'  'quiet'   # Тихий режим (не выводить финальное сообщение)
    opts:add 'c:' 'create:' # Создать новый образ
    opts:add 'r:' 'remove:' # Удалить старый образ
    
#┌───────────────────────────────────┐
#│ Создаем список опций и аргументов │
#└───────────────────────────────────┘
    args:set "$@"
    
#┌───────────────────────────────┐
#│ Выводим справочную информацию │
#└───────────────────────────────┘
    cli:Help 'build'
    
#┌────────────────────────────┐
#│ Передано только имя образа │
#│ c9 build <имя образа>      │
#└────────────────────────────┘
    if (( ${#ARGS[*]} == 2 && $# == 2 )); then
    # Создаем новый образ
        cli:RUN controller:Docker 'create' "$(arg 1)"
    fi
    
#┌───────────────────────────────────────┐
#│ Создать новый образ                   │
#│ c9 build [--create | -c] <имя образа> │
#└───────────────────────────────────────┘
    if is:opt 'create'; then
    # Создаем новый образ
        cli:RUN controller:Docker 'create' "$(opt 'create')"
    fi
    
#┌───────────────────────────────────────┐
#│ Удалить старый образ                  │
#│ c9 build [--remove | -r] <имя образа> │
#└───────────────────────────────────────┘
    if is:opt 'remove'; then
    # Удаляем старый образ
        cli:RUN controller:Docker 'remove' "$(opt 'remove')"
    fi
    
#┌────────────────────┐
#│ Команда не найдена │
#└────────────────────┘
# Выводим сообщение об ошибке
    cli:Error 'build' "$2"
}
