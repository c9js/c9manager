## Быстрый старт для WINDOWS
1. Запустите cmd.exe
2. Перейдите в пустую директорию.
3. Ведите команду:
```
docker run -itv "//var/run/docker.sock:/var/run/docker.sock" -e "CD=%CD%" --privileged --rm c9js/c9start:1.0.36
```


## Быстрый старт для LINUX
1. Запустите bash
2. Перейдите в пустую директорию.
3. Ведите команду:
```
docker run -itv "//var/run/docker.sock:/var/run/docker.sock" -e "CD=$(PWD)" --privileged --rm c9js/c9start:1.0.36
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

## Правильные права доступа к ssh-key
```
https://serverfault.com/questions/253313/ssh-returns-bad-owner-or-permissions-on-ssh-config
```

## Сгенерировать новый ssh-key
```
ssh-keygen -t rsa -b 4096 -C "email@email.email"
```

## Выполнить команду в контейнере
```
docker exec CONTAINER_ID command
```

## Сохранить в файл "/1.log"
```
require('fs').appendFileSync('/1.log', JSON.stringify('Hello world!', 4, '    ') + '\n');
```

## Выполнить файл "синхронно"
```
console.log(require('child_process').spawnSync('/main/8.sh').stdout.toString());
```

## Получить содержимое файла "синхронно"
```
console.log(require('fs').readFileSync('/main/installing').toString());
```

## Font
```
sans-sans
```
