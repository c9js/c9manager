#!/bin/bash
#┌─────────────────────┐
#│ Версия по умолчанию │
#└─────────────────────┘
    IMAGE_RUN='c9js/c9docker:1.0.41'
    if [[ $1 != '' ]]; then
        IMAGE_RUN="c9js/c9docker:$1"
    fi
    
#┌────────────────────┐
#│ Выводим имя образа │
#└────────────────────┘
echo "Образ '$IMAGE_RUN'"
    
#┌────────────────────────────────┐
#│ Останавливаем старый контейнер │
#└────────────────────────────────┘
clear
echo "Starting '$IMAGE_RUN'"
echo "[1/2] Stopping..."
docker stop $(docker ps -aq --filter "ancestor=$IMAGE_RUN")

#┌──────────────────────────┐
#│ Удаляем старый контейнер │
#└──────────────────────────┘
clear
echo "Starting '$IMAGE_RUN'"
echo "[2/2] Cleaning..."
docker rm $(docker ps -aq --filter "ancestor=$IMAGE_RUN")

#┌─────────────────────┐
#│ Запускаем контейнер │
#└─────────────────────┘
./run '8000' 'c9manager' 'c9js' "$IMAGE_RUN"