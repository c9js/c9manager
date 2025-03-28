#▄───────────────────────▄
#█                       █
#█  Список общих команд  █
#█                       █
#▀───────────────────────▀
GENERAL_LIST=(
# Общие команды
    'is_branch'      # Проверяет текущую ветку
    'is_status'      # Проверяет текущий статус
    'is_new_version' # Проверяет новую версию
    'save_version'   # Сохраняет новую версию
)

#▄────────────────────────────────────────▄
#█                                        █
#█  Список команд для продолжения деплоя  █
#█                                        █
#▀────────────────────────────────────────▀
CONTINUE_LIST=(
# Общие команды
    'is_branch'      # Проверяет текущую ветку
    'is_new_version' # Проверяет новую версию
    'save_version'   # Сохраняет новую версию
    'is_status'      # Проверяет текущий статус
)

#▄─────────────────────────────────────▄
#█                                     █
#█  Список команд для git-репозитория  █
#█                                     █
#▀─────────────────────────────────────▀
GIT_LIST=(
# Авторизация
    'is_git_user'    # Проверяет имя git-юзера
    'is_git_repo'    # Проверяет имя git-репозитория
    'git_login'      # Проверяет авторизацию в git-репозиторий
    
# Контройльная точка
    'no_stop'        # После этого момента деплой уже не отменить
    
# Загрузка в репозиторий
    'git_add'        # Добавляет новую версию в индекс
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
    'build:c9docker' # Создает новый образ
    'build:c9start'  # Создает новый образ
    'build:c9open'   # Создает новый образ
    'build:c9vue'    # Создает новый образ
    
# Контройльная точка
    'no_stop'        # После этого момента деплой уже не отменить
)
PUSH_LIST=(
# Создание тегов
    'tag1:c9docker'  # Создает тег для новой версии
    'tag1:c9start'   # Создает тег для новой версии
    'tag1:c9open'    # Создает тег для новой версии
    'tag1:c9vue'     # Создает тег для новой версии
    'tag2:c9docker'  # Создает тег для последней версии
    'tag2:c9start'   # Создает тег для последней версии
    'tag2:c9open'    # Создает тег для последней версии
    'tag2:c9vue'     # Создает тег для последней версии
    
# Загрузка в репозиторий
    'push1:c9docker' # Загружает новую версию в docker-репозиторий
    'push1:c9start'  # Загружает новую версию в docker-репозиторий
    'push1:c9open'   # Загружает новую версию в docker-репозиторий
    'push1:c9vue'    # Загружает новую версию в docker-репозиторий
    'push2:c9docker' # Загружает последнюю версию в docker-репозиторий
    'push2:c9start'  # Загружает последнюю версию в docker-репозиторий
    'push2:c9open'   # Загружает последнюю версию в docker-репозиторий
    'push2:c9vue'    # Загружает последнюю версию в docker-репозиторий
)

