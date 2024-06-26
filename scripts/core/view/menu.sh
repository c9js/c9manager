#▄─────────────────────▄1.0.6
#█                     █
#█  Список переменных  █
#█                     █
#▀─────────────────────▀
declare -a MENU_MESSAGES=() # Список сообщений над меню
declare -a MENU_ITEMS       # Список пунктов меню
declare -A MENU_STATE       # Список сохраненных состояний пунктов меню

#▄─────────────────▄
#█                 █
#█  Core: Menu     █
#█  • Меню (ядро)  █
#█                 █
#▀─────────────────▀
core:Menu() { case "$1" in
#┌───────────────────────────┐
#│ Добавляет новое сообщение │
#└───────────────────────────┘
    'menu:Msg')
        MENU_MESSAGES=("$2" "$3")
    ;;
    
#┌────────────────────────────────────┐
#│ Добавляет еще одно новое сообщение │
#└────────────────────────────────────┘
    'menu:MsgAdd')
        MENU_MESSAGES+=("$2" "$3")
    ;;
    
#┌───────────────────────────────────────────────────────────────┐
#│ Добавляет новое сообщение (если других сообщений еще не было) │
#└───────────────────────────────────────────────────────────────┘
    'menu:Low')
        [ ${#MENU_MESSAGES[*]} == 0 ] && MENU_MESSAGES=("$2" "$3")
    ;;
    
#┌────────────────────────────┐
#│ Выводит сообщение на экран │
#└────────────────────────────┘
    'message')
    # Локальные переменные
        local color0='\e[0m' # Сброс цвета
        local color          # Цвет текста
        local i
        
    # Проходим по списку сообщений
        for ((i = 0; i < ${#MENU_MESSAGES[*]}; i+=2)); do
        # Преобразуем цвет текста в эскейп последовательность
            case "${MENU_MESSAGES[$i]}" in
                'Magenta') color='\e[95m' ;; # Фиолетовый текст
                'Yellow')  color='\e[33m' ;; # Желтый текст
                'Green')   color='\e[92m' ;; # Зеленый текст
                'Blue')    color='\e[36m' ;; # Синий текст
                'Red')     color='\e[91m' ;; # Красный текст
            esac
            
        # Цвет текста
            printf '%b' "$color"
            
        # Текст
            printf '%s' "${MENU_MESSAGES[$i+1]}"
            
        # Сброс цвета
            printf '%b' "$color0"
            
        # Переносим строку
            printf '\n'
        done
        
    # Обнуляем список сообщений
        MENU_MESSAGES=()
    ;;
    
#┌───────────────────┐
#│ Выводит заголовок │
#└───────────────────┘
    'header')
    # Выводим заголовок
        printf '%s ' "$2"
        
    # Сохраняем позицию курсора
        printf '\e[s'
        
    # Переносим строку (два раза)
        printf '\n\n'
    ;;
    
#┌───────────────────────┐
#│ Выводит меню на экран │
#└───────────────────────┘
    'menu')
    # Очищаем экран
        reset
        
    # Выводим сообщение на экран
        menu:Message
        
    # Выводим заголовок
        core:Menu 'header' "$2"
        
    # Добавляем выбранный пункт
        MENU_ITEMS=("$3")
    ;;
    
