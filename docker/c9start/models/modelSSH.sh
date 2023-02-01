#▄───────────────────────▄
#█                       █
#█  Model: SSH           █
#█  • SSH-ключ (логика)  █
#█                       █
#▀───────────────────────▀
model:SSH() { case "$1" in
#┌────────────────────────┐
#│ Создает новый SSH-ключ │
#└────────────────────────┘
    'ssh_keygen')
    # Список аргументов
        local file_name="$2" # Имя файла для SSH-ключа
        
    # Сохраняем новое имя файла для SSH-ключа
        NEW_SSH_KEY="$file_name"
        
    # Сохраняем путь к SSH-каталогу вне docker-а
        CD_SSH_DIR="${CD}${SEP}$SSH_DIR"
        
    # Сохраняем путь к SSH-файлу вне docker-а
        CD_SSH_FILE="${CD}${SEP}${SSH_DIR}${SEP}$NEW_SSH_KEY"
        
    # Выполняем список команд
        modelView:Runner 'run_list' "${SSH_LIST[@]}"
        
    # Возвращаемся в меню
        menu:Back
    ;;
esac
}
