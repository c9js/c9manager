#▄────────────────────────────────▄
#█                                █
#█  Controller: Run               █
#█  • Запуск команд (управление)  █
#█                                █
#▀────────────────────────────────▀
controller:Run() { case "$1" in
# Общие команды
    'is_new_version') stream "model:Run $@" ;; # Проверяет новую версию
    'save_version')   stream "model:Run $@" ;; # Сохраняет новую версию
    'cd_workspace')   stream "model:Run $@" ;; # Переходит в рабочий каталог
    
# Git-репозиторий
    'is_git_user')    stream "model:Run $@" ;; # Проверяет имя git-юзера
    'is_git_repo')    stream "model:Run $@" ;; # Проверяет имя git-репозитория
    'git_login')      stream "model:Run $@" ;; # Проверяет авторизацию в git-репозиторий
    'git_add')        stream "model:Run $@" ;; # Добавляет рабочий каталог в индекс
    'git_commit')     stream "model:Run $@" ;; # Создает новый коммит
    'git_push')       stream "model:Run $@" ;; # Загружает коммит в git-репозиторий
    
# Docker-репозиторий
    'is_docker_user') stream "model:Run $@" ;; # Проверяет логин от docker-репозитория
    'is_docker_pass') stream "model:Run $@" ;; # Проверяет пароль от docker-репозитория
    'docker_login')   stream "model:Run $@" ;; # Проходит авторизацию в docker-репозиторий
    
# Создание образов
    'build:c9open')   stream "model:Run $@" ;; # Создает новый образ
    'build:c9start')  stream "model:Run $@" ;; # Создает новый образ
    'build:c9docker') stream "model:Run $@" ;; # Создает новый образ
    
# Создание тегов
    'tag1:c9open')    stream "model:Run $@" ;; # Создает теги для новой версии
    'tag1:c9start')   stream "model:Run $@" ;; # Создает теги для новой версии
    'tag1:c9docker')  stream "model:Run $@" ;; # Создает теги для новой версии
    'tag2:c9open')    stream "model:Run $@" ;; # Создает теги для последней версии
    'tag2:c9start')   stream "model:Run $@" ;; # Создает теги для последней версии
    'tag2:c9docker')  stream "model:Run $@" ;; # Создает теги для последней версии
    
# Загрузка в репозиторий
    'push1:c9open')   stream "model:Run $@" ;; # Загружает последнюю версию в docker-репозиторий
    'push1:c9start')  stream "model:Run $@" ;; # Загружает последнюю версию в docker-репозиторий
    'push1:c9docker') stream "model:Run $@" ;; # Загружает последнюю версию в docker-репозиторий
    'push2:c9open')   stream "model:Run $@" ;; # Загружает новую версию в docker-репозиторий
    'push2:c9start')  stream "model:Run $@" ;; # Загружает новую версию в docker-репозиторий
    'push2:c9docker') stream "model:Run $@" ;; # Загружает новую версию в docker-репозиторий
esac
}
