#┌────────────────┐
#│ Исходный образ │
#└────────────────┘
FROM alpine:3.11

#┌────────────────┐
#│ Базовые пакеты │
#└────────────────┘
RUN apk add sed bash openssh-client git --no-cache

#┌────────┐
#│ Docker │
#└────────┘
RUN apk add docker --no-cache

#┌──────┐
#│ Bash │
#└──────┘
RUN echo > /etc/shells /bin/bash \
&& sed -i "s/root:x:0:0:root:\/root:\/bin\/ash/root:x:0:0:root:\/root:\/bin\/bash/" /etc/passwd \

#┌───────────────────────────┐
#│ Удаление временных файлов │
#└───────────────────────────┘
&& rm -rf /var/cache/apk/* \
&& rm -rf /var/tmp/* \
&& rm -rf /tmp/*

#┌────────┐
#│ Версия │
#└────────┘
COPY temp/VERSION /root/VERSION

#┌──────────────┐
#│ Bash-скрипты │
#└──────────────┘
COPY temp/scripts /root/scripts

#┌─────────────┐
#│ Точка входа │
#└─────────────┘
ARG controllers
ARG entrypoints
ARG runners
ARG models
ARG views
ARG entrypoint
COPY "$controllers" /controllers/
COPY "$runners" /runners/
COPY "$models" /models/
COPY "$views" /views/
COPY "$entrypoints" /entrypoints/
COPY "$entrypoint" /entrypoint.sh
RUN chmod 700 /entrypoint.sh
ENTRYPOINT ["/bin/bash", "entrypoint.sh"]
