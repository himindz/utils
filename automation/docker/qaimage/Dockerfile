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
RUN chown 600 /etc/sudoers

RUN mkdir /var/log/localhost
RUN mkdir -p /var/www/apps/localhost/dist
RUN mkdir -p /var/www/apps/localhost/public


RUN apt-get install -y software-properties-common
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN add-apt-repository -y ppa:webupd8team/java
RUN add-apt-repository ppa:chris-lea/node.js

RUN apt-get remove -y  openssh-client openssh-server



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
			libssl-dev \
                        nginx \
                        sshpass \
                        zlib1g-dev \
                        ruby \
                        ruby-dev \
			lib32ncurses5 \
			lib32stdc++6 \
			firefox

RUN rm -rf /var/cache/oracle-jdk8-installer

RUN curl --silent --location https://deb.nodesource.com/setup_0.12 | sudo bash - && apt-get install -y nodejs

RUN wget http://dl.google.com/android/android-sdk_r24.3.3-linux.tgz && tar -xzvf android-sdk_r24.3.3-linux.tgz && \
    mv android-sdk-linux /usr/local/.

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV ANDROID_HOME /usr/local/android-sdk-linux
WORKDIR /usr/local/android-sdk-linux
ENV PATH $PATH:/usr/local/android-sdk-linux/tools:/usr/local/android-sdk-linux/platform-tools

RUN echo "y" | android update sdk  -u -a -t  1
RUN echo "y" | android update sdk  -u -a -t 2,5,24,67,68
#RUN echo "y" | android update sdk -a --no-ui --filter sys-img-armeabi-v7a-android-22,sys-img-x86_64-android-22
RUN echo "no" | android create avd --name myandroid22 -t "android-22" --abi "default/armeabi-v7a"



RUN npm install -g npm
RUN npm cache clean  && \
        npm install -g xml
RUN npm install -g grunt-cli
RUN npm install -g bower
RUN npm install -g generator-angular-fullstack




RUN gem install --no-rdoc --no-ri  cucumber -v 1.3.19
RUN gem install --no-rdoc --no-ri rspec
RUN gem install --no-rdoc --no-ri ruby-jmeter
RUN gem install --no-rdoc --no-ri  jsonpath
RUN gem install --no-rdoc --no-ri colorize



#Add User jenkins
RUN adduser --quiet --disabled-password -shell /bin/bash --home /home/jenkins --gecos "User" jenkins && \
    echo "jenkins:password" | chpasswd

USER jenkins
RUN npm config set prefix '/home/jenkins/.npm-packages'
ENV PATH $PATH:/home/jenkins/.npm-packages/bin
RUN npm install -g appium

USER root

#Install and Start SSH server
RUN mkdir /var/run/sshd && \
    /usr/sbin/sshd


#Add User developer
RUN adduser --quiet --disabled-password -shell /bin/bash --home /home/developer --gecos "User" developer && \
    echo "developer:password" | chpasswd


# Define commonly used JAVA_HOME variable
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

RUN git clone https://github.com/ali-himindz/cucumber-junit.git
WORKDIR cucumber-junit
RUN npm install
WORKDIR ..
RUN mv cucumber-junit /usr/bin/.


EXPOSE 8080 8000 80 443
RUN echo $(grep $(hostname) /etc/hosts | cut -f1) localhost>> /etc/hosts


ADD nginx.conf /etc/nginx/nginx.conf
ADD localhost.crt /etc/nginx/ssl/localhost.crt
ADD localhost.key /etc/nginx/ssl/localhost.key
ADD create_tomcat_admin_user.sh /create_tomcat_admin_user.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh

CMD ["/run.sh"]
