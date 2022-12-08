## Быстрый старт для WINDOWS
1. Запустите cmd.exe
2. Перейдите в пустой каталог.
3. Ведите команду:
```
docker run -itv "//var/run/docker.sock:/var/run/docker.sock" -e "CD=%CD%" --privileged --rm c9js/c9start:latest
```


## Быстрый старт для LINUX
1. Запустите bash
2. Перейдите в пустой каталог.
3. Ведите команду:
```
docker run -itv "//var/run/docker.sock:/var/run/docker.sock" -e "CD=$(PWD)" --privileged --rm c9js/c9start:latest
```

## TODO
Имя нового workspace не должно быть:
```
".c9"
"apks"
"bin"
"dev"
"etc"
"home"
"lib"
"media"
"mnt"
"opt"
"proc"
"root"
"run"
"sbin"
"srv"
"sys"
"tmp"
"usr"
"var"
".dockerenv"
```
