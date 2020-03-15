FROM ubuntu:18.04

LABEL description="Bioinformatics Docker Container"
LABEL maintainer="amoustafa@aucegypt.edu"

RUN mkdir /tmp/setup/

WORKDIR /tmp/setup/

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update ; apt-get -y upgrade

########################################################################################################################
########################################################################################################################

# Prerequisites
###############
###############


RUN apt-get -y install apt-utils \
dialog \
software-properties-common \
vim nano emacs \
rsync curl wget \
build-essential libtool autotools-dev automake autoconf \
libboost-dev libboost-all-dev libboost-system-dev libboost-program-options-dev libboost-iostreams-dev libboost-filesystem-dev \
gfortran libgfortran3 \
python python-pip python-dev python3.7 python3.7-dev python3-pip python3-venv \
default-jre default-jdk ant \
screen htop parallel \
gnupg \
lsof \
git \
locate \
unrar \
bc \
aptitude \
libssl-dev libcurl4-openssl-dev \
libxml2-dev \
libmagic-dev \
hdf5-* libhdf5-* \
fuse libfuse-dev \
libtbb-dev \
unzip liblzma-dev libbz2-dev \
bison libbison-dev \
flex \
libgmp3-dev \
libncurses5-dev libncursesw5-dev \
liblzma-dev \
caffe-cpu


# Cmake
#######
WORKDIR /tmp/setup/
RUN wget -t 0 https://github.com/Kitware/CMake/releases/download/v3.16.4/cmake-3.16.4.tar.gz
RUN tar zxvf cmake-3.16.4.tar.gz
WORKDIR /tmp/setup/cmake-3.16.4
RUN ./configure ; make ; make install

########################################################################################################################
########################################################################################################################

# Progamming
############
############

RUN apt-get -y install bioperl
RUN pip install --no-cache-dir -U biopython numpy pandas matplotlib scipy seaborn statsmodels plotly bokeh scikit-learn tensorflow keras torch theano
RUN pip3 install --no-cache-dir -U biopython numpy pandas matplotlib scipy seaborn statsmodels plotly bokeh scikit-learn tensorflow keras torch theano

# R
###
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 ; \
add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' ; \
apt-get update ; \
apt-get -y install r-base r-base-dev
RUN R -e "install.packages (c('tidyverse', 'tidylog', 'readr', 'dplyr', 'knitr', 'printr', 'rmarkdown', 'shiny', \
'ggplot2', 'gplots', 'plotly', 'rbokeh', 'circlize', 'RColorBrewer', 'formattable', \
'reshape2', 'data.table', 'readxl', 'devtools', 'cowplot', 'tictoc', 'ggpubr', 'patchwork', 'reticulate', \
'randomForest', 'randomForestExplainer', 'forestFloor', 'randomForestSRC', 'ggRandomForests', 'xgboost', 'gbm', 'iml', \
'vegan', 'BiocManager'))"
RUN R -e "BiocManager::install(c('DESeq2', 'edgeR', 'dada2', 'phyloseq', 'metagenomeSeq'), ask = FALSE, update = TRUE)"
RUN R -e "update.packages(ask = FALSE)"

RUN R -e "install.packages('tensorflow')" ; \
R -e "library(tensorflow) ; install_tensorflow()"

RUN R -e "devtools::install_github('rstudio/keras')" ; \
R -e "library(keras) ; install_keras()"

########################################################################################################################
########################################################################################################################