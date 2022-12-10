#!/bin/bash
#┌──────────────────────────────┐
#│ Останавливаем все контейнеры │
#└──────────────────────────────┘
clear
echo "Removing all containers."
echo "[1/2] Stopping..."
docker stop $(docker ps -aq)

#┌────────────────────────┐
#│ Удаляем все контейнеры │
#└────────────────────────┘
clear
echo "Removing all containers."
echo "[2/2] Cleaning..."
docker rm $(docker ps -aq)

#┌────────────────────────────┐
#│ Выводим список контейнеров │
#└────────────────────────────┘
clear
echo "All containers is removed!"
docker ps
