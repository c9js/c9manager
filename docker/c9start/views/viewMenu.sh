#▄──────────────────────▄
#█                      █
#█  View: Menu          █
#█  • Меню (интерфейс)  █
#█                      █
#▀──────────────────────▀
view:Menu() { menu:Save "$1"; case "$1" in
#┌────────────────────────┐
#│ Создает заголовок меню │
#└────────────────────────┘
    'header') HEADER='Выберите команду:' ;;
    
#┌────────────────────────────────────────────────┐
#│ Предлагает пользователю выбрать пустой каталог │
#└────────────────────────────────────────────────┘
    'dir_error')
    # Выводим меню на экран
        menu "$HEADER" 1
        #   Цвет      Строка
            Green "1. Обновить (git clone '$GIT_URL/$GIT_USER/$GIT_REPO')"
             Exit '0. Exit'
             
    # Проходим по пунктам меню
        case $? in
            1) controller:Git 'gitclone' ;; # Выбран пункт: "Обновить"
            0)       menu:Exit           ;; # Выбран пункт: "Exit"
        esac
    ;;
    
#┌──────────────────────────────────────────────────┐
#│ Предлагает пользователю склонировать репозиторий │
#└──────────────────────────────────────────────────┘
    'gitclone')
    # Выводим меню на экран
        menu "$HEADER" 1
        #   Цвет      Строка
            Green "1. Git clone '$GIT_URL/$GIT_USER/$GIT_REPO'"
             Exit '0. Exit'
             
    # Проходим по пунктам меню
        case $? in
            1) controller:Git 'gitclone' ;; # Выбран пункт: "Git clone"
            0)       menu:Exit           ;; # Выбран пункт: "Exit"
        esac
    ;;
    
#┌──────────────────────────────────────┐
#│ Предлагает пользователю выбрать порт │
#└──────────────────────────────────────┘
    'choice_port')
    # Список аргументов
        local command="$2" # Выбранная команда
        
    # Выводим меню на экран
        menu 'Выберите порт:' 1
        #   Цвет      Строка
            Green "1. $PORT_DEFAULT (по умолчанию)"
            Green '2. Редактировать'
             Exit '0. Отмена'
             
    # Проходим по пунктам меню
        case $? in
            1) controller:Docker "$command" "$PORT_DEFAULT" ;; # Выбран пункт: "По умолчанию"
            2)       menu:Next 'input_port' "$command"      ;; # Выбран пункт: "Редактировать"
            0)       menu:Back                              ;; # Выбран пункт: "Отмена"
        esac
    ;;
    
#┌──────────────────────────────────────────────┐
#│ Предлагает пользователю указать порт вручную │
#└──────────────────────────────────────────────┘
    'input_port')
    # Список аргументов
        local command="$2" # Выбранная команда
        
    # Очищаем экран
        reset
        
    # Выводим заголовок
        echo 'Введите порт:'
        
    # Предлагаем указать порт
        input "$PORT_DEFAULT" 'isValidPort' "Порт '%s' указан не верно!"
        
    # Запускаем новый контейнер
        controller:Docker "$command" "$REPLY"
    ;;
    
#┌──────────────────────────────────────────┐
#│ Предлагает пользователю установить образ │
#└──────────────────────────────────────────┘
    'install')
    # Выводим меню на экран
        menu "$HEADER" 1
        #   Цвет      Строка
            Green "1. Install  Установить '$IMAGE_RUN:$VERSION'"
             Exit '0. Exit'
             
    # Проходим по пунктам меню
        case $? in
            1) menu:Next 'choice_port' "$1" ;; # Выбран пункт: "Install"
            0) menu:Exit                    ;; # Выбран пункт: "Exit"
        esac
    ;;
    
#┌─────────────────────────────────────────────┐
#│ Предлагает пользователю запустить контейнер │
#└─────────────────────────────────────────────┘
    'start')
    # Выводим меню на экран
        menu "$HEADER" 1
        #   Цвет      Строка
            Green "1. Start      Запустить '$IMAGE_RUN:$VERSION'"
            Green '2. Настройки  Перейти в раздел'
             Exit '0. Exit'
             
    # Проходим по пунктам меню
        case $? in
            1) menu:Next 'choice_port' "$1" ;; # Выбран пункт: "Start"
            2) menu:Next 'settings'         ;; # Выбран пункт: "Настройки"
            0) menu:Exit                    ;; # Выбран пункт: "Exit"
        esac
    ;;
    
