#!/bin/bash
#┌─────────────────────────────┐
#│ Создаем дополнительный порт │
#└─────────────────────────────┘
let PORT=($1+1)

#┌─────────────────────┐
#│ Запускаем контейнер │
#└─────────────────────┘
clear
echo "Starting..."
containerID=$(docker run -e "DOCKER_PWD=/$(PWD)" -v /$(PWD):/$2 -v /$(PWD)/ssh:/root/.sshsource --privileged -v "//var/run/docker.sock:/var/run/docker.sock" -it -d --restart unless-stopped -p $1:$1 -p $PORT:$PORT -e "C9_PORT=$1" -e "PORT=$PORT" -e "GIT_USER=$3" -e "WORKSPACE=$2" -h $2 --name $2 $4)

echo "containerID=$containerID"
# docker exec $containerID /bin/bash "echo $containerID > /root/.container_id"
echo "$2 is running on http://localhost:$1/"
