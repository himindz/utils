#!/bin/bash
if [ ! -f /.tomcat_admin_created ]; then
    /create_tomcat_admin_user.sh
fi
echo $(grep $(hostname) /etc/hosts | cut -f1) liquidedge.com >> /etc/hosts 
service nginx start
/usr/sbin/sshd -D
exec ${CATALINA_HOME}/bin/catalina.sh run