#┌─────────────────────────────────────────────┐
#│ Добавляет новый пункт в список пунктов меню │
#└─────────────────────────────────────────────┘
    'menu:AddItem')
    # Список аргументов
        local color="$2" # Цвет фона
        
    # Локальные переменные
        local i
        
    # Проходим по списку новых пунктов
        for ((i = 3; i <= $#; i++)); do
        # Добавляем новый пункт в список пунктов меню
            MENU_ITEMS+=("$color" "${!i}")
        done
    ;;
    
#┌───────────────────────────────────────────────────┐
#│ Добавляет последний пункт и выводит меню на экран │
#└───────────────────────────────────────────────────┘
    'exit')
    # Добавляем последний пункт
        menu:AddItem "$3" "$2"
        
    # Локальные переменные
        local selection="${MENU_ITEMS[0]}" # Выбранный пункт
        local menuID="${MENU_ITEMS[*]:1}"  # ID-меню
        local i
        
    # Удаляем первый элемент массива
        MENU_ITEMS=("${MENU_ITEMS[@]:1}")
        
    # Проходим по пунктам меню
        for ((i = 0; i < ${#MENU_ITEMS[*]} / 2; i++)); do
            printf '\n'
        done
        
    # Проверяем есть-ли сохраненное состояние пунктов меню
        if [ -n "${MENU_STATE[$menuID]}" ]; then
            selection="${MENU_STATE[$menuID]}"
        fi
        
    # Выводим подсказку
        printf '\n' # Перенос строки
        printf '\e[44m' # Синий фон
        printf '\e[K' # Удаление всех символов до конца строки
        printf ' Выбор: [ENTER], Навигация: [Page Up] / [Page Down] '
        printf '\e[0m' # Сброс цвета
        printf '\n'
        
    # Обновляем пункты меню
        menu:Update "$selection"
        
    # Сохраняем новое состояние выбранного пункта меню
        [ -n "$menuID" ] && MENU_STATE[$menuID]=$REPLY
        
    # Выбран не последний пункт
        (( $REPLY < ${#MENU_ITEMS[*]} / 2 )) && return $REPLY
        
    # Выбран последний пункт
        return 0
    ;;
    
#┌───────────────────────┐
#│ Обновляет пункты меню │
#└───────────────────────┘
    'menu:Update')
    # Локальные переменные
        local count=$((${#MENU_ITEMS[*]} / 2)) # Количество пунктов
        local selection      # Выбранный пункт
        local length=0       # Длина самого длинного пункта
        local color0='\e[0m' # Сброс цвета
        local color          # Цвет фона
        local i
        
    # Переводим строку в число
        selection=$(number "$2")
        
    # Выбран пункт "Exit"
        if (( $selection <= 0 || $selection > $count )); then
            selection=$count
        fi
        
    # Вычисляем длину
        for ((i = 0; i < ${#MENU_ITEMS[*]}; i+=2)); do
            if (( $length < ${#MENU_ITEMS[$i+1]})); then
                length=${#MENU_ITEMS[$i+1]}
            fi
        done
        
    # Восстанавливаем позицию курсора
        printf '\e[u'
        
    # Удаляем все символы до конца строки
        printf '\e[K'
        
    # Переносим строку (два раза)
        printf '\n\n'
        
    # Проходим по пунктам меню
        for ((i = 0; i < ${#MENU_ITEMS[*]}; i+=2)); do
        # Преобразуем цвет фона в эскейп последовательность
            case "${MENU_ITEMS[$i]}" in
                'Yellow') color='\e[43m'  ;; # Желтый фон
                'Green')  color='\e[42m'  ;; # Зеленый фон
                'Red')    color='\e[41m'  ;; # Красный фон
                *)        color='\e[100m' ;; # Серый фон
            esac
            
        # Отступ слева
            printf ' '
            
        # Удаляем все символы до конца строки
            printf '\e[K'
            
        # Пункт меню выбран
            if (( $i / 2 == $selection - 1 )); then
            # Цвет фона
                printf '%b' "$color"
                
            # Текст
                printf ' %b ' "${MENU_ITEMS[$i+1]}"
                
            # Ширина фона (отступ)
                printf '%b' "$(char $(($length - ${#MENU_ITEMS[$i+1]})) ' ')"
                
            # Сброс цвета
                printf '%b' "$color0"
                
        # Пункт меню НЕ выбран
            else
            # Текст
                printf ' %b ' "${MENU_ITEMS[$i+1]}"
            fi
            
        # Переносим строку
            printf '\n'
        done
        
    # Удаляем все символы до конца строки
        printf '\e[K'
        
    # Восстанавливаем позицию курсора
        printf '\e[u'
        
    # Локальные переменные
        local keyPageDown="$(printf '\e[B')"
        local keyPageUp="$(printf '\e[A')"
        local keyEnter="$(printf '\n')"
        local keyESC="$(printf '\e')"
        local extra=''
        local key=''
        
    # Ожидаем пока пользователь передаст команду с клавиатуры
        read -s -r -n1 key &> '/dev/null'
        while read -s -n1 -t .05 extra &> '/dev/null' ; do
            key="$key$extra"
        done
        
    # Обрабатываем переданную команду с клавиатуры
        case "$key" in
        # Exit
            "$keyESC" | '`' | 'q' | 'ё' | 'й' | 0)
            # Эмуляция двойного нажатия
                if [ "$selection" == "$count" ]; then
                    REPLY=$count
                    return
                fi
                selection=$count
            ;;
            
        # Up
            "$keyPageUp")
                if (( $selection > 1 )); then
                    let selection--
                else
                    selection=$count
                fi
            ;;
            
        # Down
            "$keyPageDown")
                if (( $selection < $count )); then
                    let selection++
                else
                    selection=1
                fi
            ;;
            
        # Цифры от 1 до 9
            [1-9])
                if (( $count > $key )); then
                # Эмуляция двойного нажатия
                    if [ "$selection" == "$key" ]; then
                        REPLY=$key
                        return
                    fi
                    selection=$key
                fi
            ;;
            
        # Enter
            "$keyEnter")
                REPLY=$selection
                return
            ;;
        esac
        
    # Обновляем пункты меню
        menu:Update "$selection"
    ;;
    
#┌─────────────────────────────────────────────┐
#│ Обнуляет сохраненные состояния пунктов меню │
#└─────────────────────────────────────────────┘
    'reset:Menu')
        MENU_STATE=()
    ;;
esac
}
