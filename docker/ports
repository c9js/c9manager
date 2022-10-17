#!/usr/bin/node
/*────────────────────────────────────────────────────────────────────────────────────────────────*/

const fs = require('fs');
const path = require('path');
const _PORT = Number(process.env.PORT);
const _C9_PORT = Number(process.env.C9_PORT);

/*▄─────────────────────────────────────▄
  █                                     █
  █  Пример объекта со списоком портов  █
  █                                     █
  ▀─────────────────────────────────────▀*/
/*[
// Список ContainerID
    {
        "host_container": [8000, 8001],
        "fdd6fbe34bb2": [8002, 8003],
        "0e28888d43b3": [8004, 8005],
    },
    
// Список занятых портов
    {
        "8000": "host_container",
        "8001": "host_container",
        "8002": "fdd6fbe34bb2",
        "8003": "fdd6fbe34bb2",
        "8004": "0e28888d43b3",
        "8005": "0e28888d43b3"
    }
]*/
/*▄─────────────────────────────────────────▄
  █                                         █
  █  Тут я буду работать с объектом {list}  █
  █                                         █
  ▀─────────────────────────────────────────▀*/
class Ports {
/*┌──────────────────────────────────────────────────┐
  │ По умолчанию объект со списоком портов не создан │
  └──────────────────────────────────────────────────┘*/
    static _list = 'No init!';
    
/*┌────────────────────────────────┐
  │ Путь к файлу со списком портов │
  └────────────────────────────────┘*/
    static _path = path.join(process.env.HOME, 'ports.json');
    
/*┌────────────────────────────────────────────┐
  │ Возвращает сокращенный вариант ContainerID │
  └────────────────────────────────────────────┘*/
    static getContainerID(containerID) {
    // Сокращаем до 12 символов
        return (containerID+'').substring(0, 12);
    }
    
/*┌─────────────────────────────────────────┐
  │ Безопасный перевод строки в JSON-объект │
  └─────────────────────────────────────────┘*/
    static getJson(str) {
    // Создаем пустой JSON-объект
        let json = [];
        
    // Пробуем перевести строку в JSON-объект
        try {
            json = JSON.parse(str);
        }
        
    // В случае ошибки ничего не делаем
        catch (e) {}
        
    // Возвращаем JSON-объект
        return json;
    }
    
/*┌────────────────────────────────────────────┐
  │ Загружает список портов из файла list.json │
  └────────────────────────────────────────────┘*/
    static load() {
    // Загружаем список портов
        let str = fs.readFileSync(this._path, {encoding:'utf8', flag:'a+'});
        
    // Переводим строку в JSON-объект
        this._list = Ports.getJson(str);
        
    // Проверяем стартовый порт
        if (!_C9_PORT || _C9_PORT < 1) {
        // Возвращаем сообщение об ошибке
            process.stderr.write('Порт не найден!\n');
            process.stderr.write("C9_PORT: '"+_C9_PORT+"'\n");
            
        // Выходим с ошибкой
            process.exit(1);
        }
        
    // Проверяем существует-ли объект со списком портов
        if (!Object.prototype.hasOwnProperty.call(this._list, 'ids')) {
        // Создаем объект со списком портов
            this._list = {
            // Список ContainerID
                ids: {},
                
            // Список занятых портов
                ports: {}
            };
            
        // Добавляем новые порты в список портов
            Ports.add('host_container', _C9_PORT);
            Ports.add('host_container', _PORT);
        }
    }
    
/*┌──────────────────────────────────────────┐
  │ Сохраняет список портов в файл list.json │
  └──────────────────────────────────────────┘*/
    static save() {
    // Объект со списоком портов еще не создан!
        if (this._list == 'No init!') return;
        
    // Сохраняем список портов
        fs.writeFileSync(this._path, JSON.stringify(this._list, null, '    '));
        
    // Выходим с успешным завершением процесса
        process.exit(0);
    }
    
/*┌──────────────────────────────────────┐
  │ Добавляет новый порт в список портов │
  └──────────────────────────────────────┘*/
    static add(containerID, port) {
    // Объект со списоком портов еще не создан!
        if (this._list == 'No init!') return;
        
    // Добавляем порт
        this._list.ports[port] = containerID;
        
    // ContainerID еще не создан
        if (!this._list.ids[containerID]?.length) {
            this._list.ids[containerID] = [];
        }
        
    // Если порт ранее был добавлен, то больше ничего не делаем
        for (let i = 0; i < this._list.ids[containerID].length; i++) {
            if (this._list.ids[containerID][i] == port) return;
        }
        
    // Добавляем containerID
        this._list.ids[containerID].push(port);
    }
    
/*┌───────────────────────────────────────────────┐
  │ Возвращает строку со списком свободных портов │
  └───────────────────────────────────────────────┘*/
    static getFreePorts(count) {
    // Объект со списоком портов еще не создан!
        if (this._list == 'No init!') return;
        
    // Создаем список свободных портов
        let freePorts = [];
        
    // Проходим по списку портов
        for (let port = _C9_PORT; port <= _C9_PORT + 999; port++) {
        // Если порт свободен,
        // то добавляем его в список
            if (!this._list.ports[port]) {
                freePorts.push(port);
            }
            
        // Добавлено достаточное количество портов
            if (freePorts.length >= count) {
                break;
            }
        }
        
    // Переводим список в строку
        freePorts = freePorts.join(' ');
        
    // Возвращаем список свободных портов
        process.stdout.write(freePorts);
        
    // Выходим с успешным завершением процесса
        process.exit(0);
    }
    
/*┌───────────────────────────────────────┐
  │ Удаляем все порты занятые containerID │
  └───────────────────────────────────────┘*/
    static remove(containerID) {
    // Объект со списоком портов еще не создан!
        if (this._list == 'No init!') return;
        
    // ContainerID уже удален
        if (!this._list.ids[containerID]?.length) return;
        
    // Проходим по списку портов
        for (let i = 0; i < this._list.ids[containerID].length; i++) {
        // Удаляем порт из списка
            delete this._list.ports[this._list.ids[containerID][i]];
        }
        
    // Удаляем containerID
        delete this._list.ids[containerID];
    }
}

