#▄────────────────────────▄
#█                        █
#█  Entrypoint: Menu      █
#█  • Меню (точка входа)  █
#█                        █
#▀────────────────────────▀
entrypoint:Menu() { view 'init'; while :; do
#┌──────────────────────────────────┐
#│ Последний деплой не был завершен │
#└──────────────────────────────────┘
    if modelView:Notice 'error' 'bad_deploy'; then
    # Предлагаем пользователю попробовать еще раз
        view:Menu 'bad_deploy'
        
#┌───────────────────────┐
#│ Деплой прошел успешно │
#└───────────────────────┘
    else
        view:Menu 'main' # Выводим меню на экран
    fi
done
}
