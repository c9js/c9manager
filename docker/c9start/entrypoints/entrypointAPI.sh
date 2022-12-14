#▄─────────────────────────────────────▄
#█                                     █
#█  Entrypoint: API                    █
#█  • Внутренний запрос (точка входа)  █
#█                                     █
#▀─────────────────────────────────────▀
entrypoint:API() { shift; case "$1" in
    'is_empty_dir') model:API "$@" ;; # Проверяет пуст-ли каталог
    'is_exists')    model:API "$@" ;; # Проверяет существует-ли файл или каталог
    'dir_exists')   model:API "$@" ;; # Проверяет существует-ли каталог
    'file_exists')  model:API "$@" ;; # Проверяет существует-ли файл
    'ssh_keygen')   model:API "$@" ;; # Создает новый ssh-ключ
    'gitclone')     model:API "$@" ;; # Клонирует репозиторий
esac
}
