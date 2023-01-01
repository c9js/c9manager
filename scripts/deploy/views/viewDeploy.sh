#▄───────────────────────▄
#█                       █
#█  Список общих команд  █
#█                       █
#▀───────────────────────▀
GENERAL_LIST=(
# Общие команды
    'is_new_version' # Проверяет новую версию
    'save_version'   # Сохраняет новую версию
)

#▄─────────────────────────────────────▄
#█                                     █
#█  Список команд для git-репозитория  █
#█                                     █
#▀─────────────────────────────────────▀
GIT_LIST=(
# Авторизация
    'cd_workspace'   # Переходит в рабочий каталог
    'is_git_user'    # Проверяет имя git-юзера
    'is_git_repo'    # Проверяет имя git-репозитория
    'git_login'      # Проверяет авторизацию в git-репозиторий
    
# Контройльная точка
    'no_stop'        # После этого момента деплой уже не отменить
    
# Загрузка в репозиторий
    'git_add'        # Добавляет рабочий каталог в индекс
    'git_commit'     # Создает новый коммит
    'git_push'       # Загружает коммит в git-репозиторий
    
# Создание тегов
    'tag_remove'     # Удаляет старый тег из git-репозитория
    'tag_create'     # Создает тег для новой версии
    'tag_push'       # Загружает тег в git-репозиторий
)

#▄────────────────────────────────────────▄
#█                                        █
#█  Список команд для docker-репозитория  █
#█                                        █
#▀────────────────────────────────────────▀
DOCKER_LIST=(
# Авторизация
    'is_docker_user' # Проверяет логин от docker-репозитория
    'is_docker_pass' # Проверяет пароль от docker-репозитория
    'docker_login'   # Проходит авторизацию в docker-репозиторий
    
# Создание образов
    'build:c9open'   # Создает новый образ
    'build:c9start'  # Создает новый образ
    'build:c9docker' # Создает новый образ
    
# Контройльная точка
    'no_stop'        # После этого момента деплой уже не отменить
)
PUSH_LIST=(
# Создание тегов
    'tag1:c9open'    # Создает тег для новой версии
    'tag1:c9start'   # Создает тег для новой версии
    'tag1:c9docker'  # Создает тег для новой версии
    'tag2:c9open'    # Создает тег для последней версии
    'tag2:c9start'   # Создает тег для последней версии
    'tag2:c9docker'  # Создает тег для последней версии
    
# Загрузка в репозиторий
    'push1:c9open'   # Загружает новую версию в docker-репозиторий
    'push1:c9start'  # Загружает новую версию в docker-репозиторий
    'push1:c9docker' # Загружает новую версию в docker-репозиторий
    'push2:c9open'   # Загружает последнюю версию в docker-репозиторий
    'push2:c9start'  # Загружает последнюю версию в docker-репозиторий
    'push2:c9docker' # Загружает последнюю версию в docker-репозиторий
)

#▄──────────────────────────▄
#█                          █
#█  Форируем списки команд  █
#█                          █
#▀──────────────────────────▀
ALL_LIST=(             # Cразу в оба репозитория
    ${GENERAL_LIST[*]} # Список общих команд
    ${DOCKER_LIST[*]}  # Docker-репозиторий
    ${GIT_LIST[*]}     # Git-репозиторий
    ${PUSH_LIST[*]}    # Загрузка в репозиторий
)
GIT_LIST=(             # Для git-репозитория
    ${GENERAL_LIST[*]} # Список общих команд
    ${GIT_LIST[*]}     # Git-репозиторий
)
DOCKER_LIST=(          # Для docker-репозитория
    ${GENERAL_LIST[*]} # Список общих команд
    ${DOCKER_LIST[*]}  # Docker-репозиторий
    ${PUSH_LIST[*]}    # Загрузка в репозиторий
)

#▄────────────────────────▄
#█                        █
#█  View: Deploy          █
#█  • Деплой (интерфейс)  █
#█                        █
#▀────────────────────────▀
view:Deploy() { case "$1" in
#┌─────────────────────┐
#│ Обновляет заголовок │
#└─────────────────────┘
    'header') case "$SELECTION" in
        1) printf "Деплой сразу в оба репозитория (версия '%s')"     "$NEW_VERSION" ;;
        2) printf "Деплой только в git-репозиторий (версия '%s')"    "$NEW_VERSION" ;;
        3) printf "Деплой только в docker-репозиторий (версия '%s')" "$NEW_VERSION" ;;
        *) printf "Пробуем продолжить деплой (версия '%s')"          "$NEW_VERSION" ;;
    esac
    ;;
    
