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
COPY temp/scripts/cli /root/scripts/cli

#┌─────────────┐
#│ Точка входа │
#└─────────────┘
ARG entrypoint
COPY temp/scripts/$entrypoint /root/scripts/entrypoint
ENTRYPOINT ["/bin/bash", "/root/scripts/entrypoint/entrypoint.sh"]