#▄──────────────────────────▄
#█                          █
#█  Форируем списки команд  █
#█                          █
#▀──────────────────────────▀
ALL_LIST=(               # Cразу в оба репозитория
    "${GENERAL_LIST[@]}" # Список общих команд
    "${DOCKER_LIST[@]}"  # Docker-репозиторий
    "${GIT_LIST[@]}"     # Git-репозиторий
    "${PUSH_LIST[@]}"    # Загрузка в репозиторий
)
GIT_LIST=(               # Для git-репозитория
    "${GENERAL_LIST[@]}" # Список общих команд
    "${GIT_LIST[@]}"     # Git-репозиторий
)
DOCKER_LIST=(            # Для docker-репозитория
    "${GENERAL_LIST[@]}" # Список общих команд
    "${DOCKER_LIST[@]}"  # Docker-репозиторий
    "${PUSH_LIST[@]}"    # Загрузка в репозиторий
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
        'is_branch')      printf 'Проверяем текущую ветку...'                          ;;
        'is_status')      printf 'Проверяем текущий статус...'                         ;;
        'is_new_version') printf 'Проверяем новую версию...'                           ;;
        'save_version')   printf 'Сохраняем новую версию...'                           ;;
        
    # Git-репозиторий
        'is_git_user')    printf 'Проверяем имя git-юзера...'                          ;;
        'is_git_repo')    printf 'Проверяем имя git-репозитория...'                    ;;
        'git_login')      printf 'Авторизация в git-репозиторий...'                    ;;
        
    # Загрузка в репозиторий
        'git_add')        printf 'Добавляем новую версию в индекс...'                  ;;
        'git_commit')     printf 'Создаем коммит...'                                   ;;
        'git_push')       printf 'Загружаем коммит в git-репозиторий...'               ;;
        
    # Создание тегов
        'tag_remove')     printf "Удаляем старый тег '$NEW_VERSION'"                   ;;
        'tag_create')     printf "Создаем новый тег '$NEW_VERSION'"                    ;;
        'tag_push')       printf "Загружаем новый тег '$NEW_VERSION'"                  ;;
        
    # Docker-репозиторий
        'is_docker_user') printf 'Проверяем логин от docker-репозитория...'            ;;
        'is_docker_pass') printf 'Проверяем пароль от docker-репозитория...'           ;;
        'docker_login')   printf 'Авторизация в docker-репозиторий...'                 ;;
        
    # Создание образов
        'build:c9docker') printf "Создаем образ '${2/*:}'"                             ;;
        'build:c9start')  printf "Создаем образ '${2/*:}'"                             ;;
        'build:c9open')   printf "Создаем образ '${2/*:}'"                             ;;
        'build:c9vue')    printf "Создаем образ '${2/*:}'"                             ;;
        
    # Создание тегов
        'tag1:c9docker')  printf "Создаем тег '$DOCKER_USER/${2/*:}:$NEW_VERSION'"     ;;
        'tag1:c9start')   printf "Создаем тег '$DOCKER_USER/${2/*:}:$NEW_VERSION'"     ;;
        'tag1:c9open')    printf "Создаем тег '$DOCKER_USER/${2/*:}:$NEW_VERSION'"     ;;
        'tag1:c9vue')     printf "Создаем тег '$DOCKER_USER/${2/*:}:$NEW_VERSION'"     ;;
        'tag2:c9docker')  printf "Создаем тег '$DOCKER_USER/${2/*:}:latest'"           ;;
        'tag2:c9start')   printf "Создаем тег '$DOCKER_USER/${2/*:}:latest'"           ;;
        'tag2:c9open')    printf "Создаем тег '$DOCKER_USER/${2/*:}:latest'"           ;;
        'tag2:c9vue')     printf "Создаем тег '$DOCKER_USER/${2/*:}:latest'"           ;;
        
    # Загрузка в репозиторий
        'push1:c9docker') printf "Загружаем образ '$DOCKER_USER/${2/*:}:$NEW_VERSION'" ;;
        'push1:c9start')  printf "Загружаем образ '$DOCKER_USER/${2/*:}:$NEW_VERSION'" ;;
        'push1:c9open')   printf "Загружаем образ '$DOCKER_USER/${2/*:}:$NEW_VERSION'" ;;
        'push1:c9vue')    printf "Загружаем образ '$DOCKER_USER/${2/*:}:$NEW_VERSION'" ;;
        'push2:c9docker') printf "Загружаем образ '$DOCKER_USER/${2/*:}:latest'"       ;;
        'push2:c9start')  printf "Загружаем образ '$DOCKER_USER/${2/*:}:latest'"       ;;
        'push2:c9open')   printf "Загружаем образ '$DOCKER_USER/${2/*:}:latest'"       ;;
        'push2:c9vue')    printf "Загружаем образ '$DOCKER_USER/${2/*:}:latest'"       ;;
    esac
    ;;
    
