#▄────────▄1.0.2
#█        █
#█  Меню  █
#█        █
#▀────────▀
#┌───────────────────┐
#│ Список переменных │
#└───────────────────┘
typeset -a menuMessages # Список сообщений над меню
typeset -a menuItems # Список пунктов меню
typeset -A menuState # Список сохраненных состояний пунктов меню

#┌───────────────────────┐
#│ Выводит меню на экран │
#└───────────────────────┘
menu() {
# Очищаем экран
    reset
    
# Локальные переменные
    local color0='\e[0m' # Сброс цвета
    local color          # Цвет текста
    local i
    
# Проходим по списку сообщений
    for ((i = 0; i < ${#menuMessages[*]} / 2; i++)); do
    # Преобразуем цвет текста в эскейп последовательность
        case "${menuMessages[$i]}" in
            'Magenta') color='\e[95m' ;; # Фиолетовый текст
            'Yellow')  color='\e[33m' ;; # Желтый текст
            'Green')   color='\e[92m' ;; # Зеленый текст
            'Blue')    color='\e[36m' ;; # Синий текст
            'Red')     color='\e[91m' ;; # Красный текст
        esac
        
    # Цвет текста
        printf '%b' "$color"
        
    # Текст
        printf '%s' "${menuMessages[$i+1]}"
        
    # Сброс цвета
        printf '%b' "$color0"
        
    # Переносим строку
        printf '\n'
    done
    
# Выводим заголовок
    printf '%s ' "$1"
    
# Сохраняем позицию курсора
    printf '\e[s'
    
# Переносим строку два раза
    printf '\n\n'
    
# Обнуляем список сообщений
    menuMessages=()
    
# Добавляем выбранный пункт
    menuItems=("$2")
}

#┌─────────────────────────────────────────────┐
#│ Добавляет новый пункт в список пунктов меню │
#└─────────────────────────────────────────────┘
menu:AddItem() {
    menuItems+=("$1" "$2")
}

#┌────────────────────────────────┐
#│ Добавляет пункты разных цветов │
#└────────────────────────────────┘
Yellow() { menu:AddItem 'Yellow' "$1"; }
Green()  { menu:AddItem 'Green'  "$1"; }
Red()    { menu:AddItem 'Red'    "$1"; }

#┌───────────────────────────────────────────────────┐
#│ Добавляет последний пункт и выводит меню на экран │
#└───────────────────────────────────────────────────┘
Exit() {
# Добавляем последний пункт
    menu:AddItem "$2" "$1"
    
# Локальные переменные
    local selection="${menuItems[0]}" # Выбранный пункт
    local menuID="${menuItems[*]:1}"  # ID-меню
    local i
    
# Удаляем первый элемент массива
    menuItems=("${menuItems[@]:1}")
    
# Проходим по пунктам меню
    for ((i = 0; i < ${#menuItems[*]} / 2; i++)); do
        printf '\n'
    done
    
# Проверяем есть-ли сохраненное состояние пунктов меню
    if [[ "${menuState[$menuID]}" != '' ]]; then
        selection="${menuState[$menuID]}"
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
    [[ "$menuID" != '' ]] && menuState[$menuID]=$REPLY
    
# Выбран не последний пункт
    (( $REPLY < ${#menuItems[*]} / 2 )) && return $REPLY
    
# Выбран последний пункт
    return 0
}

#┌───────────────────────┐
#│ Обновляет пункты меню │
#└───────────────────────┘
menu:Update() {
# Локальные переменные
    local count=$(( ${#menuItems[*]} / 2 )) # Количество пунктов
    local selection      # Выбранный пункт
    local length=0       # Длина самого длинного пункта
    local color0='\e[0m' # Сброс цвета
    local color          # Цвет фона
    local i
    
# Переводим строку в число
    selection=$(number "$1")
    
# Выбран пункт: "Exit"
    if (( $selection <= 0 || $selection > $count )); then
        selection=$count
    fi
    
# Вычисляем длину
    for ((i = 0; i < ${#menuItems[*]}; i += 2)); do
        if (( $length < ${#menuItems[$i+1]})); then
            length=${#menuItems[$i+1]}
        fi
    done
    
# Восстанавливаем позицию курсора
    printf '\e[u'
    
# Удаляем все символы до конца строки
    printf '\e[K'
    
# Переносим строку два раза
    printf '\n\n'
    
# Проходим по пунктам меню
    for ((i = 0; i < ${#menuItems[*]}; i += 2)); do
    # Преобразуем цвет фона в эскейп последовательность
        case "${menuItems[$i]}" in
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
            printf ' %b ' "${menuItems[$i+1]}"
            
        # Ширина фона (отступ)
            printf '%b' "$(char $(( $length - ${#menuItems[$i+1]} )) ' ')"
            
        # Сброс цвета
            printf '%b' "$color0"
            
    # Пункт меню НЕ выбран
        else
        # Текст
            printf ' %b ' "${menuItems[$i+1]}"
        fi
        
    # Переносим строку
        printf '\n'
    done
    
# Удаляем все символы до конца строки
    printf '\e[K'
    
# Восстанавливаем позицию курсора
    printf '\e[u'
    
# Локальные переменные
    local keyPageDown=`printf '\e[B'`
    local keyPageUp=`printf '\e[A'`
    local keyEnter=`printf '\n'`
    local keyESC=`printf '\e'`
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
        "$keyESC" | '`' | 'q' | 0)
        # Эмуляция двойного нажатия
            if [[ $selection == $count ]]; then
                REPLY=$count
                return
            fi
            selection=$count
        ;;
        
    # Up
        "$keyPageUp")
            if (( $selection > 1 )); then
                let 'selection--'
            else
                selection=$count
            fi
        ;;
        
    # Down
        "$keyPageDown")
            if (( $selection < $count )); then
                let 'selection++'
            else
                selection=1
            fi
        ;;
        
    # Цифры от 1 до 9
        [1-9])
            if (( $count > $key )); then
            # Эмуляция двойного нажатия
                if [[ $selection == $key ]]; then
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
}

#┌───────┐
#│ Выход │
#└───────┘
menu:Exit() {
# Очищаем экран
    reset
    
# Выводим сообщение об успешном завершении
    echo 'Вам всего доброго, счастья, здоровья и хорошего настроения!'
    
# Завершаем процесс
    exit
}

#┌───────────────────────────┐
#│ Добавляет новое сообщение │
#└───────────────────────────┘
menu:Msg() {
    menuMessages=("$1" "$2")
}

#┌────────────────────────────────────┐
#│ Добавляет еще одно новое сообщение │
#└────────────────────────────────────┘
menu:MsgAdd() {
    menuMessages+=("$1" "$2")
}

#┌──────────────────────────────┐
#│ Выводит уведомление на экран │
#└──────────────────────────────┘
menu:Notice() {
# Тип сообщения
    local type="$1"
    
# Удаляем первый аргумент
    shift
    
# Список типов сообщений
    case "$type" in
        'info')      menu:Msg 'Blue'   "$(notice:Card "$@")"     ;; # Информационное сообщение
        'success')   menu:Msg 'Green'  "$(notice:Card "$@")"     ;; # Сообщение об успешном завершении
        'warning')   menu:Msg 'Yellow' "$(notice:Card "$@")"     ;; # Сообщение с предупреждением
        'error')     menu:Msg 'Red'    "$(notice:Error "$@")"    ;; # Сообщение об ошибке
        'error_log') menu:Msg 'Red'    "$(notice:Errorlog "$@")" ;; # Сообщение со списком ошибок
    esac
    
# Обнуляем сохраненные состояния пунктов меню
    menuState=()
}
