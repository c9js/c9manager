#▄─────────────────────▄1.0.15
#█                     █
#█  Пространство имен  █
#█                     █
#▀─────────────────────▀
#┌─────────────────┐
#│ Card (открытка) │
#└─────────────────┘
notice:Card()  { core:Card 'card'        "$@"; } # Выводит уведомление на экран
notice:Error() { core:Card 'error'       "$@"; } # Выводит сообщение об ошибке
fatal_error()  { core:Card 'fatal_error' "$@"; } # Выводит сообщение о фатальной ошибке

#┌─────────────────────┐
#│ Input (ввод данных) │
#└─────────────────────┘
input() { core:Input 'input' "$@"; } # Предлагает пользователю ввести данные вручную

#┌─────────────┐
#│ Menu (меню) │
#└─────────────┘
reset:Menu()   { core:Menu 'reset:Menu'   "$@"; } # Обнуляет сохраненные состояния пунктов меню
menu:AddItem() { core:Menu 'menu:AddItem' "$@"; } # Добавляет новый пункт в список пунктов меню
menu:Update()  { core:Menu 'menu:Update'  "$@"; } # Обновляет пункты меню
menu:Msg()     { core:Menu 'menu:Msg'     "$@"; } # Добавляет новое сообщение
menu:MsgAdd()  { core:Menu 'menu:MsgAdd'  "$@"; } # Добавляет еще одно новое сообщение
menu:Low()     { core:Menu 'menu:Low'     "$@"; } # Добавляет новое сообщение (если других сообщений еще не было)
menu:Message() { core:Menu 'message'      "$@"; } # Выводит сообщение на экран
menu()         { core:Menu 'menu'         "$@"; } # Выводит меню на экран
Exit()         { core:Menu 'exit'         "$@"; } # Добавляет последний пункт и выводит меню на экран

#┌───────────────────────┐
#│ Navigator (навигатор) │
#└───────────────────────┘
navigator()   { core:Navigator 'section' "$@"; } # Переходит в новый раздел (без сохранения истории)
nav:Pages()   { core:Navigator 'pages'   "$@"; } # Переходит в новый раздел из pages (без сохранения истории)
nav:Init()    { core:Navigator 'init'    "$@"; } # Инициализирует навигатор
nav:Next()    { core:Navigator 'next'    "$@"; } # Переходит в следующий раздел
nav:Back()    { core:Navigator 'back'    "$@"; } # Переходит в предыдущий раздел
nav:Current() { core:Navigator 'current' "$@"; } # Переходит в текущий раздел
nav:Main()    { core:Navigator 'main'    "$@"; } # Переходит в главный раздел
nav:Exit()    { core:Navigator 'exit'        ; } # Завершает процесс

#┌────────────────────────┐
#│ Pages (список страниц) │
#└────────────────────────┘
pages:Exit()   { core:Pages 'exit'   "$@"; } # Выходит из списка пунктов (для выбранного меню)
pages:Back()   { core:Pages 'back'   "$@"; } # Возвращает пользователя обратно в меню
pages:Load()   { core:Pages 'load'   "$@"; } # Получает список пунктов (для выбранного меню)
pages:Menu()   { core:Pages 'menu'   "$@"; } # Выводит список пунктов (для выбранного меню)
pages:Pick()   { core:Pages 'pick'   "$@"; } # Обрабатывает выбранный пункт (для выбранного меню)
pages:Skip()   { core:Pages 'skip'   "$@"; } # Возвращает количество пропущенных пунктов
pages:Count()  { core:Pages 'count'  "$@"; } # Возвращает количество получаемых пунктов
pages:Items()  { core:Pages 'items'  "$@"; } # Создает список пунктов (для выбранного меню)
pages:Header() { core:Pages 'header' "$@"; } # Обновляет заголовок меню

