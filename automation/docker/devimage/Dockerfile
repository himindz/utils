FROM ubuntu:14.04
MAINTAINER Ali Khan <alikhan@himindz.ie>

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8


RUN rm -rf /etc/Dockerfile && \
	rm -rf /etc/apt/sources.list

COPY Dockerfile /etc/Dockerfile
COPY sources.list /etc/apt/sources.list

COPY sudoers /etc/sudoers
RUN chmod 640 /etc/sudoers

ENV DEFAULT_PASSWORD password


RUN mkdir /var/log/localhost && \
    mkdir -p /var/www/apps/localhost/dist && \
	mkdir -p /var/www/apps/localhost/public


#COPY User jenkins
RUN adduser --quiet --uid 1001 --disabled-password -shell /bin/bash --home /home/jenkins --gecos "User" jenkins  && \
    echo "jenkins:$DEFAULT_PASSWORD" | chpasswd   && \
	echo "export DISPLAY=:0" >>/etc/profile && \
	echo export JAVA_HOME=/usr/lib/jvm/java-8-oracle >> /etc/profile  && \
	echo export LANG=en_US.UTF-8 >>/etc/profile  && \
	echo export LANGUAGE=en_US:en >>/etc/profile  && \
	echo export LC_ALL=en_US.UTF-8 >>/etc/profile



RUN apt-get install -y software-properties-common && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    add-apt-repository -y ppa:webupd8team/java && \
    add-apt-repository ppa:cwchien/gradle
#RUN add-apt-repository ppa:chris-lea/node.js

RUN apt-get remove -y  openssh-client openssh-server


################# Install Java & SSH ######################
RUN apt-key update && apt-get update && apt-get install -y --force-yes \
                openssh-server \
                oracle-java8-installer  && \
				rm -rf /var/cache/oracle-jdk8-installer && \
    			mkdir -p /var/run/sshd && \
    			/usr/sbin/sshd

################ Install build tools and 32 bit libs for android ##########
RUN apt-get install -y --force-yes \
		bash \
		build-essential \
		chromium-browser \
		curl \
		expect \
		firefox \
		git \
		gradle \
		imagemagick \
		lib32stdc++6 \
		lib32z1 \
		libbz2-dev \
		libcurl4-openssl-dev \
		libexpat-dev \
		libgl1-mesa-dev \
		libncurses-dev \
		m4 \
		maven \
		nginx \
		ruby-dev \
		ruby \
		sshpass \
		unzip \
		wget \
		zip \
		zlib1g-dev \
		zlib1g 

############# Install gems ###################################
RUN gem install --no-rdoc --no-ri appium_lib \
	nokogiri \
	nokogiri-plist \
	net-ssh \
	net-scp \
	rspec \
	watir-webdriver \
	ruby-jmeter \
	jsonpath \
	colorize \
	compass \
	page-object

RUN gem install --no-rdoc --no-ri cucumber -v 1.3.19

################# Install nodejs and node packages ########
USER root
RUN mkdir /opt/node
RUN chown -R jenkins.jenkins /opt/node && \
    chmod -R 775  /opt/node && \
	echo export PATH="\$HOME/.linuxbrew/bin:\$PATH" >>/etc/profile && \
	echo export LD_LIBRARY_PATH="\$HOME/.linuxbrew/lib:\$LD_LIBRARY_PATH">>/etc/profile && \
	echo export PATH=\$PATH:/opt/node/bin >>/etc/profile && \
	echo export PATH="/usr/bin/cucumber-junit/bin:\$PATH" >>/etc/profile

USER jenkins
WORKDIR /home/jenkins
RUN echo -e "\n" | ruby -e "$(wget -O- https://raw.github.com/Homebrew/linuxbrew/go/install)"
ENV PATH="$PATH:/home/jenkins/.linuxbrew/bin" LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/jenkins/.linuxbrew/lib" SHELL="/bin/bash"

RUN echo export PATH="\$HOME/.linuxbrew/bin:\$PATH" >>/home/jenkins/.bashrc && \
	echo export LD_LIBRARY_PATH="\$HOME/.linuxbrew/lib:\$LD_LIBRARY_PATH">>/home/jenkins/.bashrc && \
	echo export PATH=\$PATH:/opt/node/bin >>/home/jenkins/.bashrc && \
	echo export PATH="/usr/bin/cucumber-junit/bin:\$PATH" >>/home/jenkins/.bashrc 

WORKDIR /opt/node
RUN brew update && \
    brew doctor && \
    brew install node