/*▄─────────────────────────────────▄
  █                                 █
  █  Далее идут консольные запросы  █
  █                                 █
  ▀─────────────────────────────────▀*/
let action = process.argv[2];

/*┌───────────────────────────────────────────────────┐
  │ GetFreePorts — Возвращает список свободных портов │
  └───────────────────────────────────────────────────┘*/
    if (action == 'getFreePorts') {
    // Количество портов
        let count = Number(process.argv[3]);
        count = !count || count < 1 ? 1 : count;
        count = count > 999 ? 999 : count;
        
    // Загружаем список портов из файла
        Ports.load();
        
    // Возвращает список свободных портов
        Ports.getFreePorts(count);
    }
    
/*┌───────────────────────────────────────┐
  │ Add — Привязывает порты к containerID │
  └───────────────────────────────────────┘*/
    if (action == 'add') {
        let containerID = Ports.getContainerID(process.argv[3]);
        let port = Number(process.argv[4]);
        
    // Загружаем список портов из файла
        Ports.load();
        
    // Добавляем новый порт в список портов
        Ports.add(containerID, port);
        
    // Сохраняем список портов в файл
        Ports.save();
    }
    
/*┌──────────────────────────────────┐
  │ Remove — Удаляет порты из списка │
  └──────────────────────────────────┘*/
    if (action == 'remove') {
        let containerID = Ports.getContainerID(process.argv[3]);
        
    // Загружаем список портов из файла
        Ports.load();
        
    // Удаляем все порты занятые containerID
        Ports.remove(containerID);
        
    // Сохраняем список портов в файл
        Ports.save();
    }
    
/*────────────────────────────────────────────────────────────────────────────────────────────────*/