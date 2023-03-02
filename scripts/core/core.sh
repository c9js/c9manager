#▄───────────────▄1.0.2
#█               █
#█  Core (ядро)  █
#█               █
#▀───────────────▀
# Controllers
. $PATH_DIR/../core/controllers/namespace.sh

# Models
. $PATH_DIR/../core/models/base.sh
. $PATH_DIR/../core/models/filesystem.sh
. $PATH_DIR/../core/models/docker.sh
. $PATH_DIR/../core/models/stream.sh
. $PATH_DIR/../core/models/valid.sh

# ViewModels
. $PATH_DIR/../core/viewModels/navigator.sh
. $PATH_DIR/../core/viewModels/pages.sh
. $PATH_DIR/../core/viewModels/notice.sh
. $PATH_DIR/../core/viewModels/runner.sh

# Views
. $PATH_DIR/../core/view/card.sh
. $PATH_DIR/../core/view/input.sh
. $PATH_DIR/../core/view/menu.sh

#▄──────────────────────────────────────────▄
#█                                          █
#█  Переопределяем сочетание клавиш Ctrl+C  █
#█                                          █
#▀──────────────────────────────────────────▀
ctrl_c() {
    reset # Очищаем экран
    exit  # Завершаем процесс
}
trap ctrl_c 2

#▄─────────────────────────────────▄
#█                                 █
#█  Переопределяем Reset           █
#█  Пока это единственный способ   █
#█  очистить консоль в режиме Run  █
#█                                 █
#▀─────────────────────────────────▀
reset() {
# Переходим в начало
    printf '\e[1;1H'
    
# Сбрасываем цвет
    printf '\e[0m'
    
# Добавляем пробел
    printf ' '
    
# Удаляем все после текущей позиции
    printf '\e[J'
    
# Удалеяем пробел
    printf '\b'
}
