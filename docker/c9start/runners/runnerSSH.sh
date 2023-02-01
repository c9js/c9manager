#▄──────────────────────────────▄
#█                              █
#█  Runner: SSH                 █
#█  • SSH-ключ (запуск команд)  █
#█                              █
#▀──────────────────────────────▀
runner:SSH() { case "$1" in
#┌───────────────────────┐
#│ Проверяет SSH-каталог │
#└───────────────────────┘
    'check_dir')
    # Создаем каталог (только если его нет)
        mkdir -p "$CURRENT_PATH/$SSH_DIR"
    ;;
    
#┌────────────────────┐
#│ Проверяет SSH-ключ │
#└────────────────────┘
    'check_key')
        ! is_exists "$CURRENT_PATH/$SSH_DIR/$NEW_SSH_KEY"
    ;;
    
#┌────────────────────────┐
#│ Создает новый SSH-ключ │
#└────────────────────────┘
    'ssh_keygen')
        ssh-keygen -t 'rsa' -N '' -C '' -f "$CURRENT_PATH/$SSH_DIR/$NEW_SSH_KEY"
    ;;
esac
}
