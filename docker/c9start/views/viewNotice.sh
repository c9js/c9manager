#▄───────────────────────────────────▄
#█                                   █
#█  Список информационных сообщений  █
#█                                   █
#▀───────────────────────────────────▀
INFO_LIST=(
    'run' # Проверяет запущен-ли контейнер
)

#▄─────────────────────────▄
#█                         █
#█  Список предупреждений  █
#█                         █
#▀─────────────────────────▀
WARNING_LIST=(
    'run_old'              # Проверяет запущен-ли старый контейнер
    'current_dir_is_empty' # Проверяет пуст-ли текущий каталог
)

#▄─────────────────▄
#█                 █
#█  Список ошибок  █
#█                 █
#▀─────────────────▀
ERROR_LIST=(
    'bad_git' # Проверяет существует-ли каталог с именем ".git"
)

#▄───────────────────────────▄
#█                           █
#█  Список фатальных ошибок  █
#█                           █
#▀───────────────────────────▀
FATAL_LIST=(
    'bad_cd' # Проверяет задана-ли переменная '$CD'
)

#▄─────────────────────────────▄
#█                             █
#█  View: Notice               █
#█  • Уведомление (интерфейс)  █
#█                             █
#▀─────────────────────────────▀
view:Notice() { case "$1" in
#┌───────────────────┐
#│ Контейнер запущен │
#└───────────────────┘
    'run')
        info \
        "Контейнер '$RUN_IMAGE:$RUN_VERSION' уже запущен!" \
        "http://localhost:$RUN_PORT/"
    ;;
    
#┌──────────────────────────┐
#│ Запущен старый контейнер │
#└──────────────────────────┘
    'run_old')
        warning \
        "Контейнер '$RUN_IMAGE:$RUN_VERSION' устарел!" \
        "Новая версия: '$VERSION'"
    ;;
    
#┌──────────────────────┐
#│ Текущий каталог пуст │
#└──────────────────────┘
    'current_dir_is_empty')
        warning \
        'Вам необходим локальный репозиторий!' \
        "Нажмите 'Git clone'"
    ;;
    
#┌──────────────────────────┐
#│ Каталог ".git" не найден │
#└──────────────────────────┘
    'bad_git')
        error \
        "Каталог должен быть пуст!" \
        "Путь: $CD"
    ;;
    
#┌────────────────────────────┐
#│ Переменная '$CD' не задана │
#└────────────────────────────┘
    'bad_cd')
        fatal_error "Переменная окружения '\$CD' не задана!"
    ;;
esac
}