RUN npm config set prefix '/opt/node' && \ 
	npm install -g npm && \
	npm install -g xml && \
	npm install -g grunt-cli && \
	npm install -g appium && \
	npm install -g bower && \
	npm install -g jade && \
	npm install -g generator-angular-fullstack && \
	npm install -g wd && \
	npm install -g protractor && \
	npm install -g chromedriver && \
	npm install -g phantomjs && \
	npm install -g grunt-contrib-compass 

#################### Install cucumber-junit ###############
USER jenkins
WORKDIR /home/jenkins
RUN git clone https://github.com/ali-himindz/cucumber-junit.git && \
    cd cucumber-junit && \
    npm install
USER root
RUN mv /home/jenkins/cucumber-junit /usr/bin/.

########################## Install Selenium #####################
USER root
COPY selenium /etc/init.d/selenium
RUN mkdir /usr/local/share/selenium && \
    chown -R jenkins.jenkins /usr/local/share/selenium && \
    mkdir /var/log/selenium && \
    chown jenkins.jenkins /var/log/selenium && \
	chmod a+x /etc/init.d/selenium && \
    touch /phantomjsdriver.log && \
    chmod 666 /phantomjsdriver.log

USER jenkins
RUN wget http://selenium-release.storage.googleapis.com/2.46/selenium-server-standalone-2.46.0.jar && \
	mv selenium-server-standalone-2.46.0.jar /usr/local/share/selenium




########################## Install tomcat #######################
USER root
WORKDIR /root
ENV TOMCAT_MAJOR=8 TOMCAT_VERSION=8.0.24 CATALINA_HOME=/usr/local/tomcat  
ENV	PATH=$CATALINA_HOME/bin:$PATH TOMCAT_PASS=$DEFAULT_PASSWORD TOMCAT_TGZ_URL=https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

EXPOSE 8080 8000

WORKDIR $CATALINA_HOME

RUN set -x && \
	mkdir -p "$CATALINA_HOME" && \
	curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz && \
	curl -fSL "$TOMCAT_TGZ_URL.asc" -o tomcat.tar.gz.asc &&\
	tar -xvf tomcat.tar.gz --strip-components=1 &&\
	rm bin/*.bat &&\
	rm tomcat.tar.gz*


########################## install Grails ########################
# Install Grails
WORKDIR /usr/lib/jvm
ENV GRAILS_HOME=/usr/lib/jvm/grails PATH=$GRAILS_HOME/bin:$PATH
RUN wget http://dist.springframework.org.s3.amazonaws.com/release/GRAILS/grails-2.4.4.zip && \
    unzip grails-2.4.4.zip && \
    rm -rf grails-2.4.4.zip && \
    ln -s grails-2.4.4 grails



########################## install android sdk ########################
USER root
WORKDIR /usr/local/
RUN wget http://dl.google.com/android/android-sdk_r24.3.3-linux.tgz
RUN tar -xzvf android-sdk_r24.3.3-linux.tgz && \
    rm -Rf android-sdk_r24.3.3-linux.tgz && \
    chown -R root.jenkins android-sdk-linux && \
	echo export ANDROID_HOME=/usr/local/android-sdk-linux >>/etc/profile && \
	echo export PATH=\$PATH:/usr/local/android-sdk-linux/tools:/usr/local/android-sdk-linux/platform-tools >>/etc/profile


ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle ANDROID_HOME=/usr/local/android-sdk-linux \
	PATH=$PATH:/usr/local/android-sdk-linux/tools:/usr/local/android-sdk-linux/platform-tools

WORKDIR /usr/local/android-sdk-linux

RUN echo "y" | android update sdk  -u -a -t  1 && \
	echo "y" | android update sdk  -u -a -t 2,5,24,67,68

RUN chmod a+x /usr/local/android-sdk-linux/tools/* && \
	chmod a+x /usr/local/android-sdk-linux/platform-tools/*

USER jenkins
WORKDIR /home/jenkins
RUN echo "no" | android create avd --name myandroid22 -t "android-22" --abi "default/armeabi-v7a"

################# Run app ######################
USER root
WORKDIR /root
EXPOSE 80 443 4723
RUN echo $(grep $(hostname) /etc/hosts | cut -f1) localhost>> /etc/hosts
ADD setenv.sh /usr/local/tomcat/bin/setenv.sh
ADD nginx.conf /etc/nginx/nginx.conf
ADD localhost.crt /etc/nginx/ssl/localhost.crt
ADD localhost.key /etc/nginx/ssl/localhost.key
ADD create_tomcat_admin_user.sh /create_tomcat_admin_user.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh

CMD ["/run.sh"]
