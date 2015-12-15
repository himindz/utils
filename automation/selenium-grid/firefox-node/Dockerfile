FROM ubuntu:14.04
MAINTAINER Ali Khan <alikhan@himindz.ie>

RUN  echo "deb http://archive.ubuntu.com/ubuntu trusty main universe\n" > /etc/apt/sources.list \
  && echo "deb http://archive.ubuntu.com/ubuntu trusty-updates main universe\n" >> /etc/apt/sources.list

RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install \
    ca-certificates \
    openjdk-7-jre-headless \
    unzip \
    bzip2 \
    firefox \
    wget \
  && rm -rf /var/lib/apt/lists/* \
  && sed -i 's/\/dev\/urandom/\/dev\/.\/urandom/' ./usr/lib/jvm/java-7-openjdk-amd64/jre/lib/security/java.security

RUN  mkdir -p /opt/selenium \
  && wget --no-verbose http://selenium-release.storage.googleapis.com/2.47/selenium-server-standalone-2.47.1.jar -O /opt/selenium/selenium-server-standalone.jar \ 
  && wget --no-verbose  https://ftp.mozilla.org/pub/mozilla.org/firefox/releases/34.0.5/linux-x86_64/en-US/firefox-34.0.5.tar.bz2 -O /opt/selenium/firefox-34.0.5.tar.bz2 \ 
  && bzip2 -d /opt/selenium/firefox-34.0.5.tar.bz2 \ 
  && tar -xvf /opt/selenium/firefox-34.0.5.tar && rm -rf /opt/selenium/firefox-34.0.5.tar \  
  && mv firefox /opt/firefox34 \
  && mv /usr/bin/firefox /usr/bin/firefox39 \ 
  && ln -s /opt/firefox34/firefox /usr/bin/firefox
  

RUN sudo useradd selenium --shell /bin/bash --create-home \
  && sudo usermod -a -G sudo selenium \
  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
  && echo 'selenium:password' | chpasswd
  
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

ENV TZ "US/Pacific"
RUN echo "US/Pacific" | sudo tee /etc/timezone \
  && dpkg-reconfigure --frontend noninteractive tzdata



ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
RUN locale-gen en_US.UTF-8 \
  && dpkg-reconfigure --frontend noninteractive locales \
  && apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install \
    language-pack-en \
  && rm -rf /var/lib/apt/lists/*


RUN apt-get update -qqy \
  && apt-get -qqy install \
    xvfb \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update -qqy \
  && apt-get -qqy install \
    x11vnc \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p ~/.vnc \
  && x11vnc -storepasswd password ~/.vnc/passwd


RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install \
    fonts-ipafont-gothic \
    xfonts-100dpi \
    xfonts-75dpi \
    xfonts-cyrillic \
    xfonts-scalable \
  && rm -rf /var/lib/apt/lists/*
  
RUN apt-get update -qqy \
  && apt-get -qqy install \
    fluxbox \
  && rm -rf /var/lib/apt/lists/*
  
COPY run.sh /opt/bin/run.sh
RUN chmod +x /opt/bin/run.sh
COPY config.json /opt/selenium/config.json

ENV SCREEN_WIDTH 1360
ENV SCREEN_HEIGHT 1020
ENV SCREEN_DEPTH 24
ENV DISPLAY :99.0

EXPOSE 5555 5900
CMD ["/opt/bin/run.sh"]
