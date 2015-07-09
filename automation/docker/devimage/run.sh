#!/bin/bash

echo $DEV_UID
#Add developer user

UID_PARAM=""
if [ "$DEV_UID" != "0" ]; then
   UID_PARAM=" --uid $DEV_UID"
fi


adduser --quiet $UID_PARAM --disabled-password -shell /bin/bash --home $HOME_FOLDER --gecos "User" $USERNAME && \
    echo "$USERNAME:password" | chpasswd
echo "$USERNAME  ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers

export ORIGPASSWD=$(cat /etc/passwd | grep $USERNAME)

export DEV_UID=${DEV_UID:=$ORIG_UID}


echo export PATH=\$PATH:/usr/local/lib/node_modules/bin:/usr/local/android-sdk-linux/tools:/usr/local/android-sdk-linux/platform-tools >>$HOME_FOLDER/.bashrc
echo export JAVA_HOME=/usr/lib/jvm/java-8-oracle >> $HOME_FOLDER/.bashrc
echo export ANDROID_HOME=/usr/local/android-sdk-linux >>$HOME_FOLDER/.bashrc

ORIG_HOME=$(echo $ORIGPASSWD | cut -f6 -d:)

chown -R ${DEV_UID} ${ORIG_HOME}
usermod -g jenkins $USERNAME

chown -R jenkins /tmp/.X11-unix
chown -R jenkins /home/jenkins/.Xauthority
if [ ! -f /.tomcat_admin_created ]; then
    /create_tomcat_admin_user.sh
fi
echo $(grep $(hostname) /etc/hosts | cut -f1) localhost >> /etc/hosts 
service nginx start
/usr/sbin/sshd -D &
exec ${CATALINA_HOME}/bin/catalina.sh jpda run
