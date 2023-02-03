#┌────────────────┐
#│ Исходный образ │
#└────────────────┘
FROM alpine:3.11

#┌────────────────┐
#│ Базовые пакеты │
#└────────────────┘
RUN apk add g++ make python curl sed bash bash-doc bash-completion openssh-client git py-pip python-dev --no-cache

#┌────────┐
#│ Docker │
#└────────┘
RUN apk add docker --no-cache

#┌──────┐
#│ Tmux │
#└──────┘
#&& apk add tmux=2.4-r0 -X http://dl-cdn.alpinelinux.org/alpine/v3.6/main/ --no-cache \
RUN apk add tmux -X http://dl-cdn.alpinelinux.org/alpine/v3.15/main/ --no-cache \

#┌──────┐
#│ Bash │
#└──────┘
&& echo > /etc/shells /bin/bash \
&& sed -i "s/root:x:0:0:root:\/root:\/bin\/ash/root:x:0:0:root:\/root:\/bin\/bash/" /etc/passwd \

#┌────────────┐
#│ Git-Prompt │
#└────────────┘
&& curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o /root/.git-prompt.sh

#┌─────────────────────────────────────────────────────────┐
#│ Так как запустить cloud9 можно только на версии v8.x.x, │
#│ нам необходимо иметь на борту сразу две версии          │
#└─────────────────────────────────────────────────────────┘
RUN apk add nodejs=16.17.1-r0 npm=8.1.3-r0  -X http://dl-cdn.alpinelinux.org/alpine/v3.15/main/ --no-cache --allow-untrusted \
&& apk add nodejs=8.14.0-r0  npm=8.14.0-r0 -X http://dl-cdn.alpinelinux.org/alpine/v3.8/main/  --no-cache --allow-untrusted \

#┌────────────────────────────┐
#│ 8.14.0 — версия для cloud9 │
#└────────────────────────────┘
&& mkdir /apks/node/v8 -p \
&& curl http://dl-cdn.alpinelinux.org/alpine/v3.8/main/x86_64/npm-8.14.0-r0.apk          -o /apks/node/v8/npm.apk \
&& curl http://dl-cdn.alpinelinux.org/alpine/v3.8/main/x86_64/nodejs-8.14.0-r0.apk       -o /apks/node/v8/nodejs.apk \

#┌────────────────────────────┐
#│ 16.17.1 — последняя вресия │
#└────────────────────────────┘
&& mkdir /apks/node/last -p \
&& curl http://dl-cdn.alpinelinux.org/alpine/v3.15/main/x86_64/npm-8.1.3-r0.apk          -o /apks/node/last/npm.apk \
&& curl http://dl-cdn.alpinelinux.org/alpine/v3.15/main/x86_64/nodejs-16.17.1-r0.apk     -o /apks/node/last/nodejs.apk \

#┌──────────────────────────────────────────────┐
#│ Зависимости для локального обновления версий │
#└──────────────────────────────────────────────┘
&& mkdir /apks/node/depends -p \
&& curl http://dl-cdn.alpinelinux.org/alpine/v3.8/main/x86_64/libuv-1.20.2-r0.apk        -o /apks/node/depends/libuv-1.20.2-r0.apk \
&& curl http://dl-cdn.alpinelinux.org/alpine/v3.8/main/x86_64/libssl1.0-1.0.2u-r0.apk    -o /apks/node/depends/libssl1.0-1.0.2u-r0.apk \
&& curl http://dl-cdn.alpinelinux.org/alpine/v3.8/main/x86_64/http-parser-2.8.1-r0.apk   -o /apks/node/depends/http-parser-2.8.1-r0.apk \
&& curl http://dl-cdn.alpinelinux.org/alpine/v3.15/main/x86_64/brotli-libs-1.0.9-r5.apk  -o /apks/node/depends/brotli-libs-1.0.9-r5.apk \
&& curl http://dl-cdn.alpinelinux.org/alpine/v3.8/main/x86_64/libcrypto1.0-1.0.2u-r0.apk -o /apks/node/depends/libcrypto1.0-1.0.2u-r0.apk

#┌────────┐
#│ Cloud9 │
#└────────┘
RUN git clone -b master --single-branch https://github.com/c9open/core.git /root/.c9
RUN cd /root/.c9 \
&& mkdir -p ./node/bin ./bin ./node_modules \
&& ln -sf "`which tmux`" ./bin/tmux \
&& ln -s "`which node`" ./node/bin/node \
&& ln -s "`which npm`" ./node/bin/npm \
&& npm i pty.js@0.3.1 \
&& npm i sqlite3@3.1.8 sequelize@2.0.0-beta.0 \
&& npm i https://github.com/cloud9ideopen/nak/tarball/c9 \
&& echo 1 > ./installed \
&& NO_PULL=1 ./scripts/install-sdk.sh \
&& npm cache clean --force \
&& git reset --hard \

#┌───────────┐
#│ Codeintel │
#└───────────┘
#&& pip install -U pip \
#&& pip install -U virtualenv \
#&& virtualenv --python=python2 /root/.c9/python2 \
#&& source /root/.c9/python2/bin/activate \
#&& mkdir /tmp/codeintel \
#&& pip download codeintel==2.0.0 -d /tmp/codeintel \
#&& cd /tmp/codeintel \
#&& tar xf CodeIntel-2.0.0.tar.gz \
#&& tar czf CodeIntel-2.0.0.tar.gz CodeIntel-2.0.0 \
#&& pip install -U --no-index --find-links=/tmp/codeintel codeintel \

#┌───────────────────────────┐
#│ Удаление временных файлов │
#└───────────────────────────┘
&& rm -rf /root/.c9/.git/objects/pack/* \
&& rm -rf /var/cache/apk/* \
&& rm -rf /var/tmp/* \
&& rm -rf /tmp/*

#┌──────────────────────────────┐
#│ Рабочий каталог по умолчанию │
#└──────────────────────────────┘
ENV WORKSPACE "/workspace"

#┌───────────────────┐
#│ Порт по умолчанию │
#└───────────────────┘
ENV C9_PORT 8000

#┌────────┐
#│ Версия │
#└────────┘
COPY temp/VERSION /root/VERSION

#┌──────────────┐
#│ Bash-профиль │
#└──────────────┘
COPY temp/bash_profile /root/.bash_profile

#┌─────────────────────┐
#│ Настройки редактора │
#└─────────────────────┘
COPY temp/user.settings /root/.c9/user.settings

#┌──────────────┐
#│ Bash-скрипты │
#└──────────────┘
COPY temp/scripts/cli /root/scripts/cli
COPY temp/scripts/amend /root/scripts/amend
COPY temp/scripts/deploy /root/scripts/deploy

#┌─────────────┐
#│ Точка входа │
#└─────────────┘
ARG entrypoint
COPY temp/scripts/$entrypoint /root/scripts/entrypoint
ENTRYPOINT ["/bin/bash", "/root/scripts/entrypoint/entrypoint.sh"]
