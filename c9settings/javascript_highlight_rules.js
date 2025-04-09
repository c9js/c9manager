/* ***** BEGIN LICENSE BLOCK *****
 * Distributed under the BSD license:
 *
 * Copyright (c) 2010, Ajax.org B.V.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of Ajax.org B.V. nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL AJAX.ORG B.V. BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ***** END LICENSE BLOCK ***** */

define(function(require, exports, module) {
"use strict";

var oop = require("../lib/oop");
var DocCommentHighlightRules = require("./doc_comment_highlight_rules").DocCommentHighlightRules;
var TextHighlightRules = require("./text_highlight_rules").TextHighlightRules;

// TODO: Unicode escape sequences
var identifierRe = "[a-zA-Z\\$_\u00a1-\uffff][a-zA-Z\\d\\$_\u00a1-\uffff]*";
var privateIdentifierRe = "[_][^_][a-zA-Z\\d\\$_\u00a1-\uffff]*";

var JavaScriptHighlightRules = function(options) {
    // see: https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects
    var keywordMapper = this.createKeywordMapper({
        "variable.language":
            "Array|Boolean|Date|Function|Iterator|Number|Object|RegExp|String|Proxy|"  + // Constructors
            "Namespace|QName|XML|XMLList|"                                             + // E4X
            "ArrayBuffer|Float32Array|Float64Array|Int16Array|Int32Array|Int8Array|"   +
            "Uint16Array|Uint32Array|Uint8Array|Uint8ClampedArray|"                    +
            "Error|EvalError|InternalError|RangeError|ReferenceError|StopIteration|"   + // Errors
            "SyntaxError|TypeError|URIError|"                                          +
            "decodeURI|decodeURIComponent|encodeURI|encodeURIComponent|eval|isFinite|" + // Non-constructor functions
            "isNaN|parseFloat|parseInt|"                                               +
            "JSON|Math|"                                                               + // Other
            "Atomics|Buffer|DataView|SharedArrayBuffer|"                               +
            "BigInt|BigInt64Array|BigUint64Array|"                                     +
            "Buffer|"                                                                  +
            "Intl|"                                                                    +
            "Map|Set|WeakMap|WeakSet|"                                                 +
            "TextEncoder|TextDecoder|"                                                 +
            "URL|URLSearchParams|"                                                     +
            "Promise|Reflect|Symbol|"                                                  +
            "WebAssembly|"                                                             +
            "exports|module|process|require|"                                          + // Node.js
            "global|GLOBAL|globalThis|root|"                                           +
            "this|super|arguments|prototype|window|document"                           , // Pseudo
        "keyword":
            "const|yield|import|get|set|async|await|" +
            "break|case|catch|continue|default|delete|do|else|finally|for|function|" +
            "if|in|of|instanceof|new|return|switch|throw|try|typeof|let|var|while|with|debugger|" +
            // invalid or reserved
            "__parent__|__count__|escape|unescape|with|__proto__|" +
            "class|enum|extends|export|implements|private|public|interface|package|protected|static",
        "storage.type":
            "const|let|var|function",
        "constant.language":
            "null|Infinity|NaN|undefined|"                                             +
            "__dirname|__filename"                                                     , // Node.js
        "support.function":
            "alert",
        "constant.language.boolean": "true|false"
    }, "identifier");

    // keywords which can be followed by regular expressions
    var kwBeforeRe = "case|do|else|finally|in|instanceof|return|throw|try|typeof|yield|void";

    var escapedRe = "\\\\(?:x[0-9a-fA-F]{2}|" + // hex
        "u[0-9a-fA-F]{4}|" + // unicode
        "u{[0-9a-fA-F]{1,6}}|" + // es6 unicode
        "[0-2][0-7]{0,2}|" + // oct
        "3[0-7][0-7]?|" + // oct
        "[4-7][0-7]?|" + //oct
        ".)";
    // regexp must not have capturing parentheses. Use (?:) instead.
    // regexps are ordered -> the first match is used

    this.$rules = {
        /*┌────────────────────────────────────────────────────────────────────────────────────────┐
        ┌─┤                                                                                        │
        │ │ Цепочка для глобального объекта пользователя                                           │
        │ └─→ $.***                                                                                │
        │                                                                                        ┌─┘
        └────────────────────────────────────────────────────────────────────────────────────────┘*/
        "global" : [
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Внисение изменений в прототип                                                      │
            │ ├─→ $.Sound.param.prototype.play =                                                   │
            │ ├─→ $.Sound.prototype.play =                                                         │
            │ └─→ $.Sound.prototype =                                                              │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : [
                    "punctuation.operator", "storage.type"
                ],
                regex : "(\\.)(prototype\\b)"
            },
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Обращение к параметру                                                              │
            │ ├─→ $.Sound.param.param                                                              │
            │ └─→ $.Sound.param                                                                    │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : [
                    "punctuation.operator", "global2"
                ],
                regex : "(\\.)(" + identifierRe + ")(?=[.])"
            },
            
            //──────────────────────────────────────────────────────────────────────────────────────
            {
                regex: "",
                token: "empty",
                next: "no_regex"
            }
        ],
        "no_regex" : [
            DocCommentHighlightRules.getStartRule("doc-start"),
            comments("no_regex"),
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Глобальные объекты                                                                 │
            │ ├─→ clearImmediate(immediateObject)                                                  │
            │ ├─→ clearInterval(intervalObject)                                                    │
            │ ├─→ clearTimeout(timeoutObject)                                                      │
            │ ├─→ setImmediate(callback[, ...args])                                                │
            │ ├─→ setInterval(callback, delay[, ...args])                                          │
            │ ├─→ setTimeout(callback, delay[, ...args])                                           │
            │ ├─→ queueMicrotask(callback)                                                         │
            │ └─→ require()                                                                        │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : [
                    "variable.language", "paren.lparen"
                ],
                regex : "(clearImmediate|clearInterval|clearTimeout|setImmediate|setInterval|setTimeout|queueMicrotask|require)(\\()"
            },
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Глобальный объект пользователя "$.***"                                             │
            │ └─→ $.Sound                                                                          │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : [
                    "global1", "punctuation.operator", "global2"
                ],
                regex : "(\\$)(\\.)(" + identifierRe + ")",
                next: "global"
            },
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Глобальный объект для вывода сообщений в консоль "_=***"                           │
            │ └─→ _="Hello World!"                                                                 │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/

            {
                token : [
                    "log1", "log2"
                ],
                regex : "(_)(=)"
            },
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Глобальный объект для вывода сообщений в консоль "__=***"                          │
            │ └─→ __="Hello World!"                                                                │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : [
                    "log3", "log4", "log3"
                ],
                regex : "(_)(_)(=)"
            },
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Стрелочная функция внутри класса (без параметров)                                  │
            │ │ Визульно меняется с "=f=>" на " => "                                               │
            │ ├─→ class { play=f=>{ } }                                                            │
            │ └─→ class { play => { } }                                                            │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : [
                    "log5"
                ],
                regex : "(=f=>)"
            },
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Асинхронная стрелочная функция внутри класса (без параметров)                      │
            │ │ Визульно меняется с "=async f=>" на " => async "                                               │
            │ ├─→ class { play=async f=>{ } }                                                            │
            │ └─→ class { play => async { } }                                                            │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : [
                    "log6"
                ],
                regex : "(=async f=>)"
            },
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Приватные переменные (подчеркивание перед именем)                                  │
            │ └─→ _foo, _bar, _somePrivateVariable                                                 │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            /*
            {
                token : [
                    "private4", "private3", "private2"
                ],
                regex : "([_])([A-Z])([a-zA-Z\\d\\$_]*)"
            },
            */
            {
                token : [
                    "_private", "private"
                ],
                regex : "([_])([a-zA-Z\\d\\$][a-zA-Z\\d\\$_]*)"
            },
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Локальный объект "this._***" (подчеркивание перед именем)                          │
            │ └─→ this._***, this._foo, this._bar, this._somePrivateVariable                       │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : [
                    "privatethis", "punctuation.operator", "private"
                ],
                // regex : "(this)(\\.)([_]" + identifierRe + ")"
                regex : "(this)(\\.)(" + privateIdentifierRe + ")"
            },
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Локальный объект "this.***"                                                        │
            │ └─→ this.Sound                                                                       │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : [
                    "variable.language", "punctuation.operator", "identifier"
                ],
                regex : "(this)(\\.)([^_]" + identifierRe + "\\b)(?!\\()"
            },
            /*            
            {
                token : [
                    "variable.language", "punctuation.operator", "test1"
                ],
                regex : "(this)(\\.)(" + identifierRe + "\\b)(?!\\(|\\.)"
            },
            */
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Стрелочная функция                                                                 │
            │ └─→ (arg) => { }                                                                     │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : "paren.lparen",
                regex : "(\\()(?=.*\\)\\s*=>)",
                next: "function_arguments"
            },
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Анонимная функция                                                                  │
            │ └─→ function(arg) { }                                                                │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : [
                    "storage.type", "text", "paren.lparen"
                ],
                regex : "(function)(\\s*)(\\()",
                next: "function_arguments"
            },
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Именованная функция                                                                │
            │ └─→ function myFunc(arg) { }                                                         │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : [
                    "storage.type", "text", "entity.name.function", "text", "paren.lparen"
                ],
                regex : "(function)(\\s+)(" + identifierRe + ")(\\s*)(\\()",
                next: "function_arguments"
            },
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Именованный класс                                                                  │
            │ └─→ class myClass { }                                                                │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : [
                    "storage.type", "text", "entity.name.function", "text", "paren.lparen"
                ],
                regex : "(class)(\\s+)(" + identifierRe + ")(\\s*)(\\{)"
            },
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Присвоение стрелочной функции                                                      │
            │ ├─→ { play : (arg) => { } }                                                          │
            │ └───→ play = (arg) => { }                                                            │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : "support.function",
                regex : "(" + identifierRe + ")(?=\\s*(:|=)\\s*\\(.*\\)\\s*=>)"
            },
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Присвоение анонимной функции                                                       │
            │ ├─→ { play : function(arg) { } }                                                     │
            │ └───→ play = function(arg) { }                                                       │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : "support.function",
                regex : "(" + identifierRe + ")(?=\\s*(:|=)\\s*function\\s*\\(.*\\))"
            },
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Присвоение именованной функции                                                     │
            │ ├─→ { play : function myFunc(arg) { } }                                              │
            │ └───→ play = function myFunc(arg) { }                                                │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : "support.function",
                regex : "(" + identifierRe + ")(?=\\s*(:|=)\\s*function\\s*" + identifierRe + "\\s*\\(.*\\))"
            },
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Присвоение анонимного класса                                                       │
            │ ├─→ { play : class { } }                                                             │
            │ └───→ play = class { }                                                               │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : "support.function",
                regex : "(" + identifierRe + ")(?=\\s*(:|=)\\s*class\\s*\\{)"
            },
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Присвоение именованного класса                                                     │
            │ ├─→ { play : class myClass { } }                                                     │
            │ └───→ play = class myClass { }                                                       │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : "support.function",
                regex : "(" + identifierRe + ")(?=\\s*(:|=)\\s*class\\s*" + identifierRe + "\\s*\\{)"
            },
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Внисение изменений в прототип                                                      │
            │ ├─→ Sound.prototype.play =                                                           │
            │ └─→ Sound.prototype =                                                                │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : [
                    "punctuation.operator", "storage.type"
                ],
                regex : "(\\.)(prototype\\b)"
            },
            //──────────────────────────────────────────────────────────────────────────────────────
            {
                token : "string",
                regex : "'(?=.)",
                next  : "qstring"
            }, {
                token : "string",
                regex : '"(?=.)',
                next  : "qqstring"
            }, {
                token : "constant.numeric", // hexadecimal, octal and binary
                regex : /0(?:[xX][0-9a-fA-F]+|[oO][0-7]+|[bB][01]+)\b/
            }, {
                token : "constant.numeric", // decimal integers and floats
                regex : /(?:\d\d*(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+\b)?/
            }, {
                // from "module-path" (this is the only case where 'from' should be a keyword)
                token : "keyword",
                regex : "from(?=\\s*('|\"))"
            }, {
                token : "keyword",
                regex : "(?:" + kwBeforeRe + ")\\b",
                next : "start"
            }, {
                token : ["support.constant"],
                regex : /that\b/
            }, {
                token : ["storage.type", "punctuation.operator", "support.function.firebug"],
                regex : /(console)(\.)(warn|info|log|error|time|trace|timeEnd|assert)\b/
            }, {
                token : keywordMapper,
                regex : identifierRe
            }, {
                token : "punctuation.operator",
                regex : /[.](?![.])/,
                next  : "property"
            }, {
                token : "storage.type",
                regex : /=>/,
                next  : "start"
            }, {
                token : "keyword.operator",
                regex : /--|\+\+|\.{3}|===|==|=|!=|!==|<+=?|>+=?|!|&&|\|\||\?:|[!$%&*+\-~\/^]=?/,
                next  : "start"
            }, {
                token : "punctuation.operator",
                regex : /[?:,;.]/,
                next  : "start"
            }, {
                token : "paren.lparen",
                regex : /[\[({]/,
                next  : "start"
            }, {
                token : "paren.rparen",
                regex : /[\])}]/
            }, {
                token: "comment",
                regex: /^#!.*$/
            }
        ],
        /*┌────────────────────────────────────────────────────────────────────────────────────────┐
        ┌─┤                                                                                        │
        │ │ Работа на втором уровне                                                                │
        │ └─→ Sound.param.***                                                                      │
        │                                                                                        ┌─┘
        └────────────────────────────────────────────────────────────────────────────────────────┘*/
        "property": [{
                token : "text",
                regex : "\\s+"
            },
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Присвоение стрелочной функции                                                      │
            │ └─→ Sound.param.play = (arg) => { }                                                  │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : "support.function",
                regex : "(" + identifierRe + ")(?=\\s*=\\s*\\(.*\\)\\s*=>)"
            },
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Присвоение анонимной функции                                                       │
            │ └─→ Sound.param.play = function(arg) { }                                             │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : "support.function",
                regex : "(" + identifierRe + ")(?=\\s*=\\s*function\\s*\\(.*\\))"
            },
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Присвоение именованной функции                                                     │
            │ └─→ Sound.param.play = function myFunc(arg) { }                                      │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : "support.function",
                regex : "(" + identifierRe + ")(?=\\s*=\\s*function\\s*" + identifierRe + "\\s*\\(.*\\))"
            },
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Присвоение анонимного класса                                                       │
            │ └─→ Sound.param.play = class { }                                                     │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : "support.function",
                regex : "(" + identifierRe + ")(?=\\s*=\\s*class\\s*\\{)"
            },
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Присвоение именованного класса                                                     │
            │ └─→ Sound.param.play = class myClass { }                                             │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : "support.function",
                regex : "(" + identifierRe + ")(?=\\s*=\\s*class\\s*" + identifierRe + "\\s*\\{)"
            },
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Внисение изменений в прототип                                                      │
            │ ├─→ Sound.param.prototype.play =                                                     │
            │ └─→ Sound.param.prototype =                                                          │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : [
                    "punctuation.operator", "storage.type"
                ],
                regex : "(\\.)(prototype\\b)"
            },
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Вызов метода                                                                       │
            │ └─→ Sound.play()                                                                     │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : "support.function",
                regex : "(" + identifierRe + ")(?=\\()"
            },
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Обращение к приватному свойству (подчеркивание перед именем)                       │
            │ └─→ Sound._play, Sound._somePrivateVariable                                          │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : "private",
                regex : "(" + privateIdentifierRe + ")\\b"
            },
            /*┌────────────────────────────────────────────────────────────────────────────────────┐
            ┌─┤                                                                                    │
            │ │ Обращение к свойству                                                               │
            │ └─→ Sound.play                                                                       │
            │                                                                                    ┌─┘
            └────────────────────────────────────────────────────────────────────────────────────┘*/
            {
                token : "param",
                regex : "(" + identifierRe + ")\\b(?=\\s*[-%<>&~=!:;,}\/\\|\\?\\*\\+\\^\\[\\]\\)])(?!\\s*$)"
            },
            //──────────────────────────────────────────────────────────────────────────────────────
            {
                token : "punctuation.operator",
                regex : /[.](?![.])/
            }, {
                token : "identifier",
                regex : identifierRe
            }, {
                regex: "",
                token: "empty",
                next: "no_regex"
            }
        ],
        // regular expressions are only allowed after certain tokens. This
        // makes sure we don't mix up regexps with the divison operator
        "start": [
            DocCommentHighlightRules.getStartRule("doc-start"),
            comments("start"),
            {
                token: "string.regexp",
                regex: "\\/",
                next: "regex"
            }, {
                token : "text",
                regex : "\\s+|^$",
                next : "start"
            }, {
                // immediately return to the start mode without matching
                // anything
                token: "empty",
                regex: "",
                next: "no_regex"
            }
        ],
        "regex": [
            {
                // escapes
                token: "regexp.keyword.operator",
                regex: "\\\\(?:u[\\da-fA-F]{4}|x[\\da-fA-F]{2}|.)"
            }, {
                // flag
                token: "string.regexp",
                regex: "/[sxngimy]*",
                next: "no_regex"
            }, {
                // invalid operators
                token : "invalid",
                regex: /\{\d+\b,?\d*\}[+*]|[+*$^?][+*]|[$^][?]|\?{3,}/
            }, {
                // operators
                token : "constant.language.escape",
                regex: /\(\?[:=!]|\)|\{\d+\b,?\d*\}|[+*]\?|[()$^+*?.]/
            }, {
                token : "constant.language.delimiter",
                regex: /\|/
            }, {
                token: "constant.language.escape",
                regex: /\[\^?/,
                next: "regex_character_class"
            }, {
                token: "empty",
                regex: "$",
                next: "no_regex"
            }, {
                defaultToken: "string.regexp"
            }
        ],
        "regex_character_class": [
            {
                token: "regexp.charclass.keyword.operator",
                regex: "\\\\(?:u[\\da-fA-F]{4}|x[\\da-fA-F]{2}|.)"
            }, {
                token: "constant.language.escape",
                regex: "]",
                next: "regex"
            }, {
                token: "constant.language.escape",
                regex: "-"
            }, {
                token: "empty",
                regex: "$",
                next: "no_regex"
            }, {
                defaultToken: "string.regexp.charachterclass"
            }
        ],
        "function_arguments": [
            {
                token: "variable.parameter",
                regex: identifierRe
            }, {
                token: "punctuation.operator",
                regex: "[, ]+"
            }, {
                token: "punctuation.operator",
                regex: "$"
            }, {
                token: "empty",
                regex: "",
                next: "no_regex"
            }
        ],
        "qqstring" : [
            {
                token : "constant.language.escape",
                regex : escapedRe
            }, {
                token : "string",
                regex : "\\\\$",
                consumeLineEnd  : true
            }, {
                token : "string",
                regex : '"|$',
                next  : "no_regex"
            }, {
                defaultToken: "string"
            }
        ],
        "qstring" : [
            {
                token : "constant.language.escape",
                regex : escapedRe
            }, {
                token : "string",
                regex : "\\\\$",
                consumeLineEnd  : true
            }, {
                token : "string",
                regex : "'|$",
                next  : "no_regex"
            }, {
                defaultToken: "string"
            }
        ]
    };


    if (!options || !options.noES6) {
        this.$rules.no_regex.unshift({
            regex: "[{}]", onMatch: function(val, state, stack) {
                this.next = val == "{" ? this.nextState : "";
                if (val == "{" && stack.length) {
                    stack.unshift("start", state);
                }
                else if (val == "}" && stack.length) {
                    stack.shift();
                    this.next = stack.shift();
                    if (this.next.indexOf("string") != -1 || this.next.indexOf("jsx") != -1)
                        return "paren.quasi.end";
                }
                return val == "{" ? "paren.lparen" : "paren.rparen";
            },
            nextState: "start"
        }, {
            token : "string.quasi.start",
            regex : /`/,
            push  : [{
                token : "constant.language.escape",
                regex : escapedRe
            }, {
                token : "paren.quasi.start",
                regex : /\${/,
                push  : "start"
            }, {
                token : "string.quasi.end",
                regex : /`/,
                next  : "pop"
            }, {
                defaultToken: "string.quasi"
            }]
        });

        if (!options || options.jsx != false)
            JSX.call(this);
    }

    this.embedRules(DocCommentHighlightRules, "doc-",
        [ DocCommentHighlightRules.getEndRule("no_regex") ]);

    this.normalizeRules();
};

