FROM ubuntu:18.04

LABEL description="Bioinformatics Docker Container"
LABEL maintainer="amoustafa@aucegypt.edu"

WORKDIR /root/

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
RUN apt-get -y install build-essential libtool libboost-all-dev autotools-dev automake autoconf
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
RUN apt-get -y install ant
RUN apt-get -y install libssl-dev libcurl4-openssl-dev
RUN apt-get -y install libxml2-dev
RUN apt-get -y install autoconf cmake
RUN apt-get -y install libmagic-dev \
libhdf5-dev \
fuse libfuse-dev \
libtbb-dev

# R
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/'
RUN apt-get update
RUN apt-get -y install r-base r-base-dev

# R general packages
RUN R -e "install.packages (c('tidyverse', 'tidylog', 'readr', 'dplyr', 'knitr', 'printr', 'rmarkdown', 'shiny', 'ggplot2', 'gplots', 'reshape2', 'data.table', 'readxl', 'devtools', 'cowplot', 'tictoc', 'ggpubr', 'patchwork'))"

# R bio package
RUN R -e "install.packages (c('BiocManager', 'vegan'))"
RUN R -e "BiocManager::install(c('DESeq2', 'edgeR', 'dada2', 'phyloseq', 'metagenomeSeq'), ask = FALSE, update = TRUE)"
RUN R -e "update.packages(ask = FALSE)"

# Bioinformatics tools
# Sequence search
RUN apt-get -y install \
ncbi-blast+ \
hmmer

# Diamond
# #######
# RUN git clone https://github.com/bbuchfink/diamond.git
# WORKDIR /root/diamond/
# RUN mkdir bin
# WORKDIR /root/diamond/bin/
# RUN cmake ..
# RUN make install


# NCBI Tools
# ##########
RUN mkdir ncbi
WORKDIR /root/ncbi

RUN git clone https://github.com/ncbi/ngs.git
RUN git clone https://github.com/ncbi/ncbi-vdb.git
RUN git clone https://github.com/ncbi/ngs-tools.git
RUN git clone https://github.com/ncbi/sra-tools.git


WORKDIR /root/ncbi/ncbi-vdb
RUN ./configure
RUN make
RUN make install

WORKDIR /root/ncbi/ngs
RUN ./configure
RUN make
RUN make install

WORKDIR /root/ncbi/ngs/ngs-sdk
RUN ./configure
RUN make
RUN make install

WORKDIR /root/ncbi/ngs/ngs-python
RUN ./configure
RUN make
RUN make install

WORKDIR /root/ncbi/ngs/ngs-java
RUN ./configure
RUN make
RUN make install

WORKDIR /root/ncbi/ngs/ngs-bam
RUN ./configure
RUN make
RUN make install

WORKDIR /root/ncbi/ngs-tools
RUN ./configure
RUN make
RUN make install

WORKDIR /root/ncbi/sra-tools
RUN ./configure
RUN make
RUN make install

WORKDIR /root/

# CD-HIT
# ######
RUN git clone https://github.com/weizhongli/cdhit.git
WORKDIR /root/cdhit/
RUN make
RUN make install

WORKDIR /root/

# Alignment Tools
# ###############

# JAligner
# ########
RUN apt-get -y install jaligner

# MUSCLE
# ######
WORKDIR /root/
RUN wget -t 0 https://www.drive5.com/muscle/downloads3.8.31/muscle3.8.31_src.tar.gz
RUN tar zxvf muscle3.8.31_src.tar.gz
WORKDIR /root/muscle3.8.31/src
RUN make
RUN mv muscle /usr/local/bin/

# MAFFT
# #####
WORKDIR /root/
RUN wget -t 0 https://mafft.cbrc.jp/alignment/software/mafft-7.453-with-extensions-src.tgz
RUN tar zxvf mafft-7.453-with-extensions-src.tgz
WORKDIR /root/mafft-7.453-with-extensions/core
RUN make clean
RUN make
RUN make install
WORKDIR /root/mafft-7.453-with-extensions/extensions/
RUN make clean
RUN make
RUN make install

# BWA
# ###
WORKDIR /root/
RUN git clone https://github.com/lh3/bwa.git
WORKDIR /root/bwa
RUN make
RUN mv bwa /usr/local/bin/

# TopHat
# ######
# (It does not complile)
WORKDIR /root/
RUN wget -t 0 https://ccb.jhu.edu/software/tophat/downloads/tophat-2.1.1.Linux_x86_64.tar.gz
RUN tar zxvf tophat-2.1.1.Linux_x86_64.tar.gz
WORKDIR /root/tophat-2.1.1.Linux_x86_64
RUN mv tophat* /usr/local/bin/

# HISAT2
# ######
WORKDIR /root/
RUN git clone https://github.com/infphilo/hisat2.git
WORKDIR /root/hisat2
RUN make
RUN mv hisat2-* /usr/local/bin/
RUN mv hisat2 /usr/local/bin/


WORKDIR /root/

RUN blastn -version
# RUN diamond --version
RUN R --version
RUN muscle -version
RUN mafft --version
RUN tophat --version
RUN hisat2 --version