#┌─────────────────────────────┐
#│ Выводит сообщение об ошибке │
#└─────────────────────────────┘
    'error') case "$2" in
    # Контройльная точка
        'no_stop')        error 'На этом шаге деплой уже не отменить!'       ;;
        
    # Общие команды
        'is_branch')      error 'Вы не находитесь на ветке!'                 ;;
        'is_status')      error "Ваш 'git status' должен быть пуст!"         ;;
        'is_new_version') error "Версия '$NEW_VERSION' не прошла валидацию!" ;;
        'save_version')   error 'Новая версия не была сохранена!'            ;;
        
    # Git-репозиторий
        'is_git_user')    error 'Имя юзера для git-репозитория не задано!'   ;;
        'is_git_repo')    error 'Имя git-репозитория не задано!'             ;;
        'git_login')      error 'Авторизация не была пройдена!'              ;;
        
    # Загрузка в репозиторий
        'git_add')        error 'Новая версия не была добавлена в индекс!'   ;;
        'git_commit')     error 'Коммит не был создан!'                      ;;
        'git_push')       error 'Коммит в git-репозиторий не был загружен!'  ;;
        
    # Создание тегов
        'tag_remove')     error "Тег '$NEW_VERSION' не был удален!"          ;;
        'tag_create')     error "Тег '$NEW_VERSION' не был создан!"          ;;
        'tag_push')       error "Тег '$NEW_VERSION' не был загружен!"        ;;
        
    # Docker-репозиторий
        'is_docker_user') error 'Логин от docker-репозитория не задан!'      ;;
        'is_docker_pass') error 'Пароль от docker-репозитория не задан!'     ;;
        'docker_login')   error 'Авторизация не была пройдена!'              ;;
        
    # Создание образов
        'build:c9docker') error "Образ '${2/*:}' не был создан!"             ;;
        'build:c9start')  error "Образ '${2/*:}' не был создан!"             ;;
        'build:c9open')   error "Образ '${2/*:}' не был создан!"             ;;
        'build:c9vue')    error "Образ '${2/*:}' не был создан!"             ;;
        
    # Создание тегов
        'tag1:c9docker')  error "Тег '$DOCKER_USER/${2/*:}:$NEW_VERSION' не был создан!"     ;;
        'tag1:c9start')   error "Тег '$DOCKER_USER/${2/*:}:$NEW_VERSION' не был создан!"     ;;
        'tag1:c9open')    error "Тег '$DOCKER_USER/${2/*:}:$NEW_VERSION' не был создан!"     ;;
        'tag1:c9vue')     error "Тег '$DOCKER_USER/${2/*:}:$NEW_VERSION' не был создан!"     ;;
        'tag2:c9docker')  error "Тег '$DOCKER_USER/${2/*:}:latest' не был создан!"           ;;
        'tag2:c9start')   error "Тег '$DOCKER_USER/${2/*:}:latest' не был создан!"           ;;
        'tag2:c9open')    error "Тег '$DOCKER_USER/${2/*:}:latest' не был создан!"           ;;
        'tag2:c9vue')     error "Тег '$DOCKER_USER/${2/*:}:latest' не был создан!"           ;;
        
    # Загрузка в репозиторий
        'push1:c9docker') error "Образ '$DOCKER_USER/${2/*:}:$NEW_VERSION' не был загружен!" ;;
        'push1:c9start')  error "Образ '$DOCKER_USER/${2/*:}:$NEW_VERSION' не был загружен!" ;;
        'push1:c9open')   error "Образ '$DOCKER_USER/${2/*:}:$NEW_VERSION' не был загружен!" ;;
        'push1:c9vue')    error "Образ '$DOCKER_USER/${2/*:}:$NEW_VERSION' не был загружен!" ;;
        'push2:c9docker') error "Образ '$DOCKER_USER/${2/*:}:latest' не был загружен!"       ;;
        'push2:c9start')  error "Образ '$DOCKER_USER/${2/*:}:latest' не был загружен!"       ;;
        'push2:c9open')   error "Образ '$DOCKER_USER/${2/*:}:latest' не был загружен!"       ;;
        'push2:c9vue')    error "Образ '$DOCKER_USER/${2/*:}:latest' не был загружен!"       ;;
    esac
    ;;
    
#┌──────────────────────────────────────────┐
#│ Выводит сообщение об успешном завершении │
#└──────────────────────────────────────────┘
    'success') case "$SELECTION" in
        1) success 'Деплой в оба репозитория прошел успешно!'    "Новая версия: '$NEW_VERSION'" ;;
        2) success 'Деплой в git-репозиторий прошел успешно!'    "Новая версия: '$NEW_VERSION'" ;;
        3) success 'Деплой в docker-репозиторий прошел успешно!' "Новая версия: '$NEW_VERSION'" ;;
        *) success 'Деплой успешно отменен!'                                                    ;;
    esac
    ;;
esac
}
