#▄───────────────────────▄
#█                       █
#█  View                 █
#█  • Общий (интерфейс)  █
#█                       █
#▀───────────────────────▀
view() { case "$1" in
#┌───────────────┐
#│ Инициализация │
#└───────────────┘
    'init')
    # Создаем заголовок меню
        view:Menu 'header'
    ;;
esac
}