#▄─────────────────────────▄
#█                         █
#█  Controller: Deploy     █
#█  • Деплой (управление)  █
#█                         █
#▀─────────────────────────▀
controller:Deploy() { case "$1" in
    'stop')     model:Deploy "$@" ;; # Останавливает деплой
    'continue') model:Deploy "$@" ;; # Пробует еще раз продолжить деплой
    'start')    model:Deploy "$@" ;; # Начинает один из вариантов деплоя
esac
}
