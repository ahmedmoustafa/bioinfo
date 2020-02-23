FROM ubuntu

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update
RUN apt-get -y upgrade

RUN apt-get -y install apt-utils
RUN apt-get -y install dialog
RUN apt-get -y install software-properties-common

RUN apt-get update
RUN apt-get -y upgrade

RUN apt-get -y install vim nano emacs
RUN apt-get -y install curl wget
RUN apt-get -y install htop parallel
RUN apt-get -y install gnupg
RUN apt-get -y install lsof
RUN apt-get -y install git
RUN apt-get -y install locate
RUN apt-get -y install rsync
RUN apt-get -y install unrar
RUN apt-get -y install bc
RUN apt-get -y install screen
RUN apt-get -y install aptitude
RUN apt-get -y install default-jre default-jdk
