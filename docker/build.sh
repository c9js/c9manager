#!/bin/bash
#
# Что умеет этот скрипт?
# 1. Создать новый образ и удалить старый.
# 2. Запустить новый контейнер, остановить и удалить старый.
#
#┌────────────────────────────────────────────┐
#│ Путь к каталогу где расположен этот скрипт │
#└────────────────────────────────────────────┘
DIR_PATH="$(dirname $0)"

#┌──────────────────────┐
#│ Загружаем библиотеки │
#└──────────────────────┘
. /$WORKSPACE/scripts/cli/lib.base.sh
. /$WORKSPACE/scripts/cli/lib.docker.sh
. /$WORKSPACE/scripts/cli/gui.input.sh

#┌────────────────────────────┐
#│ Список аргументов          │
#├────────────────────────────┤
#│ ./c9 <COMMAND> <IMAGE_RUN> │
#└────────────────────────────┘
COMMAND="$1"   # Команда
IMAGE_RUN="$2" # Имя образа

#┌─────────────────────────────────────────────────┐
#│ Выводит сообщение об ошибке и завершает процесс │
#└─────────────────────────────────────────────────┘
error() {
    echo "Ошибка! $1" # Вывод сообщения об ошибке
    exit # Завершение процесса
}

#┌─────────────────────────────────────────────────┐
#│ Выводит финальное сообщение и завершает процесс │
#└─────────────────────────────────────────────────┘
complete() {
# Очищаем экран
    reset
    
# Выводим какой был выбран образ
    if [[ $1 != '-h' ]]; then
        echo "Образ '$IMAGE_RUN'"
    fi
    
# Проходим по списку сообщений
    for message in "$@"; do
    # Выводим финальное сообщение
        if [[ $message != '-h' ]]; then
            echo "$message"
        fi
    done
    
# Завершаем процесс
    exit
}

#┌────────────────────────┐
#│ Выводит текущий статус │
#└────────────────────────┘
status() {
# Очищаем экран
    reset
    
# Заголовок
    echo "$header"
    
# Статус
    echo "[$1/$full] $2"
}

#┌────────────────────────────────────┐
#│ Проверяет верно-ли введена команда │
#├────────────────────────────────────┤
#│ ./c9 build  c9docker               │
#│ ./c9 remove c9docker               │
#│ ./c9 start  c9docker               │
#│ ./c9 stop   c9docker               │
#└────────────────────────────────────┘
isValidCommand() { [[ "$1" =~ ^(build|remove|start|stop)$ ]]; }

#┌─────────────────────────────────────────────────┐
#│ Если изначально команда была передана не верно, │
#│ просим пользователя ввести её вручную           │
#└─────────────────────────────────────────────────┘
    if ! isValidCommand "$1"; then
    # Очищаем экран
        reset
        
    # Выводим информацию со списком команд
        echo '-------------------------------------'
        echo 'stop    Удалить все старые контейнеры'
        echo 'start   Запустить новый контейнер'
        echo 'remove  Удалить старый образ'
        echo 'build   Создать новый образ'
        echo '-------------------------------------'
        
    # Просим пользователя ввести команду вручную
        input 'build' 'isValidCommand' "Команда '%s' не найдена!"
        COMMAND=$REPLY
        
    # Очищаем экран
        reset
    fi
    
#┌───────────────────────────────────────┐
#│ Проверяет верно-ли введено имя образа │
#├───────────────────────────────────────┤
#│ ./c9 build c9docker                   │
#│ ./c9 build c9open                     │
#│ ./c9 build c9start                    │
#└───────────────────────────────────────┘
isValidImageName() { [[ "$1" =~ ^(c9docker|c9open|c9start)$ ]]; }

#┌────────────────────────────────────────────────────┐
#│ Если изначально имя образа было передано не верно, │
#│ просим пользователя ввести его вручную             │
#└────────────────────────────────────────────────────┘
    if ! isValidImageName "$2"; then
    # Очищаем экран
        reset
        
    # Выводим информацию со списком образов
        echo '---------------------------------------------'
        echo 'c9open    Базовый образ'
        echo 'c9docker  Образ для работы с другими образами'
        echo 'c9start   Образ для первого запуска'
        echo '---------------------------------------------'
        
    # Просим пользователя ввести имя образа вручную
        input 'c9docker' 'isValidImageName' "Образ '%s' не найден!"
        IMAGE_RUN=$REPLY
        
    # Очищаем экран
        reset
    fi
    
#┌──────────────────┐
#│ Заголовки команд │
#└──────────────────┘
case $COMMAND in
# Команда "Build"
    'build')
    # Заголовок
        header="Создание образа '$IMAGE_RUN'"
        
    # Количество шагов
        full=13
    ;;
    
