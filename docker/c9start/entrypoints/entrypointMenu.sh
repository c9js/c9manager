#▄────────────────────────▄
#█                        █
#█  Entrypoint: Menu      █
#█  • Меню (точка входа)  █
#█                        █
#▀────────────────────────▀
entrypoint:Menu() { view 'init'; while :; do
#┌──────────────────────┐
#│ Текущий каталог пуст │
#└──────────────────────┘
    if modelView:Notice 'warning' 'current_dir_is_empty'; then
    # Предлагаем пользователю склонировать репозиторий
        view:Menu 'gitclone'
        continue
    fi
    
#┌──────────────────────────┐
#│ Каталог ".git" не найден │
#└──────────────────────────┘
    if modelView:Notice 'error' 'no_git'; then
    # Предлагаем пользователю выбрать пустой каталог
        view:Menu 'dir_error'
        continue
    fi
    
#┌─────────────────┐
#│ Образ не найден │
#└─────────────────┘
    if controller:Docker 'no_image'; then
    # Предлагаем пользователю установить образ
        view:Menu 'install'
        continue
    fi
    
#┌─────────────────────┐
#│ Контейнер не найден │
#└─────────────────────┘
    if controller:Docker 'no_container'; then
    # Предлагаем пользователю запустить контейнер
        view:Menu 'start'
        continue
    fi
    
#┌──────────────────────────┐
#│ Запущен старый контейнер │
#└──────────────────────────┘
    if modelView:Notice 'warning' 'run_old'; then
    # Предлагаем пользователю только остановить контейнер
        view:Menu 'stop'
        continue
    fi
    
#┌───────────────────┐
#│ Контейнер запущен │
#└───────────────────┘
    view:Menu 'restart' # Выводим меню на экран
done
}
