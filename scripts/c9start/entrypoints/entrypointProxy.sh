#▄────────────────────────────────────▄
#█                                    █
#█  Entrypoint: Proxy                 █
#█  • Прокси контейнер (точка входа)  █
#█                                    █
#▀────────────────────────────────────▀
entrypoint:Proxy() {
#┌───────────────────────────────────────────────┐
#│ Путь к текущему каталогу вне docker-а         │
#├───────────────────────────────────────────────┤
#│ Конвертируем:                                 │
#│ Путь Windows -> "D:\MyProjects\project"       │
#│ в путь Linux -> "/d/MyProjects/project"       │
#│ 1. Переводим первый символ в нижний регистр   │
#│ 2. Переводим обратные слешы "\" в "/"         │
#│ 3. Добавляем в начало "/", (если его там нет) │
#│ 4. Удаляем ":"                                │
#└───────────────────────────────────────────────┘
    DOCKER_PWD=$(echo "$P" | sed \
        -e 's/[A-Z]/\L&/' \
        -e 's-\\-\/-g' \
        -e '/^\//!s-^-/-' \
        -e 's-:--' \
    )
    
# Определяем разделитель
    [[ "${P/\\}" != "$P" ]] && SEP='\' || SEP='/'
    
# Получаем ID-образа
    IMAGE_ID="$(docker ps --filter "id=$HOSTNAME" --format='{{.Image}}')"
    
#┌────────────────────────────┐
#│ Переход в прокси контейнер │
#└────────────────────────────┘
    docker run \
        -e "P=$P" \
        -e "SEP=$SEP" \
        -e "DOCKER_PWD=$DOCKER_PWD" \
        -e "PARENT_HOSTNAME=$HOSTNAME" \
        -v "$DOCKER_PWD:$PATH_CURRENT" \
        -v '//var/run/docker.sock:/var/run/docker.sock' --privileged \
        --rm -it \
        "$IMAGE_ID" \
        'MENU' \
        "$@" 2>&1
}
