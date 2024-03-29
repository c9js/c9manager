#▄───────────────────────────────▄
#█                               █
#█  Navigator: Edit              █
#█  • Редактировать (навигатор)  █
#█                               █
#▀───────────────────────────────▀
navigator:Edit() { case "$1" in
#┌───────────────┐
#│ Инициализация │
#└───────────────┘
    'init')
    # Создаем заголовок меню
        HEADER='Выберите команду:'
    ;;
    
#┌──────────────────────────────────────────┐
#│ Предлагает пользователю исправить ошибку │
#└──────────────────────────────────────────┘
    'error')
    # Выводим меню на экран
        menu "$HEADER" 1
        #   Цвет      Строка
            Green '1. Ошибка исправлена, можно продолжить.'
             Exit '0. Exit'
             
    # Проходим по пунктам меню
        case $? in
            0) nav:Exit ;; # Выбран: "Exit"
        esac
    ;;
    
#┌─────────┐
#│ Главная │
#└─────────┘
    'main')
    # Выводим меню на экран
        menu "$HEADER" 1
        #   Цвет      Строка
            Green '1. Редактировать описание (выбрать коммит)'
            Green '2. Изменить дату создания (выбрать коммит)'
             Exit '0. Exit'
             
    # Проходим по пунктам меню
        case $? in
            0)        nav:Exit    ;; # Выбран: "Exit"
            *) controller:Edit $? ;; # Выбран: "Другой пункт"
        esac
    ;;
    
#┌──────────────────────────────────────────────┐
#│ Выводит список пунктов (для выбранного меню) │
#└──────────────────────────────────────────────┘
    'pages:Menu')
    # Выводим меню на экран
        menu 'Выберите коммит который хотите отредактировать:' "$PAGES_SELECT"
        #   Цвет   Строка
            Green "${@:2}"
             Exit 'Вернуться'
             
    # Проходим по пунктам меню
        case $? in
            0)   nav:Main    ;; # Выбран: "Вернуться"
            *) pages:Pick $? ;; # Выбран: "Другой пункт"
        esac
    ;;
    
#┌───────────────────────────────────────────────────────────────────────────┐
#│ Предлагает пользователю подтвердить редактирование "Дата созданя коммита" │
#└───────────────────────────────────────────────────────────────────────────┘
    'confirm_date')
    # Выводим уведомление (если других уведомлений еще не было)
        success:low \
        'Текущая дата создания коммита:' \
        "'$CURRENT_DATE'"
        
    # Выводим меню на экран
        menu "$HEADER" 1
        #   Цвет      Строка
            Green "1. Изменить дату на $NEW_DATE"
             Exit '0. Отмена'
             
    # Проходим по пунктам меню
        case $? in
            1) controller:Edit 'run' ;; # Выбран: "Изменить"
            0)      pages:Back       ;; # Выбран: "Отмена"
        esac
    ;;
    
#┌───────────────────────────────────────────────────────────────────────┐
#│ Предлагает пользователю подтвердить редактирование "Описание коммита" │
#└───────────────────────────────────────────────────────────────────────┘
    'confirm_edit')
    # Выводим уведомление (если других уведомлений еще не было)
        success:low \
        'Текущее описание:' \
        "'$CURRENT_TEXT'"
        
    # Выводим меню на экран
        menu "$HEADER" 1
        #   Цвет      Строка
            Green '1. Редактировать описание'
             Exit '0. Отмена'
             
    # Проходим по пунктам меню
        case $? in
            1)   nav:Next 'edit' ;; # Выбран: "Редактировать"
            0) pages:Back        ;; # Выбран: "Отмена"
        esac
    ;;
    
#┌────────────────────────────────────────────────────────┐
#│ Предлагает пользователю указать новое описание коммита │
#└────────────────────────────────────────────────────────┘
    'edit')
    # Очищаем экран
        reset
        
    # Выводим заголовок
        echo 'Введите описание коммита:'
        
    # Предлагаем указать описание коммита
        input "$CURRENT_TEXT" 'git:isValidMessage' "Описание '%s' указано не верно!"
        
    # Сохраняем описание коммита
        controller:Edit 'run' "$REPLY"
    ;;
esac
}
