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


RUN mkdir /var/log/localhost && \
    mkdir -p /var/www/apps/localhost/dist && \
	mkdir -p /var/www/apps/localhost/public

#Add User jenkins
RUN adduser --quiet --uid 1000 --disabled-password -shell /bin/bash --home /home/jenkins --gecos "User" jenkins  && \
    echo "jenkins:$DEFAULT_PASSWORD" | chpasswd
RUN echo "export DISPLAY=:0" >>/etc/bash.bashrc
RUN echo export PATH=\$PATH:/usr/local/lib/node_modules/bin:/usr/local/android-sdk-linux/tools:/usr/local/android-sdk-linux/platform-tools >>/etc/bash.bashrc
RUN echo export JAVA_HOME=/usr/lib/jvm/java-8-oracle >> /etc/bash.bashrc
RUN echo export ANDROID_HOME=/usr/local/android-sdk-linux >>/etc/bash.bashrc
RUN echo export LANG=en_US.UTF-8 >>/etc/bash.bashrc
RUN echo export LANGUAGE=en_US:en >>/etc/bash.bashrc
RUN echo export LC_ALL=en_US.UTF-8 >>/etc/bash.bashrc


RUN apt-get install -y software-properties-common
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN add-apt-repository -y ppa:webupd8team/java
RUN add-apt-repository ppa:cwchien/gradle
#RUN add-apt-repository ppa:chris-lea/node.js

RUN apt-get remove -y  openssh-client openssh-server


################# Install Java & SSH ######################
RUN apt-key update && apt-get update && apt-get install -y --force-yes \
                openssh-server \
                oracle-java8-installer 

RUN rm -rf /var/cache/oracle-jdk8-installer && \
    mkdir /var/run/sshd && \
    /usr/sbin/sshd

################ Install build tools and 32 bit libs for android ##########        
RUN apt-get install -y --force-yes \
                build-essential \
                lib32ncurses5 \
                libgl1-mesa-dev \
                lib32z1 \
	        	bash \
				wget \
				curl \
                expect \ 
                sshpass \
                unzip \
                zip \
                zlib1g \
                zlib1g-dev \ 
                ruby \
                git \
                maven \
                gradle \ 
                ruby-dev \ 
                nginx \
	        	firefox \
                lib32stdc++6 

				
############# Install gems ###################################
RUN gem install --no-rdoc --no-ri appium_lib \
								  nokogiri \
								  nokogiri-plist \
								  net-ssh \
								  net-scp \
								  rspec \
								  watir-webdriver \
								  ruby-jmeter \
								  rspec \
								  watir-webdriver \
								  ruby-jmeter \
								  jsonpath \
								  colorize \
								  page-object
								   
RUN gem install --no-rdoc --no-ri cucumber -v 1.3.19 
                               
################# Install nodejs and node packages ########
USER root
RUN mkdir /opt/node
RUN chown -R jenkins.jenkins /opt/node && \
    chmod -R 775  /opt/node
RUN echo export PATH="\$HOME/.linuxbrew/bin:\$PATH" >>/etc/bash.bashrc
RUN echo export LD_LIBRARY_PATH="\$HOME/.linuxbrew/lib:\$LD_LIBRARY_PATH">>/etc/bash.bashrc
RUN echo export PATH=\$PATH:/opt/node/bin >>/etc/bash.bashrc
RUN echo export PATH="/usr/bin/cucumber-junit/bin:\$PATH" >>/etc/bash.bashrc

USER jenkins
WORKDIR /home/jenkins
RUN echo -e "\n" | ruby -e "$(wget -O- https://raw.github.com/Homebrew/linuxbrew/go/install)"
ENV PATH "/home/jenkins/.linuxbrew/bin:$PATH"
ENV LD_LIBRARY_PATH "/home/jenkins/.linuxbrew/lib:$LD_LIBRARY_PATH"
ENV PATH $PATH:/opt/node/bin
WORKDIR /opt/node
RUN brew doctor && \
    brew install node
RUN npm config set prefix '/opt/node'
RUN npm install -g npm
RUN npm install -g xml
RUN npm install -g grunt-cli
RUN npm install -g appium
RUN npm install -g bower
RUN npm install -g generator-angular-fullstack
RUN npm install -g wd

#################### Install cucumber-junit ###############
WORKDIR /home/jenkins
RUN git clone https://github.com/ali-himindz/cucumber-junit.git
WORKDIR cucumber-junit
RUN npm install
USER root
WORKDIR /home/jenkins
RUN mv cucumber-junit /usr/bin/.

########################## Install tomcat #######################
USER root
WORKDIR /root
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
ENV TOMCAT_PASS="password"
WORKDIR $CATALINA_HOME
RUN mkdir -p "$CATALINA_HOME"
ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN set -x \
	&& curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
	&& curl -fSL "$TOMCAT_TGZ_URL.asc" -o tomcat.tar.gz.asc \
	&& tar -xvf tomcat.tar.gz --strip-components=1 \
	&& rm bin/*.bat \
	&& rm tomcat.tar.gz*


########################## install Grails ########################
# Install Grails
WORKDIR /usr/lib/jvm
RUN wget http://dist.springframework.org.s3.amazonaws.com/release/GRAILS/grails-2.4.4.zip && \
    unzip grails-2.4.4.zip && \
    rm -rf grails-2.4.4.zip && \
    ln -s grails-2.4.4 grails
ENV GRAILS_HOME /usr/lib/jvm/grails
ENV PATH $GRAILS_HOME/bin:$PATH


########################## install android sdk ########################
USER root
WORKDIR /usr/local/
RUN wget http://dl.google.com/android/android-sdk_r24.3.3-linux.tgz 
RUN tar -xzvf android-sdk_r24.3.3-linux.tgz && \
    rm -Rf android-sdk_r24.3.3-linux.tgz && \
    chown -R root.jenkins android-sdk-linux
RUN echo export JAVA_HOME=/usr/lib/jvm/java-8-oracle >> /etc/bash.bashrc
RUN echo export ANDROID_HOME=/usr/local/android-sdk-linux >>/etc/bash.bashrc
RUN echo export PATH=\$PATH:/usr/local/android-sdk-linux/tools:/usr/local/android-sdk-linux/platform-tools >>/etc/bash.bashrc
    

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV ANDROID_HOME /usr/local/android-sdk-linux
WORKDIR /usr/local/android-sdk-linux
ENV PATH $PATH:/usr/local/android-sdk-linux/tools:/usr/local/android-sdk-linux/platform-tools

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
EXPOSE 8080 8000 80 443 4723
RUN echo $(grep $(hostname) /etc/hosts | cut -f1) localhost>> /etc/hosts
ADD setenv.sh /usr/local/tomcat/bin/setenv.sh
ADD nginx.conf /etc/nginx/nginx.conf
ADD localhost.crt /etc/nginx/ssl/localhost.crt
ADD localhost.key /etc/nginx/ssl/localhost.key
ADD create_tomcat_admin_user.sh /create_tomcat_admin_user.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh

CMD ["/run.sh"]
