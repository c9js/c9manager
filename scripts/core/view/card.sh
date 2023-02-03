#▄─────────────────────▄1.0.0
#█                     █
#█  Core: Card         █
#█  • Открытка (ядро)  █
#█                     █
#▀─────────────────────▀
core:Card() { case "$1" in
#┌──────────────────────────────┐
#│ Выводит уведомление на экран │
#└──────────────────────────────┘
    'card')
    # Локальные переменные
        local length=0
        local msg
        local i
        
    # Вычисляем длину
        for ((i = 2; i <= $#; i++)); do
            msg=$(printf '%s' "${!i}")
            if (( $length < ${#msg})); then
                length=${#msg}
            fi
        done
        
    # Верхняя часть
        printf '╭─%s─╮\n' "$(char $length '─')"
        
    # Сообщение
        for ((i = 2; i <= $#; i++)); do
            msg="${!i}"
            printf '│ %s%s │\n' "$msg" "$(char $(($length - ${#msg})) ' ')"
        done
        
    # Нижняя часть
        printf '╰─%s─╯\n' "$(char $length '─')"
    ;;
    
#┌─────────────────────────────┐
#│ Выводит сообщение об ошибке │
#└─────────────────────────────┘
    'error')
    # Первое сообщение
        local items=("Ошибка! $2")
        local i
        
    # Проходим по списку ошибок
        for ((i = 3; i <= $#; i++)); do
            items+=("${!i}")
        done
        
    # Выводим лог
        if [ -n "$ERROR_LOG" ]; then
            printf '%s\n' "$ERROR_LOG"
        fi
        
    # Выводим сообщение
        printf '%s' "$(notice:Card "${items[@]}")"
    ;;
    
#┌──────────────────────────────────────┐
#│ Выводит сообщение о фатальной ошибке │
#└──────────────────────────────────────┘
    'fatal_error')
    # Красный текст
        printf '%b' '\e[31m'
        
    # Сообщение об ошибке
        printf '%s' "$(notice:Error "${@:2}")"
        
    # Сброс цвета
        printf '%b' '\e[0m'
        
    # Переносим строку
        printf '\n'
        
    # Завершаем процесс
        exit
    ;;
esac
}