#┌─────────────────────────────────────────────────┐
#│ Предлагает пользователю перезагрузить контейнер │
#└─────────────────────────────────────────────────┘
    'restart')
    # Выводим меню на экран
        menu "$HEADER" 1
        #   Цвет      Строка
            Green "1. Restart    Перезагрузить '$IMAGE_RUN:$VERSION'"
            Green "2. Stop       Остановить '$IMAGE_RUN:$VERSION'"
            Green '3. Настройки  Перейти в раздел'
             Exit '0. Exit'
             
    # Проходим по пунктам меню
        case $? in
            1)       menu:Next 'choice_port' "$1" ;; # Выбран пункт: "Restart"
            2) controller:Docker 'stop'           ;; # Выбран пункт: "Stop"
            3)       menu:Next 'settings'         ;; # Выбран пункт: "Настройки"
            0)       menu:Exit                    ;; # Выбран пункт: "Exit"
        esac
    ;;
    
#┌────────────────────────────────────────────┐
#│ Предлагает пользователю обновить контейнер │
#└────────────────────────────────────────────┘
    'update')
    # Выводим меню на экран
        menu "$HEADER" 1
        #   Цвет      Строка
            Green "1. Update     Обновить до '$IMAGE_RUN:$VERSION'"
              Red '2. Uninstall  Удалить все образы'
            Green '3. Настройки  Перейти в раздел'
             Exit '0. Exit'
             
    # Проходим по пунктам меню
        case $? in
            1)       menu:Next 'choice_port' "$1" ;; # Выбран пункт: "Update"
            2) controller:Docker 'remove_all'     ;; # Выбран пункт: "Uninstall"
            3)       menu:Next 'settings'         ;; # Выбран пункт: "Настройки"
            0)       menu:Exit                    ;; # Выбран пункт: "Exit"
        esac
    ;;
    
#┌───────────┐
#│ Настройки │
#└───────────┘
    'settings')
    # Выводим меню на экран
        menu "$HEADER" 0
        #   Цвет      Строка
            Green '1. SSH-Keygen  Перейти в раздел'
            Green '2. Uninstall   Перейти в раздел'
             Exit '0. Назад'
             
    # Проходим по пунктам меню
        case $? in
            1) menu:Next 'ssh_keygen' ;; # Выбран пункт: "SSH-Keygen"
            2) menu:Next 'uninstall'  ;; # Выбран пункт: "Uninstall"
            0) menu:Back              ;; # Выбран пункт: "Назад"
        esac
    ;;
    
#┌────────────────────────────────────────────┐
#│ Предлагает пользователю удалить все образы │
#└────────────────────────────────────────────┘
    'uninstall')
    # Выводим меню на экран
        menu "$HEADER" 0
        #   Цвет     Строка
             Red '1. Stop    Остановить все контейнеры'
             Red '2. Remove  Удалить все образы'
            Exit '0. Назад'
            
    # Проходим по пунктам меню
        case $? in
            1) controller:Docker 'stop_all'   ;; # Выбран пункт: "Stop"
            2) controller:Docker 'remove_all' ;; # Выбран пункт: "Remove"
            0)       menu:Back                ;; # Выбран пункт: "Назад"
        esac
    ;;
    
#┌────────────────────────────────────────────────┐
#│ Предлагает пользователю создать новый SSH-ключ │
#└────────────────────────────────────────────────┘
    'ssh_keygen')
    # Выводим меню на экран
        menu "$HEADER" 0
        #   Цвет      Строка
            Green '1. SSH-Keygen  Создать новый SSH-ключ'
             Exit '0. Назад'
             
    # Проходим по пунктам меню
        case $? in
            1) menu:Next 'input_ssh' ;; # Выбран пункт: "Создать"
            0) menu:Back             ;; # Выбран пункт: "Назад"
        esac
    ;;
    
#┌─────────────────────────────────────────────────────────┐
#│ Предлагает пользователю указать имя файла для SSH-ключа │
#└─────────────────────────────────────────────────────────┘
    'input_ssh')
    # Очищаем экран
        reset
        
    # Выводим заголовок
        echo 'Введите имя файла для SSH-ключа:'
        
    # Предлагаем указать имя файла
        input "$GIT_USER" 'git:isValidUser' "Имя файла '%s' указано не верно!"
        
    # Создаем новый SSH-ключ
        controller:SSH 'ssh_keygen' "$REPLY"
    ;;
esac
}
