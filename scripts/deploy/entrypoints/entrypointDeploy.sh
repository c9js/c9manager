#▄──────────────────────────▄
#█                          █
#█  Entrypoint: Deploy      █
#█  • Деплой (точка входа)  █
#█                          █
#▀──────────────────────────▀
entrypoint:Deploy() { nav:Init; while :; do
#┌──────────────────────────────────┐
#│ Последний деплой не был завершен │
#└──────────────────────────────────┘
    if runner:Notice 'bad_deploy'; then
    # Предлагаем пользователю попробовать еще раз
        navigator 'bad_deploy'
        
#┌───────────────────────┐
#│ Деплой прошел успешно │
#└───────────────────────┘
    else
        nav:Main # Выводим меню на экран
    fi
done
}