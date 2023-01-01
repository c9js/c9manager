#!/bin/bash
#┌──────────────────────────────┐
#│ Останавливаем все контейнеры │
#└──────────────────────────────┘
clear
echo "Removing all containers and images."
echo "[1/3] Stopping..."
docker stop $(docker ps -aq)

#┌────────────────────────┐
#│ Удаляем все контейнеры │
#└────────────────────────┘
clear
echo "Removing all containers and images."
echo "[2/3] Cleaning..."
docker rm $(docker ps -aq)

#┌────────────────────┐
#│ Удаляем все образы │
#└────────────────────┘
clear
echo "Removing all containers and images."
echo "[3/3] Cleaning..."
docker rmi $(docker images -aq) -f

#┌──────────────────────────────────────┐
#│ Выводим список контейнеров и образов │
#└──────────────────────────────────────┘
clear
echo "All containers and images is removed!"
docker ps
docker images