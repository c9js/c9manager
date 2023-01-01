#▄──────────────────────▄
#█                      █
#█  View: Menu          █
#█  • Меню (интерфейс)  █
#█                      █
#▀──────────────────────▀
view:Menu() { case "$1" in
#┌────────────────────────┐
#│ Создает заголовок меню │
#└────────────────────────┘
    'header') HEADER='Выберите команду:' ;;
    
#┌─────────────────────────────────────────────┐
#│ Предлагает пользователю попробовать еще раз │
#└─────────────────────────────────────────────┘
    'bad_deploy')
    # Выводим меню на экран
        menu "$HEADER" 1
        #   Цвет     Строка
             Red '1. Continue   Попробовать еще раз'
             Red '2. Настройки  Перейти в раздел'
            Exit '0. Отмена'
             
    # Проходим по пунктам меню
        case $? in
            1) controller:Deploy 'continue' ;; # Выбран: "Continue"
            2)       view:Menu   'settings' ;; # Выбран: "Настройки"
            0) controller:Deploy 'stop'     ;; # Выбран: "Отмена"
        esac
    ;;
    
#┌─────────┐
#│ Главная │
#└─────────┘
    'main')
    # Выводим меню на экран
        menu "$HEADER" 1
        #   Цвет      Строка
            Green '1. Deploy     Выбрать репозиторий'
            Green '2. Настройки  Перейти в раздел'
             Exit '0. Exit'
             
    # Проходим по пунктам меню
        case $? in
            1) view:Menu 'deploy'   ;; # Выбран: "Deploy"
            2) view:Menu 'settings' ;; # Выбран: "Настройки"
            0) menu:Exit            ;; # Выбран: "Exit"
        esac
    ;;
    
#┌──────────────────────────────────────────────────────────┐
#│ Предлагает пользователю выбрать один из вариантов деплоя │
#└──────────────────────────────────────────────────────────┘
    'deploy')
    # Выводим меню на экран
        menu "$HEADER" 0
        #   Цвет      Строка
            Green '1. Deploy → docker + git'
            Green '2. Deploy → docker'
            Green '3. Deploy → git'
             Exit '0. Отмена'
             
    # Проходим по пунктам меню
        case $? in
            1) view:Menu 'version1' 1      ;; # Выбран: "Docker + Git"
            2) view:Menu 'version2' 3 "$1" ;; # Выбран: "Docker"
            3) view:Menu 'version2' 2 "$1" ;; # Выбран: "Git"
            0) menu:Main                   ;; # Выбран: "Отмена"
        esac
    ;;
    
#┌──────────────────────────────────────────────┐
#│ Предлагает пользователю выбрать micro-версию │
#└──────────────────────────────────────────────┘
    'version1')
    # Выводим меню на экран
        menu "$HEADER" 1
        #   Цвет      Строка
            Green "1. Micro (новая версия '$MICRO')"
            Green '2. Изменить версию'
             Exit '0. Отмена'
             
    # Проходим по пунктам меню
        case $? in
            1) controller:Deploy 'start' "$2" "$MICRO" ;; # Выбран: "Micro"
            2)       view:Menu   'version2' "$2" "$1"  ;; # Выбран: "Изменить версию"
            0)       view:Menu   'deploy'              ;; # Выбран: "Отмена"
        esac
    ;;
    
#┌──────────────────────────────────────────────────────────┐
#│ Предлагает пользователю выбрать версию из списква версий │
#└──────────────────────────────────────────────────────────┘
    'version2')
    # Выводим меню на экран
        menu "$HEADER" 0
        #   Цвет      Строка
            Green "1. Оставить текущую версию '$VERSION'"
            Green "2. Увеличить до '$MICRO' (micro)"
            Green "3. Увеличить до '$MINOR' (minor)"
            Green "4. Увеличить до '$MAJOR' (major)"
             Exit '0. Отмена'
             
    # Проходим по пунктам меню
        case $? in
            1) controller:Deploy 'start' "$2" "$VERSION" ;; # Выбран: "Current"
            2) controller:Deploy 'start' "$2" "$MICRO"   ;; # Выбран: "Micro"
            3) controller:Deploy 'start' "$2" "$MINOR"   ;; # Выбран: "Minor"
            4) controller:Deploy 'start' "$2" "$MAJOR"   ;; # Выбран: "Major"
            0)       view:Menu "$3" "$2"                 ;; # Выбран: "Отмена"
        esac
    ;;
    
#┌───────────┐
#│ Настройки │
#└───────────┘
    'settings')
    # Выводим меню на экран
        menu "$HEADER" 0
        #   Цвет      Строка
            Green "1. Git     Редактировать $GIT_USER:$GIT_REPO"
            Green "2. Docker  Редактировать $DOCKER_USER:$DOCKER_PASS_HIDDEN"
             Exit '0. Назад'
             
    # Проходим по пунктам меню
        case $? in
            1) view:Menu 'input_git_user'    ;; # Выбран пункт: "Git"
            2) view:Menu 'input_docker_user' ;; # Выбран пункт: "Docker"
            0) menu:Main                     ;; # Выбран пункт: "Назад"
        esac
    ;;
    
#┌───────────────────────────────────────────────┐
#│ Предлагает пользователю указать имя git-юзера │
#└───────────────────────────────────────────────┘
    'input_git_user')
    # Очищаем экран
        reset
        
    # Выводим заголовок
        echo 'Введите имя git-юзера:'
        
    # Предлагаем указать имя git-юзера
        input "$GIT_USER" 'git:isValidUser' "Имя '%s' указано не верно!"
        
    # Предлагаем пользователю указать имя git-репозитория
        view:Menu 'input_git_repo' "$REPLY"
    ;;
    
#┌─────────────────────────────────────────────────────┐
#│ Предлагает пользователю указать имя git-репозитория │
#└─────────────────────────────────────────────────────┘
    'input_git_repo')
    # Очищаем экран
        reset
        
    # Выводим заголовок
        echo 'Введите имя git-репозитория:'
        
    # Предлагаем указать имя git-репозитория
        input "$GIT_REPO" 'git:isValidRepo' "Имя '%s' указано не верно!"
        
    # Сохраняем настройки git-репозитория
        controller:Settings 'save_git' "$2" "$REPLY"
    ;;
    
#┌─────────────────────────────────────────────────────────────┐
#│ Предлагает пользователю указать логин от docker-репозитория │
#└─────────────────────────────────────────────────────────────┘
    'input_docker_user')
    # Очищаем экран
        reset
        
    # Выводим заголовок
        echo 'Введите логин от docker-репозитория:'
        
    # Предлагаем указать логин от docker-репозитория
        input "$DOCKER_USER" 'docker:isValidUser' "Логин '%s' указано не верно!"
        
    # Предлагаем пользователю указать пароль от docker-репозитория
        view:Menu 'input_docker_pass' "$REPLY"
    ;;
    
#┌──────────────────────────────────────────────────────────────┐
#│ Предлагает пользователю указать пароль от docker-репозитория │
#└──────────────────────────────────────────────────────────────┘
    'input_docker_pass')
    # Очищаем экран
        reset
        
    # Выводим заголовок
        echo 'Введите пароль от docker-репозитория:'
        
    # Предлагаем указать пароль от docker-репозитория
        input "$DOCKER_PASS" 'docker:isValidPass' "Пароль '%s' указан не верно!"
        
    # Сохраняем настройки docker-репозитория
        controller:Settings 'save_docker' "$2" "$REPLY"
    ;;
esac
}