# Команда "Remove"
    'remove')
     # Заголовок
        header="Удаление образа '$IMAGE_RUN'"
        
    # Количество шагов
        full=6
    ;;
    
# Команда "Start"
    'start')
     # Заголовок
        header="Запуск контейнера от образа '$IMAGE_RUN'"
        
    # Количество шагов
        full=13
    ;;
    
# Команда "Stop"
    'stop')
     # Заголовок
        header="Удаление контейнеров от образа '$IMAGE_RUN'"
        
    # Количество шагов
        full=4
    ;;
esac

#┌────────────────────────────────────────────────────────┐
#│ Команды: Build, Remove, Start, Stop                    │
#│ • Перед началом любой команды,                         │
#│   мы должны остановить и удалить все старые контейнеры │
#└────────────────────────────────────────────────────────┘
# Получаем ID-контейнеров
    status 1 'Поиск контейнеров...'
    
# Контейнеры не найдены
    if ! is_container "name=$IMAGE_RUN"; then
    # Выводим финальное сообщение и завершаем процесс
    # Но только если это команда "Stop"
        if [[ "$COMMAND" == 'stop' ]]; then
            complete 'Контейнеры не найдены!'
        fi
        
# Контейнеры найдены
    else
    # Получаем ID-контейнеров
        containerID=${GLOBAL_ID[*]}
        
    # Останавливаем контейнеры
        status 2 'Остановка контейнеров...'
        docker stop $containerID &> '/dev/null'
        
    # Удаляем контейнеры
        status 3 'Удаление контейнеров...'
        docker rm $containerID &> '/dev/null'
        
    # Проходим по списку портов
        status 4 'Удаление портов из списка...'
        for ID in $containerID; do
        # Удаляем порты из списка
            "$DIR_PATH/ports.js" remove "$ID" &> '/dev/null'
        done
        
    # Выводим финальное сообщение и завершаем процесс
    # Но только если это команда "Stop"
        if [[ "$COMMAND" == 'stop' ]]; then
            complete 'Контейнеры успешно удалены!'
        fi
    fi
    
