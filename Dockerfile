FROM ubuntu:18.04

LABEL description="Bioinformatics Docker Container"
LABEL maintainer="amoustafa@aucegypt.edu"

WORKDIR /root/

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update ; apt-get -y upgrade

RUN apt-get -y install apt-utils \
dialog \
software-properties-common \
vim nano emacs \
rsync curl wget \
build-essential libtool autotools-dev automake autoconf \
libboost-dev libboost-all-dev libboost-system-dev libboost-program-options-dev libboost-iostreams-dev libboost-filesystem-dev \
gfortran libgfortran3 \
python python-pip python-dev python3.7 python3.7-dev python3-pip \
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
liblzma-dev


# Cmake
# #####
WORKDIR /root/
RUN wget -t 0 https://github.com/Kitware/CMake/releases/download/v3.16.4/cmake-3.16.4.tar.gz
RUN tar zxvf cmake-3.16.4.tar.gz
WORKDIR /root/cmake-3.16.4
RUN ./configure ; make ; make install


# R
# #
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 ; \
add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' ; \
apt-get update ; \
apt-get -y install r-base r-base-dev
RUN R -e "install.packages (c('tidyverse', 'tidylog', 'readr', 'dplyr', 'knitr', 'printr', 'rmarkdown', 'shiny', 'ggplot2', 'gplots', 'reshape2', 'data.table', 'readxl', 'devtools', 'cowplot', 'tictoc', 'ggpubr', 'patchwork', 'vegan', 'BiocManager'))"
RUN R -e "BiocManager::install(c('DESeq2', 'edgeR', 'dada2', 'phyloseq', 'metagenomeSeq'), ask = FALSE, update = TRUE)"
RUN R -e "update.packages(ask = FALSE)"



# Sequence search
# ###############
# ###############

# NCBI BLAST & HMMER
# ##################
RUN apt-get -y install \
ncbi-blast+ \
hmmer

# Diamond
# #######
# WORKDIR /root/
# RUN git clone https://github.com/bbuchfink/diamond.git
# WORKDIR /root/diamond/
# RUN mkdir bin
# WORKDIR /root/diamond/bin/
# RUN cmake .. ; make install


# NCBI Tools
# ##########
WORKDIR /root/
RUN mkdir ncbi
WORKDIR /root/ncbi

RUN git clone https://github.com/ncbi/ngs.git ; \
git clone https://github.com/ncbi/ncbi-vdb.git ; \
git clone https://github.com/ncbi/ngs-tools.git ; \
git clone https://github.com/ncbi/sra-tools.git


WORKDIR /root/ncbi/ncbi-vdb
RUN ./configure ; make ; make install

WORKDIR /root/ncbi/ngs
RUN ./configure ; make ; make install

WORKDIR /root/ncbi/ngs/ngs-sdk
RUN ./configure ; make ; make install

WORKDIR /root/ncbi/ngs/ngs-python
RUN ./configure ; make ; make install

WORKDIR /root/ncbi/ngs/ngs-java
RUN ./configure ; make ; make install

WORKDIR /root/ncbi/ngs/ngs-bam
RUN ./configure ; make ; make install

WORKDIR /root/ncbi/ngs-tools
RUN ./configure ; make ; make install

WORKDIR /root/ncbi/sra-tools
RUN ./configure ; make ; make install




# Alignment Tools
# ###############
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
RUN make ; mv muscle /usr/local/bin/

# MAFFT
# #####
WORKDIR /root/
RUN wget -t 0 https://mafft.cbrc.jp/alignment/software/mafft-7.453-with-extensions-src.tgz
RUN tar zxvf mafft-7.453-with-extensions-src.tgz
WORKDIR /root/mafft-7.453-with-extensions/core
RUN make clean ; make ; make install
WORKDIR /root/mafft-7.453-with-extensions/extensions/
RUN make clean ; make ; make install

# BWA
# ###
WORKDIR /root/
RUN git clone https://github.com/lh3/bwa.git
WORKDIR /root/bwa
RUN make ; mv bwa /usr/local/bin/

# TopHat
# ######
# (It does not compile)
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
RUN make ; mv hisat2-* /usr/local/bin/ ; mv hisat2 /usr/local/bin/


# Bowtie2
# ######
WORKDIR /root/
RUN  git clone https://github.com/BenLangmead/bowtie2.git
WORKDIR /root/bowtie2/
RUN make ; make install


# STAR
# ####
WORKDIR /root/
RUN git clone https://github.com/alexdobin/STAR.git
WORKDIR /root/STAR/source
RUN make STAR ; mv STAR /usr/local/bin/


# Salmon
# ######
WORKDIR /root/
RUN git clone https://github.com/COMBINE-lab/salmon.git
WORKDIR /root/salmon
RUN mkdir build
WORKDIR /root/salmon/build
RUN cmake .. ; make ; make install ; make test ; mv /root/salmon/bin/* /usr/local/bin/ ; mv /root/salmon/lib/* /usr/local/lib/


# kallisto
# ########
WORKDIR /root/
RUN git clone https://github.com/pachterlab/kallisto.git
WORKDIR /root/kallisto/ext/htslib
RUN autoheader ; autoconf
WORKDIR /root/kallisto/
RUN mkdir build
WORKDIR /root/kallisto/build
RUN cmake .. ; make ; make install
RUN R -e "BiocManager::install('pachterlab/sleuth', ask = FALSE, update = TRUE)"

# BBMap
# #####
WORKDIR /root/
RUN wget -t 0 https://downloads.sourceforge.net/project/bbmap/BBMap_38.79.tar.gz
RUN tar zxvf BBMap_38.79.tar.gz
RUN mv bbmap/* /usr/local/bin/





WORKDIR /root/

