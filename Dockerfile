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
RUN apt-get -y install libssl-dev libcurl4-openssl-dev
RUN apt-get -y install libxml2-dev

# R
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/'
RUN apt-get update
RUN apt-get -y install r-base r-base-dev

# R general packages
RUN R -e "install.packages (c('tidyverse', 'tidylog', 'readr', 'dplyr', 'knitr', 'printr', 'rmarkdown', 'shiny', 'ggplot2', 'gplots', 'reshape2', 'data.table', 'readxl', 'devtools', 'cowplot', 'tictoc', 'ggpubr'))"

# R bio package
RUN R -e "install.packages (c('BiocManager', 'vegan'))"
RUN R -e "BiocManager::install(c('DESeq2', 'edgeR', 'dada2', 'phyloseq', 'metagenomeSeq'), ask = FALSE, update = TRUE)"
RUN R -e "update.packages(ask = FALSE)"

# Bioinformatics tools
# Sequence search
RUN apt-get -y install ncbi-blast+
