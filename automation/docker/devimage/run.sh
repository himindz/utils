#!/bin/bash

echo $DEV_UID
#Add developer user
adduser --quiet --uid $DEV_UID --disabled-password -shell /bin/bash --home $HOME_FOLDER --gecos "User" $USERNAME && \
    echo "$USERNAME:password" | chpasswd
echo "$USERNAME  ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers

export ORIGPASSWD=$(cat /etc/passwd | grep $USERNAME)

#export ORIG_UID=$(echo $ORIGPASSWD | cut -f3 -d:)
#export ORIG_GID=$(echo $ORIGPASSWD | cut -f4 -d:)
#export DEV_GID=${$ORIG_GID:=$ORIG_GID}
export DEV_UID=${DEV_UID:=$ORIG_UID}

ORIG_HOME=$(echo $ORIGPASSWD | cut -f6 -d:)

#sed -i -e "s/:$ORIG_UID:$ORIG_GID:/:$DEV_UID:$ORIG_GID:/" /etc/passwd
chown -R ${DEV_UID} ${ORIG_HOME}
chown -R ${DEV_UID} /tmp/.X11-unix
if [ ! -f /.tomcat_admin_created ]; then
    /create_tomcat_admin_user.sh
fi
echo $(grep $(hostname) /etc/hosts | cut -f1) localhost >> /etc/hosts 
service nginx start
/usr/sbin/sshd -D &
exec ${CATALINA_HOME}/bin/catalina.sh jpda run
