FROM ubuntu:14.04
MAINTAINER Ali Khan <alikhan@himindz.ie>

ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.0.24
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV DISPLAY :0
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
RUN adduser --quiet --uid 1001 --disabled-password -shell /bin/bash --home /home/jenkins --gecos "User" jenkins  && \
    echo "jenkins:$DEFAULT_PASSWORD" | chpasswd

RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:cwchien/gradle
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN add-apt-repository -y ppa:webupd8team/java
RUN add-apt-repository ppa:chris-lea/node.js

RUN apt-get remove -y  openssh-client openssh-server

RUN apt-get update && apt-get install -y \
                openssh-server \
                oracle-java8-installer \
                build-essential \
                sshpass \
                zlib1g-dev \
				zlib1g \
                zip \
                unzip \
                git \
                curl \
                bash \
                nginx \
                maven \
                ruby \
                ruby-dev \
                gradle \
				expect \
				lib32ncurses5 \
				lib32stdc++6 \
				firefox

RUN rm -rf /var/cache/oracle-jdk8-installer

RUN gem install --no-rdoc --no-ri cucumber -v 1.3.19
RUN gem install --no-rdoc --no-ri rspec
RUN gem install --no-rdoc --no-ri watir-webdriver
RUN gem install --no-rdoc --no-ri ruby-jmeter
RUN gem install --no-rdoc --no-ri jsonpath
RUN gem install --no-rdoc --no-ri colorize
RUN gem install --no-rdoc --no-ri page-object

RUN wget http://dl.google.com/android/android-sdk_r24.3.3-linux.tgz && tar -xzvf android-sdk_r24.3.3-linux.tgz && \
    mv android-sdk-linux /usr/local/.

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV ANDROID_HOME /usr/local/android-sdk-linux
WORKDIR /usr/local/android-sdk-linux
ENV PATH $PATH:/usr/local/android-sdk-linux/tools:/usr/local/android-sdk-linux/platform-tools

RUN echo "y" | android update sdk  -u -a -t  1
RUN echo "y" | android update sdk  -u -a -t 2,5,24,67,68
RUN echo "no" | android create avd --name myandroid22 -t "android-22" --abi "default/armeabi-v7a"


WORKDIR /root
RUN curl --silent --location https://deb.nodesource.com/setup_0.12 | sudo bash - && apt-get install -y nodejs
RUN npm install -g npm
RUN npm cache clean  && \
        npm install -g xml
RUN npm install -g grunt-cli
RUN npm install -g bower
RUN npm install -g generator-angular-fullstack
RUN npm install -g wd

RUN mkdir -p /usr/local/lib/node_modules
RUN chown -R root.jenkins /usr/local/lib/node_modules
RUN chmod -R g+rwx /usr/local/lib/node_modules

USER jenkins
WORKDIR /home/jenkins
RUN echo export PATH=\$PATH:/usr/local/lib/node_modules/bin >>.bashrc
RUN npm config set prefix '/usr/local/lib/node_modules'
ENV PATH $PATH:/usr/local/lib/node_modules/bin
RUN npm install -g appium
#RUN npm install -g appium

USER root
WORKDIR /root
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

#Install and Start SSH server
RUN mkdir /var/run/sshd && \
    /usr/sbin/sshd


# Install Grails
WORKDIR /usr/lib/jvm
RUN wget http://dist.springframework.org.s3.amazonaws.com/release/GRAILS/grails-2.4.4.zip && \
    unzip grails-2.4.4.zip && \
    rm -rf grails-2.4.4.zip && \
    ln -s grails-2.4.4 grails


ENV GRAILS_HOME /usr/lib/jvm/grails
ENV PATH $GRAILS_HOME/bin:$PATH

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

WORKDIR /root
RUN git clone https://github.com/ali-himindz/cucumber-junit.git
WORKDIR cucumber-junit
RUN npm install
WORKDIR ..
RUN mv cucumber-junit /usr/bin/.
EXPOSE 8080 8000 80 443
RUN echo $(grep $(hostname) /etc/hosts | cut -f1) localhost>> /etc/hosts

ADD setenv.sh /usr/local/tomcat/bin/setenv.sh

ADD nginx.conf /etc/nginx/nginx.conf
ADD localhost.crt /etc/nginx/ssl/localhost.crt
ADD localhost.key /etc/nginx/ssl/localhost.key
ADD create_tomcat_admin_user.sh /create_tomcat_admin_user.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh

CMD ["/run.sh"]
