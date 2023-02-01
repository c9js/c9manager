#▄───────────────────────────▄
#█                           █
#█  Controller: SSH          █
#█  • SSH-ключ (управление)  █
#█                           █
#▀───────────────────────────▀
controller:SSH() { case "$1" in
    'ssh_keygen') model:SSH "$@" ;; # Создает новый SSH-ключ
esac
}