#┌──────────────────────────────────────────┐
#│ Команда "Build"                          │
#│ • Прежде чем создать новый образ,        │
#│   мы должны удалить старый               │
#│                                          │
#│ Команда "Remove"                         │
#│ • Все готово для удаления старого образа │
#└──────────────────────────────────────────┘
    if [[ "$COMMAND" == 'build' || "$COMMAND" == 'remove' ]]; then
    # Получаем ID-образов
        status 5 'Поиск старого образа...'
        
    # Старый образ не найден
        if ! is_image "$IMAGE_RUN"; then
        # Выводим финальное сообщение и завершаем процесс
        # Но только если это команда "Remove"
            if [[ "$COMMAND" == 'remove' ]]; then
                complete -h "Образ '$IMAGE_RUN' не найден!"
            fi
            
    # Старый образ найден
        else
        # Получаем ID-образов
            imageID=${GLOBAL_ID[*]}
            
        # Удаляем старый образ
            status 6 'Удаление старого образа...'
            docker rmi -f "$imageID" &> '/dev/null'
            
        # Выводим сообщение только если это команда "Remove"
            if [[ "$COMMAND" == 'remove' ]]; then
            # Контейнеров не было найдено
                if [[ ${#containerID} != '12' ]]; then
                    complete -h "Образ '$IMAGE_RUN' успешно удален!"
                    
            # Контейнеры были найдены
                else
                    complete -h "Все контейнеры были остановлены и удалены!" \
                                "Образ '$IMAGE_RUN' также был удален!"
                fi
            fi
        fi
    fi
    
#┌───────────────────────────────────────────┐
#│ Команда "Start"                           │
#│ • Перед запускаем нового контейнера,      │
#│   мы должны проверить существует-ли образ │
#└───────────────────────────────────────────┘
    if [[ "$COMMAND" == 'start' ]]; then
    # Получаем ID-образа
        status 7 'Поиск образа...'
        # Наверно это не очевидно,
        # но мы все же ищем образ ниже во второй части,
        # прямо в условии в if-е, вот тут [ ! is_image "$IMAGE_RUN" ]
    fi
    
#┌─────────────────────────────────────────┐
#│ Команды: Build, Start                   │
#│ • Все готово для создания нового образа │
#└─────────────────────────────────────────┘
    if [[ "$COMMAND" == 'build' || "$COMMAND" == 'start' ]]; then
    # Старый образ не найден
        if [[ "$COMMAND" == 'build' ]] ||  ! is_image "$IMAGE_RUN"; then
        # Копируем временные файлы
            status 8 'Копирование временных файлов...'
            
        # Создаем временный каталог
            mkdir -p "$DIR_PATH/temp/scripts"
            
        # Копируем версию
            cp -r "$PATH_VERSION" "$DIR_PATH/temp/VERSION"
            
        # Копируем bash-скрипты
            cp -r "/$WORKSPACE/scripts/." "$DIR_PATH/temp/scripts"
            
        # Копируем настройки редактора и bash-профиль 
            cp -r "/$WORKSPACE/c9settings/." "$DIR_PATH/temp"
            
        # Проверяем предусмотрены-ли для образа дополнительные алиасы
            if [ -s "$DIR_PATH/$IMAGE_RUN/alias" ]; then
            # Добавляем алиасы в bash-профиль
                cat "$DIR_PATH/$IMAGE_RUN/alias" >> "$DIR_PATH/temp/bash_profile"
            fi
            
        # Создаем новый образ
            status 9 'Создание нового образа...'
            docker build \
                --build-arg "controllers=$IMAGE_RUN/controllers/" \
                --build-arg "entrypoints=$IMAGE_RUN/entrypoints/" \
                --build-arg "runners=$IMAGE_RUN/runners/" \
                --build-arg "models=$IMAGE_RUN/models/" \
                --build-arg "views=$IMAGE_RUN/views/" \
                --build-arg "entrypoint=$IMAGE_RUN/Entrypoint.sh" \
                -f "$DIR_PATH/$IMAGE_RUN/Dockerfile" \
                -t "$IMAGE_RUN" \
                "$DIR_PATH"
                
        # Сохраняем результат
            res=$?
            
        # Удаляем временные файлы
            status 10 'Удаление временных файлов...'
            rm -r "$DIR_PATH/temp" # Временный каталог
            
        # Выводим сообщение об ошибке и завершаем процесс
            if (( "$res" != 0 )); then
                error "Что-то не так в 'docker build ...'"
            fi
        fi
        
    # Получаем список свободных портов
        status 11 'Получение свободных портов...'
        if ! PORTS=$("$DIR_PATH/ports.js" getFreePorts 2 2>&1); then
        # Выводим сообщение об ошибке и завершаем процесс
            error "$PORTS"
        fi
        
    # Сохраняем порты в переменные
        PORT1=$(echo "$PORTS" | cut -d ' ' -f 1)
        PORT2=$(echo "$PORTS" | cut -d ' ' -f 2)
        
    # Запускаем контейнер
        status 12 'Запуск контейнера...'
        if ! containerID=$(docker run \
            --name "$IMAGE_RUN" \
            --hostname "$IMAGE_RUN" \
            -p "$PORT1:$PORT1" \
            -p "$PORT2:$PORT2" \
            -e "C9_PORT=$PORT1" \
            -e "PORT=$PORT2" \
            -e "VERSION=$VERSION" \
            -e "PATH_VERSION=$PATH_VERSION" \
            -e "PATH_GIT_USER=$PATH_GIT_USER" \
            -e "PATH_GIT_REPO=$PATH_GIT_REPO" \
            -e "PATH_DOCKER_USER=$PATH_DOCKER_USER" \
            -e "PATH_DOCKER_PASS=$PATH_DOCKER_PASS" \
            -e "PATH_BAD_DEPLOY=$PATH_BAD_DEPLOY" \
            -e "GIT_URL=$GIT_URL" \
            -e "GIT_USER=$GIT_USER" \
            -e "GIT_REPO=$GIT_REPO" \
            -e "WORKSPACE=$IMAGE_RUN" \
            -e "DOCKER_USER=$DOCKER_USER" \
            -e "DOCKER_PWD=$DOCKER_PWD" \
            -v "$DOCKER_PWD/projects/$IMAGE_RUN:/$IMAGE_RUN" \
            -v "$DOCKER_PWD/ssh:/root/.sshsource" \
            -v '//var/run/docker.sock:/var/run/docker.sock' --privileged \
            --restart unless-stopped \
            --detach -it \
            "$IMAGE_RUN"
        ); then
        # Выводим сообщение об ошибке и завершаем процесс
            error "Что-то не так в 'docker run ...'"
        fi
        
    # Привязываем порты к containerID
        status 13 'Сохранение списка портов...'
        "$DIR_PATH/ports.js" add "$containerID" "$PORT1" &> '/dev/null'
        "$DIR_PATH/ports.js" add "$containerID" "$PORT2" &> '/dev/null'
        
    # Выводим финальное сообщение и завершаем процесс
        complete "Контейнер успешно запущен!" \
                 "http://localhost:$PORT1/"
    fi
    