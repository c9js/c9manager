## Быстрый старт для WINDOWS
1. Запустите cmd.exe
2. Перейдите в пустой каталог.
3. Ведите команду:
```
docker run -itv"//var/run/docker.sock:/var/run/docker.sock" -e"P=%CD%" --privileged --rm c9js/c9start
```


## Быстрый старт для LINUX
1. Запустите bash
2. Перейдите в пустой каталог.
3. Ведите команду:
```
docker run -itv"//var/run/docker.sock:/var/run/docker.sock" -e"P=$(PWD)" --privileged --rm c9js/c9start
```
