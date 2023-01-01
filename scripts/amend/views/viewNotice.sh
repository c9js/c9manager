#▄─────────────────▄
#█                 █
#█  Список ошибок  █
#█                 █
#▀─────────────────▀
ERROR_LIST=(
    'bad_commit' # Проверяет хэш текущего коммита
    'bad_branch' # Проверяет находитя-ли HEAD на ветке
)

#▄─────────────────────────────▄
#█                             █
#█  View: Notice               █
#█  • Уведомление (интерфейс)  █
#█                             █
#▀─────────────────────────────▀
view:Notice() { case "$1" in
#┌──────────────────┐
#│ Коммит не найден │
#└──────────────────┘
    'bad_commit')
        error 'У вас еще нет коммитов!'
    ;;
    
#┌──────────────────┐
#│ Ветка не найдена │
#└──────────────────┘
    'bad_branch')
        error 'Вы не находитесь на ветке!'
    ;;
esac
}