oop.inherits(JavaScriptHighlightRules, TextHighlightRules);

function JSX() {
    var tagRegex = identifierRe.replace("\\d", "\\d\\-");
    var jsxTag = {
        onMatch : function(val, state, stack) {
            var offset = val.charAt(1) == "/" ? 2 : 1;
            if (offset == 1) {
                if (state != this.nextState)
                    stack.unshift(this.next, this.nextState, 0);
                else
                    stack.unshift(this.next);
                stack[2]++;
            } else if (offset == 2) {
                if (state == this.nextState) {
                    stack[1]--;
                    if (!stack[1] || stack[1] < 0) {
                        stack.shift();
                        stack.shift();
                    }
                }
            }
            return [{
                type: "meta.tag.punctuation." + (offset == 1 ? "" : "end-") + "tag-open.xml",
                value: val.slice(0, offset)
            }, {
                type: "meta.tag.tag-name.xml",
                value: val.substr(offset)
            }];
        },
        regex : "</?" + tagRegex + "",
        next: "jsxAttributes",
        nextState: "jsx"
    };
    this.$rules.start.unshift(jsxTag);
    var jsxJsRule = {
        regex: "{",
        token: "paren.quasi.start",
        push: "start"
    };
    this.$rules.jsx = [
        jsxJsRule,
        jsxTag,
        {include : "reference"},
        {defaultToken: "string"}
    ];
    this.$rules.jsxAttributes = [{
        token : "meta.tag.punctuation.tag-close.xml",
        regex : "/?>",
        onMatch : function(value, currentState, stack) {
            if (currentState == stack[0])
                stack.shift();
            if (value.length == 2) {
                if (stack[0] == this.nextState)
                    stack[1]--;
                if (!stack[1] || stack[1] < 0) {
                    stack.splice(0, 2);
                }
            }
            this.next = stack[0] || "start";
            return [{type: this.token, value: value}];
        },
        nextState: "jsx"
    },
    jsxJsRule,
    comments("jsxAttributes"),
    {
        token : "entity.other.attribute-name.xml",
        regex : tagRegex
    }, {
        token : "keyword.operator.attribute-equals.xml",
        regex : "="
    }, {
        token : "text.tag-whitespace.xml",
        regex : "\\s+"
    }, {
        token : "string.attribute-value.xml",
        regex : "'",
        stateName : "jsx_attr_q",
        push : [
            {token : "string.attribute-value.xml", regex: "'", next: "pop"},
            {include : "reference"},
            {defaultToken : "string.attribute-value.xml"}
        ]
    }, {
        token : "string.attribute-value.xml",
        regex : '"',
        stateName : "jsx_attr_qq",
        push : [
            {token : "string.attribute-value.xml", regex: '"', next: "pop"},
            {include : "reference"},
            {defaultToken : "string.attribute-value.xml"}
        ]
    },
    jsxTag
    ];
    this.$rules.reference = [{
        token : "constant.language.escape.reference.xml",
        regex : "(?:&#[0-9]+;)|(?:&#x[0-9a-fA-F]+;)|(?:&[a-zA-Z0-9_:\\.-]+;)"
    }];
}

function comments(next) {
    return [
        {
            token : "comment", // multi line comment
            regex : /\/\*/,
            next: [
                DocCommentHighlightRules.getTagRule(),
                {token : "comment", regex : "\\*\\/", next : next || "pop"},
                {defaultToken : "comment", caseInsensitive: true}
            ]
        }, {
            token : "comment",
            regex : "\\/\\/",
            next: [
                DocCommentHighlightRules.getTagRule(),
                {token : "comment", regex : "$|^", next : next || "pop"},
                {defaultToken : "comment", caseInsensitive: true}
            ]
        }
    ];
}
exports.JavaScriptHighlightRules = JavaScriptHighlightRules;
});