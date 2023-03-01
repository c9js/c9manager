#▄─────────────────────────▄
#█                         █
#█  Runner: Git            █
#█  • Гит (запуск команд)  █
#█                         █
#▀─────────────────────────▀
runner:Git() { case "$1" in
#┌───────────────────────────┐
#│ Проверяет текущий каталог │
#└───────────────────────────┘
    'is_dir')
        is_empty_dir "$PATH_CURRENT"
    ;;
    
#┌─────────────────────────────┐
#│ Переходит в рабочий каталог │
#└─────────────────────────────┘
    'void:cd')
        cd "$PATH_CURRENT"
    ;;
    
#┌───────────────────────┐
#│ Клонирует репозиторий │
#└───────────────────────┘
    'clone')
        git clone --progress "https://$GIT_URL/$GIT_USER/$GIT_REPO.git" .
    ;;
    
#┌───────────────────────────────────────┐
#│ Перемещает указатель на версию образа │
#└───────────────────────────────────────┘
    'void:checkout')
        git checkout -qB master "$VERSION"
    ;;
    
#┌───────────────────────────┐
#│ Добавляет новый URL-адрес │
#└───────────────────────────┘
    'add_url')
        git remote set-url --add 'origin' "git@$GIT_URL:$GIT_USER/$GIT_REPO.git"
    ;;
    
#┌──────────────────────────┐
#│ Удаляет старый URL-адрес │
#└──────────────────────────┘
    'delete_url')
        git remote set-url --delete 'origin' "https://$GIT_URL/$GIT_USER/$GIT_REPO.git"
    ;;
esac
}