#┌─────────────────────────────────────┐
#│ Обновляет текущее состояние команды │
#└─────────────────────────────────────┘
    'state') case "$2" in
    # Контройльная точка
        'no_stop')        printf 'Проходим контройльную точку...'                      ;;
        
    # Общие команды
        'is_new_version') printf 'Проверка новой версии...'                            ;;
        'save_version')   printf 'Сохранение новой версии...'                          ;;
        'cd_workspace')   printf 'Переход в рабочий каталог...'                        ;;
        
    # Git-репозиторий
        'is_git_user')    printf 'Проверка имени git-юзера...'                         ;;
        'is_git_repo')    printf 'Проверка имени git-репозитория...'                   ;;
        'git_login')      printf 'Авторизация в git-репозиторий...'                    ;;
        
    # Загрузка в репозиторий
        'git_add')        printf 'Добавление рабочего каталога в индекс...'            ;;
        'git_commit')     printf 'Создание коммита...'                                 ;;
        'git_push')       printf 'Загрузка коммита в git-репозиторий...'               ;;
        
    # Создание тегов
        'tag_remove')     printf "Удаление старого тега '$NEW_VERSION'"                ;;
        'tag_create')     printf "Создание тега '$NEW_VERSION'"                        ;;
        'tag_push')       printf "Загрузка тега '$NEW_VERSION'"                        ;;
        
    # Docker-репозиторий
        'is_docker_user') printf 'Проверка логина от docker-репозитория...'            ;;
        'is_docker_pass') printf 'Проверка пароля от docker-репозитория...'            ;;
        'docker_login')   printf 'Авторизация в docker-репозиторий...'                 ;;
        
    # Создание образов
        'build:c9open')   printf "Создание образа '${2/*:}'"                           ;;
        'build:c9start')  printf "Создание образа '${2/*:}'"                           ;;
        'build:c9docker') printf "Создание образа '${2/*:}'"                           ;;
        
    # Создание тегов
        'tag1:c9open')    printf "Создание тега '$DOCKER_USER/${2/*:}:$NEW_VERSION'"   ;;
        'tag1:c9start')   printf "Создание тега '$DOCKER_USER/${2/*:}:$NEW_VERSION'"   ;;
        'tag1:c9docker')  printf "Создание тега '$DOCKER_USER/${2/*:}:$NEW_VERSION'"   ;;
        'tag2:c9open')    printf "Создание тега '$DOCKER_USER/${2/*:}:latest'"         ;;
        'tag2:c9start')   printf "Создание тега '$DOCKER_USER/${2/*:}:latest'"         ;;
        'tag2:c9docker')  printf "Создание тега '$DOCKER_USER/${2/*:}:latest'"         ;;
        
    # Загрузка в репозиторий
        'push1:c9open')   printf "Загрузка образа '$DOCKER_USER/${2/*:}:$NEW_VERSION'" ;;
        'push1:c9start')  printf "Загрузка образа '$DOCKER_USER/${2/*:}:$NEW_VERSION'" ;;
        'push1:c9docker') printf "Загрузка образа '$DOCKER_USER/${2/*:}:$NEW_VERSION'" ;;
        'push2:c9open')   printf "Загрузка образа '$DOCKER_USER/${2/*:}:latest'"       ;;
        'push2:c9start')  printf "Загрузка образа '$DOCKER_USER/${2/*:}:latest'"       ;;
        'push2:c9docker') printf "Загрузка образа '$DOCKER_USER/${2/*:}:latest'"       ;;
    esac
    ;;
    
