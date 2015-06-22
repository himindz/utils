FROM ubuntu:14.04
MAINTAINER Ali Khan <alikhan@himindz.ie>

RUN rm -rf /etc/Dockerfile
ADD Dockerfile /etc/Dockerfile
RUN rm -rf /etc/apt/sources.list
ADD sources.list /etc/apt/sources.list

ADD sudoers /etc/sudoers

RUN mkdir /var/log/localhost
RUN mkdir -p /var/www/apps/localhost/dist
RUN mkdir -p /var/www/apps/localhost/public
RUN apt-get update
RUN apt-get install -y software-properties-common python-software-properties
RUN apt-get install -y zip unzip git curl bash zlib1g-dev
RUN apt-get install -y build-essential
RUN apt-get install -y nginx
RUN apt-get install -y maven
RUN apt-get install -y ruby
RUN apt-get install -y ruby-dev
RUN apt-get install -y sshpass
RUN gem install --no-rdoc --no-ri cucumber -v 1.3.19
RUN gem install --no-rdoc --no-ri  rspec
RUN gem install --no-rdoc --no-ri ruby-jmeter
RUN gem install --no-rdoc --no-ri jsonpath
RUN gem install --no-rdoc --no-ri colorize

#Install Gradle
RUN add-apt-repository ppa:cwchien/gradle && \
    apt-get update && \
    apt-get install -y gradle

RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer


# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle


ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH


RUN apt-get remove -y  openssh-client openssh-server
RUN apt-get update

#Install and Start SSH server
RUN apt-get install -y openssh-server && \
    mkdir /var/run/sshd && \
    /usr/sbin/sshd


#Add User developer
RUN adduser --quiet --disabled-password -shell /bin/bash --home /home/developer --gecos "User" developer && \
    echo "developer:password" | chpasswd


#Add User jenkins
RUN adduser --quiet --disabled-password -shell /bin/bash --home /home/jenkins --gecos "User" jenkins && \
    echo "jenkins:password" | chpasswd
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

# see https://www.apache.org/dist/tomcat/tomcat-8/KEYS
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys \
	05AB33110949707C93A279E3D3EFE6B686867BA6 \
	07E48665A34DCAFAE522E5E6266191C37C037D42 \
	47309207D818FFD8DCD3F83F1931D684307A10A5 \
	541FBE7D8F78B25E055DDEE13C370389288584E7 \
	61B832AC2F1C5A90F0F9B00A1C506407564C17A3 \
	79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED \
	9BA44C2621385CB966EBA586F72C284D731FABEE \
	A27677289986DB50844682F8ACB77FC2E86E29AC \
	A9C5DF4D22E99998D9875A5110C01C5A2F6059E7 \
	DCFD35E0BF8CA7344752DE8B6FB21E8933C60243 \
	F3A04C595DB5B6A5F1ECA43E3B7BBB100D811BBE \
	F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23

ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.0.22
ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN set -x \
	&& curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
	&& curl -fSL "$TOMCAT_TGZ_URL.asc" -o tomcat.tar.gz.asc \
	&& tar -xvf tomcat.tar.gz --strip-components=1 \
	&& rm bin/*.bat \
	&& rm tomcat.tar.gz*

RUN add-apt-repository ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get install -y nodejs
RUN update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10
RUN npm install -g xml
RUN npm install -g grunt-cli


RUN git clone https://github.com/ali-himindz/cucumber-junit.git
WORKDIR cucumber-junit
RUN npm install 
WORKDIR ..
RUN mv cucumber-junit /usr/bin/.
EXPOSE 8080 8000 80 443
RUN echo $(grep $(hostname) /etc/hosts | cut -f1) localhost>> /etc/hosts 

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
