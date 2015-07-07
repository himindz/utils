FROM ubuntu:14.04
MAINTAINER Ali Khan <alikhan@himindz.ie>
ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.0.24
RUN rm -rf /etc/Dockerfile
ADD Dockerfile /etc/Dockerfile

RUN rm -rf /etc/apt/sources.list
ADD sources.list /etc/apt/sources.list

RUN mkdir /var/log/localhost
RUN mkdir -p /var/www/apps/localhost/dist
RUN mkdir -p /var/www/apps/localhost/public

RUN apt-get install -y software-properties-common
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN add-apt-repository -y ppa:webupd8team/java

RUN apt-get update && apt-get install -y \
                        oracle-java8-installer \
                        openssh-server \
                        zip \
                        unzip \
                        git \
                        curl \
                        bash \
                        nginx \
                        build-essential \
                        nginx \
                        sshpass

RUN rm -rf /var/cache/oracle-jdk8-installer


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
