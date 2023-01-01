#▄────────────────────────▄
#█                        █
#█  Entrypoint: Menu      █
#█  • Меню (точка входа)  █
#█                        █
#▀────────────────────────▀
entrypoint:Menu() { view 'init'; while :; do
#┌────────────────────────┐
#│ Уведомления об ошибках │
#└────────────────────────┘
    if modelView:Notice 'error'; then
    # Предлагаем пользователю исправить ошибку
        view:Menu 'error'
        
#┌───────────────────┐
#│ Ошибок не найдено │
#└───────────────────┘
    else
        view:Menu 'main' "$PAGE" # Выводим меню на экран
    fi
done
}