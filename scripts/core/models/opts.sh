#▄─────────────────────▄1.0.0
#█                     █
#█  Список переменных  █
#█                     █
#▀─────────────────────▀
declare -A OPTS_DIFF=() # Список опций (для нескольких вариантов одной опции)
declare -a OPTS_LIST=() # Список опций (для конфигурации)
declare -A OPTS_SEARCH  # Список опций (для поиска)
declare -A OPTS         # Список опций
declare -a ARGS         # Список аргументов

#▄──────────────────────────────▄
#█                              █
#█  Core: Opts                  █
#█  • Опции и аргументы (ядро)  █
#█                              █
#▀──────────────────────────────▀
core:Opts() { case "$1" in
#┌───────────────────────────────────────────────────────────┐
#│ Проверяет аргумент (возвращает противоположный результат) │
#└───────────────────────────────────────────────────────────┘
    'no_arg')
        ! [ -n "${ARGS[$2]+1}" ]
    ;;
    
#┌────────────────────┐
#│ Проверяет аргумент │
#└────────────────────┘
    'is_arg')
        [ -n "${ARGS[$2]+1}" ]
    ;;
    
#┌────────────────────────────┐
#│ Выводит значение аргумента │
#└────────────────────────────┘
    'arg')
        echo "${ARGS[$2]}"
    ;;
    
#┌────────────────────────────────────────────────────────┐
#│ Проверяет опцию (возвращает противоположный результат) │
#└────────────────────────────────────────────────────────┘
    'no_opt')
        ! [ -n "${OPTS[$2]+1}" ]
    ;;
    
#┌─────────────────┐
#│ Проверяет опцию │
#└─────────────────┘
    'is_opt')
        [ -n "${OPTS[$2]+1}" ]
    ;;
    
#┌────────────────────────┐
#│ Выводит значение опции │
#└────────────────────────┘
    'opt')
        echo "${OPTS[$2]}"
    ;;
    
