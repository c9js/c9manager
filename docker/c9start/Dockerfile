#┌────────────────┐
#│ Исходный образ │
#└────────────────┘
FROM alpine:3.11

#┌────────────────┐
#│ Базовые пакеты │
#└────────────────┘
RUN apk add sed bash git docker --no-cache \

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
COPY lib /root/lib

#┌─────────────┐
#│ Точка входа │
#└─────────────┘
ARG entrypoint
COPY "$entrypoint" /usr/local/bin/Entrypoint
RUN chmod 700 /usr/local/bin/Entrypoint
ENTRYPOINT ["/bin/bash", "Entrypoint"]
