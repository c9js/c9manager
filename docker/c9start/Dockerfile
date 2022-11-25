#┌────────────────┐
#│ Исходный образ │
#└────────────────┘
FROM alpine:3.11

#┌────────────────┐
#│ Базовые пакеты │
#└────────────────┘
RUN apk add sed bash openssh-client git docker --no-cache \

#┌──────┐
#│ Bash │
#└──────┘
&& echo > /etc/shells /bin/bash \
&& sed -i "s/root:x:0:0:root:\/root:\/bin\/ash/root:x:0:0:root:\/root:\/bin\/bash/" /etc/passwd \

#┌───────────────────────────┐
#│ Удаление временных файлов │
#└───────────────────────────┘
&& rm -rf /var/cache/apk/* \
&& rm -rf /var/tmp/* \
&& rm -rf /tmp/*

#┌─────────────────┐
#│ bash-библиотека │
#└─────────────────┘
COPY temp/cli /root/cli

#┌─────────────┐
#│ Точка входа │
#└─────────────┘
ARG controllers
ARG entrypoints
ARG models
ARG views
ARG entrypoint
COPY "$controllers" /controllers/
COPY "$models" /models/
COPY "$views" /views/
COPY "$entrypoints" /entrypoints/
COPY "$entrypoint" /entrypoint
RUN chmod 700 /entrypoint
ENTRYPOINT ["/bin/bash", "entrypoint"]
