#▄──────────────────────────────▄
#█                              █
#█  Navigator: Start            █
#█  • Первый старт (навигатор)  █
#█                              █
#▀──────────────────────────────▀
navigator:Start() { case "$1" in
#┌───────────────┐
#│ Инициализация │
#└───────────────┘
    'init')
    # Создаем заголовок меню
        HEADER='Выберите команду:'
    ;;
    
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
            1) controller:Git 'gitclone' ;; # Выбран: "Обновить"
            0)        nav:Exit           ;; # Выбран: "Exit"
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
            1) controller:Git 'gitclone' ;; # Выбран: "Git clone"
            0)        nav:Exit           ;; # Выбран: "Exit"
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
            Green "1. $PORT_PUBLIC (по умолчанию)"
            Green '2. Редактировать'
             Exit '0. Отмена'
             
    # Проходим по пунктам меню
        case $? in
            1) controller:Docker "$command" "$PORT_PUBLIC" ;; # Выбран: "По умолчанию"
            2)        nav:Next 'input_port' "$command"     ;; # Выбран: "Редактировать"
            0)        nav:Back                             ;; # Выбран: "Отмена"
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
        input "$PORT_PUBLIC" 'isValidPort' "Порт '%s' указан не верно!"
        
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
            Green "1. Install  Установить '$IMAGE_START:$VERSION'"
             Exit '0. Exit'
             
    # Проходим по пунктам меню
        case $? in
            1) nav:Next 'choice_port' "$1" ;; # Выбран: "Install"
            0) nav:Exit                    ;; # Выбран: "Exit"
        esac
    ;;
    
#┌─────────────────────────────────────────────┐
#│ Предлагает пользователю запустить контейнер │
#└─────────────────────────────────────────────┘
    'start')
    # Выводим меню на экран
        menu "$HEADER" 1
        #   Цвет      Строка
            Green "1. Start      Запустить '$IMAGE_START:$VERSION'"
            Green '2. Настройки  Перейти в раздел'
             Exit '0. Exit'
             
    # Проходим по пунктам меню
        case $? in
            1) nav:Next 'choice_port' "$1" ;; # Выбран: "Start"
            2) nav:Next 'settings'         ;; # Выбран: "Настройки"
            0) nav:Exit                    ;; # Выбран: "Exit"
        esac
    ;;
    
#┌─────────────────────────────────────────────────┐
#│ Предлагает пользователю перезагрузить контейнер │
#└─────────────────────────────────────────────────┘
    'restart')
    # Выводим меню на экран
        menu "$HEADER" 1
        #   Цвет      Строка
            Green "1. Restart    Перезагрузить '$IMAGE_START:$VERSION'"
            Green "2. Stop       Остановить '$IMAGE_START:$VERSION'"
            Green '3. Настройки  Перейти в раздел'
             Exit '0. Exit'
             
    # Проходим по пунктам меню
        case $? in
            1)        nav:Next 'choice_port' "$1" ;; # Выбран: "Restart"
            2) controller:Docker 'stop'           ;; # Выбран: "Stop"
            3)        nav:Next 'settings'         ;; # Выбран: "Настройки"
            0)        nav:Exit                    ;; # Выбран: "Exit"
        esac
    ;;
    
#┌────────────────────────────────────────────┐
#│ Предлагает пользователю обновить контейнер │
#└────────────────────────────────────────────┘
    'update')
    # Выводим меню на экран
        menu "$HEADER" 1
        #   Цвет      Строка
            Green "1. Update     Обновить до '$IMAGE_START:$VERSION'"
              Red '2. Uninstall  Удалить все образы'
            Green '3. Настройки  Перейти в раздел'
             Exit '0. Exit'
             
    # Проходим по пунктам меню
        case $? in
            1)        nav:Next 'choice_port' "$1" ;; # Выбран: "Update"
            2) controller:Docker 'remove_all'     ;; # Выбран: "Uninstall"
            3)        nav:Next 'settings'         ;; # Выбран: "Настройки"
            0)        nav:Exit                    ;; # Выбран: "Exit"
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
            1) nav:Next 'ssh_keygen' ;; # Выбран: "SSH-Keygen"
            2) nav:Next 'uninstall'  ;; # Выбран: "Uninstall"
            0) nav:Back              ;; # Выбран: "Назад"
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
            1) controller:Docker 'stop_all'   ;; # Выбран: "Stop"
            2) controller:Docker 'remove_all' ;; # Выбран: "Remove"
            0)        nav:Back                ;; # Выбран: "Назад"
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
            1) nav:Next 'input_ssh' ;; # Выбран: "Создать"
            0) nav:Back             ;; # Выбран: "Назад"
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
