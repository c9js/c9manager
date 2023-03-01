#!/bin/bash
#┌─────┐
#│ SSH │
#└─────┘
mkdir /root/.ssh
echo 'IdentityFile /root/.ssh/id_rsa' >> /etc/ssh/ssh_config

echo -e "Host github.com\n\tStrictHostKeyChecking no\n\tUserKnownHostsFile=/dev/null\n\tLogLevel error" >> /root/.ssh/config
chmod 600 /root/.ssh/config

cp /root/.sshsource/$GIT_USER /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa

cp /root/.sshsource/$GIT_USER.pub /root/.ssh/id_rsa.pub
chmod 644 /root/.ssh/id_rsa.pub

#┌─────┐
#│ Git │
#└─────┘
git config --global user.email 'email@email.email'
git config --global user.name 'Sergei'
git config --global rebase.missingCommitsCheck 'error'

#┌─────────────────────────────────────────────────────┐
#│ Если репозитория нет, то пробуем привязать к Github │
#└─────────────────────────────────────────────────────┘
if [ ! -e "$PATH_WORKSPACE/.git" ]; then
    git clone git@github.com:$GIT_USER/$WORKSPACE.git $PATH_WORKSPACE
fi

#┌───────────────┐
#│ Запуск cloud9 │
#└───────────────┘
/root/.c9/start -l 0.0.0.0 -p $C9_PORT -w $PATH_WORKSPACE -a $USERNAME:$PASSWORD
