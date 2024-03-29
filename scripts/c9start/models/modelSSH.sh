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
        P_SSH_DIR="${P}${SEP}$SSH_DIR"
        
    # Сохраняем путь к SSH-файлу вне docker-а
        P_SSH_FILE="${P}${SEP}${SSH_DIR}${SEP}$NEW_SSH_KEY"
        
    # Выполняем список команд
        runner "${SSH_LIST[@]}"
        
    # Возвращаемся в меню
        navigator 'ssh_keygen'
    ;;
esac
}