#┌───────────────────────┐
#│ Добавляет новую опцию │
#└───────────────────────┘
    'add')
    # Добавляем новую опцию
        OPTS_LIST+=("${@:2}")
        
    # Передано менее двух опций
        (( $# < 3 )) && return
        
    # Локальные переменные
        local opts=() # Список опций
        local opt     # Текущая опция
        
    # Проходим по списку опций (для нескольких вариантов одной опции)
        for opt in "${@:2}"; do
        # У опции есть аргумент
            if [[ "${opt:(-1)}" == ':' ]]; then
            # Удаляем последний символ
                opt="${opt:0:(-1)}"
            fi
            
        # Добавляем текущую опцию в список опций
            opts+=("$opt")
        done
        
    # Проходим по списку опций (для нескольких вариантов одной опции)
        for opt in "${opts[@]}"; do
        # Добавляем список вариантов
            OPTS_DIFF[$opt]="${opts[*]}"
        done
    ;;
    
#┌───────────────────────────────────┐
#│ Создает список опций (для поиска) │
#└───────────────────────────────────┘
    'search')
    # Обнуляем список опций (для поиска)
        OPTS_SEARCH=()
        
    # Обнуляем список опций
        OPTS=()
        
    # Обнуляем список аргументов
        ARGS=()
        
    # Текущая опция
        local opt
        
    # Проходим по списку опций (конфигурация)
        for opt in "${OPTS_LIST[@]}"; do
        # У опции есть аргумент
            if [[ "${opt:(-1)}" == ':' ]]; then
                OPTS_SEARCH["${opt:0:(-1)}"]=1
                
        # У опции нет аргументов
            else
                OPTS_SEARCH[$opt]=0
            fi
        done
    ;;
    
#┌───────────────────────────────────┐
#│ Создает список опций и аргументов │
#└───────────────────────────────────┘
    'set')
    # Создаем список опций (для поиска)
        core:Opts 'search'
        
    # Локальные переменные
        local arg  # Текущий аргумент
        local next # Следующий аргумент
        local skip # Пропуск следующего аргумента
        local end  # Окончание всех опций
        local i
        
    # Проходим по списку аргументов
        for ((i = 2; i <= $#; i++)); do
        # Сохраняем текущий аргумент
            arg="${!i}"
            
        # Сохраняем следующий аргумент
            let next=$i+1
            next="${!next}"
            
        # Включаем окончание всех опций
            if [ "$arg" == '--' ]; then
                end=1
                continue
            fi
            
        # Проверяем включено-ли окончание всех опций
            if [ -n "$end" ]; then
            # Добавляем новый аргумент в список аргументов
                ARGS+=("$arg")
                continue
            fi
            
        # Сохраняем короткие опции
            core:Opts 'short' "$arg" "$next"
            
        # Сохраняем будет-ли пропуск следующего аргумента
            skip=$?
            
        # Проверяем будет-ли пропуск следующего аргумента
            if [ $skip != 2 ]; then
            # Пропускаем следующий аргумент
                let i+=$skip
                continue
            fi
            
        # Сохраняем длинные опции
            core:Opts 'long' "$arg" "$next"
            
        # Сохраняем будет-ли пропуск следующего аргумента
            skip=$?
            
        # Проверяем будет-ли пропуск следующего аргумента
            if [ $skip != 2 ]; then
            # Пропускаем следующий аргумент
                let i+=$skip
                continue
            fi
            
        # Добавляем новый аргумент в список аргументов
            ARGS+=("$arg")
        done
    ;;
    
#┌──────────────────────────┐
#│ Сохраняет короткие опции │
#└──────────────────────────┘
    'short')
    # Список аргументов
        local arg="$2"  # Текущий аргумент
        local next="$3" # Следующий аргумент
        
    # Длина аргумента менее двух символов
        (( ${#arg} < 2 )) && return 2
        
    # Первый символ это не тире "-"
        [[ "${arg:0:1}" != '-' ]] && return 2
        
    # Второй символ это тире "-"
        [[ "${arg:1:1}" == '-' ]] && return 2
        
    # Локальные переменные
        local opt # Текущая опция
        local j=0 # Отступ для нового аргумента
        local i
        
    # Проходим по списку опций
        for ((i = 1; i < ${#arg}; i++)); do
        # Сохраняем текущую опцию
            opt="${arg:$i:1}"
            
        # Такой опции не существует
            if [ -z "${OPTS_SEARCH[$opt]}" ]; then
            # Добавляем новый аргумент в список аргументов
                ARGS+=("${arg:$j}")
                return 0
            fi
            
        # У опции нет аргументов
            if [[ "${OPTS_SEARCH[$opt]}" == 0 ]]; then
            # Добавляем новую опцию в список опций
                OPTS[$opt]=''
                
            # Кешируем другие варианты текущей опции
                core:Opts 'set_others' "$opt"
                
            # Добавляем отступ для нового аргумента
                let j=$i+1
                
            # Переходим к следующей опции
                continue
            fi
            
        # Между опцией и аргументом есть разделитель (например пробел)
            if (( ${#arg} == $i+1 )); then
            # Добавляем новую опцию и аргумент в список опций
                OPTS[$opt]="$next"
                
            # Кешируем другие варианты текущей опции
                core:Opts 'set_others' "$opt"
                
            # Команда успешно выполнена
                    return 1
            fi
            
        # Добавляем новую опцию и аргумент в список опций
            OPTS[$opt]="${arg:($i+1)}"
            
        # Кешируем другие варианты текущей опции
            core:Opts 'set_others' "$opt"
            
        # Команда успешно выполнена
            return 0
        done
        
    # Команда успешно выполнена
       return 0
    ;;
    
#┌─────────────────────────┐
#│ Сохраняет длинные опции │
#└─────────────────────────┘
    'long')
    # Список аргументов
        local arg="$2"  # Текущий аргумент
        local next="$3" # Следующий аргумент
        
    # Длина аргумента менее четырех символов
        (( ${#arg} < 4 )) && return 2
        
    # Первый и второй символы это не тире "-"
        [[ "${arg:0:2}" != '--' ]] && return 2
        
    # Сохраняем текущую опцию
        local opt="${arg:2}"
        
    # Такой опции не существует
        if [ -z "${OPTS_SEARCH[$opt]}" ]; then
        # Добавляем новый аргумент в список аргументов
            ARGS+=("$arg")
            return 0
        fi
        
    # У опции нет аргументов
        if [[ "${OPTS_SEARCH[$opt]}" == 0 ]]; then
        # Добавляем новую опцию в список опций
            OPTS[$opt]=''
            
        # Кешируем другие варианты текущей опции
            core:Opts 'set_others' "$opt"
            
        # Команда успешно выполнена
            return 0
        fi
        
    # Добавляем новую опцию и аргумент в список опций
        OPTS[$opt]="$next"
        
    # Кешируем другие варианты текущей опции
        core:Opts 'set_others' "$opt"
        
    # Команда успешно выполнена
        return 1
    ;;
    
#┌────────────────────────────────────────┐
#│ Кеширует другие варианты текущей опции │
#└────────────────────────────────────────┘
    'set_others')
    # Список аргументов
        local opt="$2" # Текущая опция
        
    # Для опции не предусмотренны другие варианты
        [ -z "${OPTS_DIFF[$opt]}" ] && return
        
    # Локальные переменные
        local others # Список других опций
        local other  # Другая опция
        
    # Получаем список других опций
        read -a others <<< "${OPTS_DIFF[$opt]}"
        
    # Проходим по списку других опций
        for other in "${others[@]}"; do
        # Добавляем другую опцию в список опций
            OPTS[$other]="${OPTS[$opt]}"
        done
    ;;
    
#┌────────────────────────────────────────────┐
#│ Выводит дамп со списком опций и аргументов │
#└────────────────────────────────────────────┘
    'dump')
    # Выводим дамп со списком аргументов
        echo '───────────'
        echo 'RESULT_ARGS'
        
    # Текущий аргумент
        local arg
        
    # Проходим по списку аргументов
        for arg in "${ARGS[@]}"; do
        # Выводим аргумент
            echo "'$arg'"
        done
        
    # Отступ
        echo
        
    # Выводим дамп со списком опций
        echo '───────────'
        echo 'RESULT_OPTS'
        
    # Текущая опция
        local opt
        
    # Проходим по списку опций
        for opt in "${!OPTS[@]}"; do
        # Выводим опцию
            echo "'$opt=${OPTS[$opt]}'"
        done
    ;;
esac
}
