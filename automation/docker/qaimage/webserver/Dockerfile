FROM ubuntu:14.04
MAINTAINER Ali Khan <alikhan@himindz.ie>

ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.0.24
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN rm -rf /etc/Dockerfile
ADD Dockerfile /etc/Dockerfile
RUN rm -rf /etc/apt/sources.list
ADD sources.list /etc/apt/sources.list

ADD sudoers /etc/sudoers
RUN chmod 640 /etc/sudoers

ENV DEFAULT_PASSWORD password


RUN mkdir /var/log/localhost
RUN mkdir -p /var/www/apps/localhost/dist
RUN mkdir -p /var/www/apps/localhost/public

#Add User jenkins
RUN adduser --quiet --disabled-password -shell /bin/bash --home /home/jenkins --gecos "User" jenkins && \
    echo "jenkins:$DEFAULT_PASSWORD" | chpasswd
RUN echo "export DISPLAY=:0" >>/etc/bash.bashrc


RUN apt-get install -y software-properties-common
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN add-apt-repository -y ppa:webupd8team/java

RUN apt-get remove -y  openssh-client openssh-server
################# Install Java & SSH ######################
RUN apt-key update && apt-get update && apt-get install -y --force-yes \
                openssh-server \
                oracle-java8-installer

RUN rm -rf /var/cache/oracle-jdk8-installer

#Start SSH server
RUN mkdir /var/run/sshd && \
    /usr/sbin/sshd

################ Install build tools and 32 bit libs for android ##########
RUN apt-get install -y --force-yes \
	        	bash \
				wget \
				curl \
                unzip \
                zip \
                nginx 

########################## Install tomcat #######################
USER root
WORKDIR /root
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
ENV TOMCAT_PASS=$DEFAULT_PASSWORD
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN set -x \
	&& curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
	&& curl -fSL "$TOMCAT_TGZ_URL.asc" -o tomcat.tar.gz.asc \
	&& tar -xvf tomcat.tar.gz --strip-components=1 \
	&& rm bin/*.bat \
	&& rm tomcat.tar.gz*


################# Run app ######################
EXPOSE 8080 8000 80 443
RUN echo $(grep $(hostname) /etc/hosts | cut -f1) localhost>> /etc/hosts


ADD nginx.conf /etc/nginx/nginx.conf
ADD localhost.crt /etc/nginx/ssl/localhost.crt
ADD localhost.key /etc/nginx/ssl/localhost.key
ADD create_tomcat_admin_user.sh /create_tomcat_admin_user.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh

CMD ["/run.sh"]