#┌─────────────────────────────┐
#│ Выводит сообщение об ошибке │
#└─────────────────────────────┘
    'error') case "$2" in
    # Контройльная точка
        'no_stop')        view 'error'     'На этом шаге деплой уже не отменить!'       ;;
        
    # Общие команды
        'is_new_version') view 'error'     "Версия '$NEW_VERSION' не прошла валидацию!" ;;
        'save_version')   view 'error_log' 'Новая версия не была сохранена!'            ;;
        'cd_workspace')   view 'error_log' 'Переход в рабочий каталог не был выполнен!' ;;
        
    # Git-репозиторий
        'is_git_user')    view 'error'     'Имя юзера для git-репозитория не задано!'   ;;
        'is_git_repo')    view 'error'     'Имя git-репозитория не задано!'             ;;
        'git_login')      view 'error_log' 'Авторизация не была пройдена!'              ;;
        
    # Загрузка в репозиторий
        'git_add')        view 'error_log' 'Рабочий каталог не был добавлен в индекс!'  ;;
        'git_commit')     view 'error_log' 'Коммит не был создан!'                      ;;
        'git_push')       view 'error_log' 'Коммит в git-репозиторий не был загружен!'  ;;
        
    # Создание тегов
        'tag_remove')     view 'error_log' "Тег '$NEW_VERSION' не был удален!"          ;;
        'tag_create')     view 'error_log' "Тег '$NEW_VERSION' не был создан!"          ;;
        'tag_push')       view 'error_log' "Тег '$NEW_VERSION' не был загружен!"        ;;
        
    # Docker-репозиторий
        'is_docker_user') view 'error'     'Логин от docker-репозитория не задан!'      ;;
        'is_docker_pass') view 'error'     'Пароль от docker-репозитория не задан!'     ;;
        'docker_login')   view 'error_log' 'Авторизация не была пройдена!'              ;;
        
    # Создание образов
        'build:c9open')   view 'error_log' "Образ '${2/*:}' не был создан!"             ;;
        'build:c9start')  view 'error_log' "Образ '${2/*:}' не был создан!"             ;;
        'build:c9docker') view 'error_log' "Образ '${2/*:}' не был создан!"             ;;
        
    # Создание тегов
        'tag1:c9open')    view 'error_log' "Тег '$DOCKER_USER/${2/*:}:$NEW_VERSION' не был создан!"     ;;
        'tag1:c9start')   view 'error_log' "Тег '$DOCKER_USER/${2/*:}:$NEW_VERSION' не был создан!"     ;;
        'tag1:c9docker')  view 'error_log' "Тег '$DOCKER_USER/${2/*:}:$NEW_VERSION' не был создан!"     ;;
        'tag2:c9open')    view 'error_log' "Тег '$DOCKER_USER/${2/*:}:latest' не был создан!"           ;;
        'tag2:c9start')   view 'error_log' "Тег '$DOCKER_USER/${2/*:}:latest' не был создан!"           ;;
        'tag2:c9docker')  view 'error_log' "Тег '$DOCKER_USER/${2/*:}:latest' не был создан!"           ;;
        
    # Загрузка в репозиторий
        'push1:c9open')   view 'error_log' "Образ '$DOCKER_USER/${2/*:}:$NEW_VERSION' не был загружен!" ;;
        'push1:c9start')  view 'error_log' "Образ '$DOCKER_USER/${2/*:}:$NEW_VERSION' не был загружен!" ;;
        'push1:c9docker') view 'error_log' "Образ '$DOCKER_USER/${2/*:}:$NEW_VERSION' не был загружен!" ;;
        'push2:c9open')   view 'error_log' "Образ '$DOCKER_USER/${2/*:}:latest' не был загружен!"       ;;
        'push2:c9start')  view 'error_log' "Образ '$DOCKER_USER/${2/*:}:latest' не был загружен!"       ;;
        'push2:c9docker') view 'error_log' "Образ '$DOCKER_USER/${2/*:}:latest' не был загружен!"       ;;
    esac
    ;;
    
#┌─────────────────────────────────────┐
#│ Добавляет информацию о новой версии │
#└─────────────────────────────────────┘
    'new_version')
        view 'success' "$2" "Новая версия: '$NEW_VERSION'"
    ;;
    
#┌──────────────────────────────────────────┐
#│ Выводит сообщение об успешном завершении │
#└──────────────────────────────────────────┘
    'success') case "$SELECTION" in
        1) view:Deploy 'new_version' 'Деплой в оба репозитория прошел успешно!'    ;;
        2) view:Deploy 'new_version' 'Деплой в git-репозиторий прошел успешно!'    ;;
        3) view:Deploy 'new_version' 'Деплой в docker-репозиторий прошел успешно!' ;;
        *) view        'success'     'Деплой успешно отменен!'                     ;;
    esac
    ;;
esac
}