#┌──────────────┐
#│ Menu (цвета) │
#└──────────────┘
Yellow() { menu:AddItem 'Yellow' "$@"; } # Добавляет пункт желтого цвета
Green()  { menu:AddItem 'Green'  "$@"; } # Добавляет пункт зеленого цвета
Red()    { menu:AddItem 'Red'    "$@"; } # Добавляет пункт красного цвета

#┌────────────────────┐
#│ Menu (уведомления) │
#└────────────────────┘
info()    { menu:Msg 'Blue'   "$(notice:Card  "$@")"; } # Выводит информационное сообщение
success() { menu:Msg 'Green'  "$(notice:Card  "$@")"; } # Выводит сообщение об успешном завершении
warning() { menu:Msg 'Yellow' "$(notice:Card  "$@")"; } # Выводит сообщение с предупреждением
error()   { menu:Msg 'Red'    "$(notice:Error "$@")"; } # Выводит сообщение об ошибке
msg()     { menu:Msg ''       "$(notice:Card  "$@")"; } # Выводит сообщение без цвета

#┌────────────────────────────────────────────┐
#│ Menu (если других уведомлений еще не было) │
#└────────────────────────────────────────────┘
info:low()    { menu:Low 'Blue'   "$(notice:Card  "$@")"; } # Выводит информационное сообщение
success:low() { menu:Low 'Green'  "$(notice:Card  "$@")"; } # Выводит сообщение об успешном завершении
warning:low() { menu:Low 'Yellow' "$(notice:Card  "$@")"; } # Выводит сообщение с предупреждением
error:low()   { menu:Low 'Red'    "$(notice:Error "$@")"; } # Выводит сообщение об ошибке
msg:low()     { menu:Low ''       "$(notice:Card  "$@")"; } # Выводит сообщение без цвета

#┌────────────────────────┐
#│ Cli (командная строка) │
#└────────────────────────┘
cli:RUN()   { core:Cli 'run'   "$@"; } # Выполняет переданную команду
cli:Help()  { core:Cli 'help'  "$@"; } # Выводит справочную информацию
cli:Error() { core:Cli 'error' "$@"; } # Выводит сообщение об ошибке

#┌────────────────────────┐
#│ Base (базовые функции) │
#└────────────────────────┘
IF()            { core:Base 'IF'            "$@"; } # Условный (тернарный) оператор
trace()         { core:Base 'trace'         "$@"; } # Инструмент для отладки кода
number()        { core:Base 'number'        "$@"; } # Переводит строку в число
progressBar()   { core:Base 'progressBar'   "$@"; } # Выводит графическое состояние загрузки
progressBarBg() { core:Base 'progressBarBg' "$@"; } # Выводит графическое состояние загрузки (без спец. символов)
procent()       { core:Base 'procent'       "$@"; } # Высчитывает процент
escape()        { core:Base 'escape'        "$@"; } # Экранирует все спец. символы в строке
char()          { core:Base 'char'          "$@"; } # Выводит символ N раз

#┌────────────────────────────┐
#│ Array (работа с массивами) │
#└────────────────────────────┘
array:includes() { core:Array 'includes' "$@"; } # Проверяет содержит-ли массив указанный элемент

#┌──────────────────────────┐
#│ Opts (опции и аргументы) │
#└──────────────────────────┘
opt()       { core:Opts 'opt'    "$@" ; } # Возвращает значение опции
arg()       { core:Opts 'arg'    "$@" ; } # Возвращает значение аргумента
is:opt()    { core:Opts 'is_opt' "$@" ; } # Проверяет опцию
is:arg()    { core:Opts 'is_arg' "$@" ; } # Проверяет аргумент
no:opt()    { core:Opts 'no_opt' "$@" ; } # Проверяет опцию (возвращает противоположный результат)
no:arg()    { core:Opts 'no_arg' "$@" ; } # Проверяет аргумент (возвращает противоположный результат)
args:set()  { core:Opts 'set'    "$@" ; } # Создает список опций и аргументов
opts:add()  { core:Opts 'add'    "$@" ; } # Добавляет новую опцию
opts:Dump() { core:Opts 'dump'        ; } # Выводит дамп со списком опций и аргументов

