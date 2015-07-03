FROM ubuntu:14.04
MAINTAINER Ali Khan <alikhan@himindz.ie>

RUN rm -rf /etc/Dockerfile
ADD Dockerfile /etc/Dockerfile

RUN rm -rf /etc/apt/sources.list
ADD sources.list /etc/apt/sources.list

RUN mkdir /var/log/localhost
RUN mkdir -p /var/www/apps/localhost/dist
RUN mkdir -p /var/www/apps/localhost/public
RUN apt-get install -y software-properties-common
RUN apt-get remove -y openssh-client openssh-server
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    add-apt-repository -y ppa:webupd8team/java &&


RUN apt-get update
RUN apt-get install -y oracle-java8-installer
RUN rm -rf /var/cache/oracle-jdk8-installer

RUN apt-get install -y zip unzip git curl bash
RUN apt-get install -y build-essential
RUN apt-get install -y nginx
RUN apt-get install -y sshpass




#Add User jenkins
RUN adduser --quiet --disabled-password -shell /bin/bash --home /home/jenkins --gecos "User" jenkins && \
    echo "jenkins:password" | chpasswd

#Start SSH server
RUN mkdir /var/run/sshd && \
    /usr/sbin/sshd

 Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle


ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

ENV TOMCAT_PASS="password"
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

# see https://www.apache.org/dist/tomcat/tomcat-9/KEYS
#RUN gpg --keyserver pool.sks-keyservers.net --recv-keys \
#	05AB33110949707C93A279E3D3EFE6B686867BA6 \
#	07E48665A34DCAFAE522E5E6266191C37C037D42 \
#	47309207D818FFD8DCD3F83F1931D684307A10A5 \
#	541FBE7D8F78B25E055DDEE13C370389288584E7 \
#	61B832AC2F1C5A90F0F9B00A1C506407564C17A3 \
#	79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED \
#	9BA44C2621385CB966EBA586F72C284D731FABEE \
#	A27677289986DB50844682F8ACB77FC2E86E29AC \
#	A9C5DF4D22E99998D9875A5110C01C5A2F6059E7 \
#	DCFD35E0BF8CA7344752DE8B6FB21E8933C60243 \
#	F3A04C595DB5B6A5F1ECA43E3B7BBB100D811BBE \
#	F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23

ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.0.22
ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN set -x \
	&& curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
	&& curl -fSL "$TOMCAT_TGZ_URL.asc" -o tomcat.tar.gz.asc \
	&& tar -xvf tomcat.tar.gz --strip-components=1 \
	&& rm bin/*.bat \
	&& rm tomcat.tar.gz*

EXPOSE 8080 80 443
RUN echo $(grep $(hostname) /etc/hosts | cut -f1) localhost >> /etc/hosts

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ADD nginx.conf /etc/nginx/nginx.conf
ADD localhost.crt /etc/nginx/ssl/localhost.crt
ADD localhost.key /etc/nginx/ssl/localhost.key
ADD create_tomcat_admin_user.sh /create_tomcat_admin_user.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh

CMD ["/run.sh"]