#┌─────────────────────────────────────────┐
#│ Filesystem (работа с файловой системой) │
#└─────────────────────────────────────────┘
is_empty_dir() { core:Filesystem 'is_empty_dir' "$@"; } # Проверяет пуст-ли каталог
is_exists()    { core:Filesystem 'is_exists'    "$@"; } # Проверяет существует-ли файл или каталог
is_dir()       { core:Filesystem 'is_dir'       "$@"; } # Проверяет существует-ли каталог
is_file()      { core:Filesystem 'is_file'      "$@"; } # Проверяет существует-ли файл
get_file()     { core:Filesystem 'get_file'     "$@"; } # Получает содержимое файла
save_file()    { core:Filesystem 'save_file'    "$@"; } # Сохраняет содержимое в файл
remove_file()  { core:Filesystem 'remove_file'  "$@"; } # Удаляет файл
rename_dir()   { core:Filesystem 'rename_dir'   "$@"; } # Переименовывает каталог
dir_count()    { core:Filesystem 'dir_count'    "$@"; } # Получает количество каталогов
dir_list()     { core:Filesystem 'dir_list'     "$@"; } # Получает список каталогов

#┌────────────────┐
#│ Docker (докер) │
#└────────────────┘
docker:isImage()       { core:Docker 'isImage'       "$@"; } # Проверяет существуют-ли образы
docker:isContainer()   { core:Docker 'isContainer'   "$@"; } # Проверяет существуют-ли контейнеры
docker:containerInfo() { core:Docker 'containerInfo' "$@"; } # Получает информацию о запущенном контейнере
docker:getPort()       { core:Docker 'getPort'       "$@"; } # Получает внешний порт

#┌────────────────┐
#│ Stream (стрим) │
#└────────────────┘
stream:Void() { core:Stream 'void'   "$@"; } # Пустой стрим
stream()      { core:Stream 'stream' "$@"; } # Потоковый стрим
RUN()         { core:Stream 'run'    "$@"; } # Обычный стрим

#┌──────────────────────┐
#│ Notice (уведомление) │
#└──────────────────────┘
notice() { core:Notice "$@"; } # Выполняет список команд

#┌────────────────────────┐
#│ Runner (запуск команд) │
#└────────────────────────┘
runner()   { core:Runner 'run_list' "$@"; } # Выполняет список команд
progress() { core:Runner 'progress' "$@"; } # Обновляет текущий прогресс
log()      { core:Runner 'log'      "$@"; } # Сохраняет сообщение в лог

#┌───────────────────┐
#│ Valid (валидация) │
#└───────────────────┘
isValidVersion()     { core:Valid 'isValidVersion'     "$@"; } # Проверяет верно-ли указана версия
isValidPort()        { core:Valid 'isValidPort'        "$@"; } # Проверяет верно-ли указан порт
isValidPortsCount()  { core:Valid 'isValidPortsCount'  "$@"; } # Проверяет верно-ли указано количество портов
git:isValidMessage() { core:Valid 'git:isValidMessage' "$@"; } # Проверяет верно-ли указано описание коммита
git:isValidUser()    { core:Valid 'git:isValidUser'    "$@"; } # Проверяет верно-ли указано имя git-юзера
git:isValidRepo()    { core:Valid 'git:isValidRepo'    "$@"; } # Проверяет верно-ли указано имя git-репозитория
docker:isValidUser() { core:Valid 'docker:isValidUser' "$@"; } # Проверяет верно-ли указан логин от docker-репозитория
docker:isValidPass() { core:Valid 'docker:isValidPass' "$@"; } # Проверяет верно-ли указан пароль от docker-репозитория
isValidProject()     { core:Valid 'isValidProject'     "$@"; } # Проверяет верно-ли указано имя проекта
