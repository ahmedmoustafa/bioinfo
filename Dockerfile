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
screen htop parallel \
gnupg \
lsof \
git \
locate \
unrar \
bc \
aptitude \
default-jre default-jdk ant \
libssl-dev libcurl4-openssl-dev \
libxml2-dev \
libmagic-dev \
hdf5-* libhdf5-* \
fuse libfuse-dev \
libtbb-dev \
unzip liblzma-dev libbz2-dev \
bison libbison-dev


WORKDIR /root/
RUN wget -t 0 https://github.com/Kitware/CMake/releases/download/v3.16.4/cmake-3.16.4.tar.gz
RUN tar zxvf cmake-3.16.4.tar.gz
WORKDIR /root/cmake-3.16.4
RUN ./configure ; make ; make install


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

RUN git clone https://github.com/ncbi/ngs.git
RUN git clone https://github.com/ncbi/ncbi-vdb.git
RUN git clone https://github.com/ncbi/ngs-tools.git
RUN git clone https://github.com/ncbi/sra-tools.git


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
RUN make
RUN mv hisat2-* /usr/local/bin/
RUN mv hisat2 /usr/local/bin/


# Bowtie2
# ######
WORKDIR /root/
RUN  git clone https://github.com/BenLangmead/bowtie2.git
WORKDIR /root/bowtie2/
RUN make
RUN make install


# STAR
# ####
WORKDIR /root/
RUN git clone https://github.com/alexdobin/STAR.git
WORKDIR /root/STAR/source
RUN make STAR
RUN mv STAR /usr/local/bin/


# Salmon
# ######
WORKDIR /root/
RUN git clone https://github.com/COMBINE-lab/salmon.git
WORKDIR /root/salmon
RUN mkdir build
WORKDIR /root/salmon/build
RUN cmake ..
RUN make
RUN make install
RUN make test
RUN mv /root/salmon/bin/* /usr/local/bin/
RUN mv /root/salmon/lib/* /usr/local/lib/


# kallisto
# ########
WORKDIR /root/
RUN git clone https://github.com/pachterlab/kallisto.git
WORKDIR /root/kallisto/ext/htslib
RUN autoheader
RUN autoconf
WORKDIR /root/kallisto/
RUN mkdir build
WORKDIR /root/kallisto/build
RUN cmake ..
RUN make
RUN make install

# BBMap
# #####
WORKDIR /root/
RUN wget -t 0 https://downloads.sourceforge.net/project/bbmap/BBMap_38.79.tar.gz
RUN tar zxvf BBMap_38.79.tar.gz
RUN mv bbmap/* /usr/local/bin/


# Sequence Processing
# ###################
# ###################

# FASTX
# #####
WORKDIR /root/
RUN git clone https://github.com/agordon/libgtextutils.git
WORKDIR /root/libgtextutils/
RUN ./reconf
RUN ./configure
RUN make
RUN make install
WORKDIR /root/
RUN git clone https://github.com/agordon/fastx_toolkit.git
WORKDIR /root/fastx_toolkit
RUN wget -t 0 https://github.com/agordon/fastx_toolkit/files/1182724/fastx-toolkit-gcc7-patch.txt
RUN patch -p1 < fastx-toolkit-gcc7-patch.txt
RUN ./reconf
RUN ./configure
RUN make
RUN make install

# Trimmomatic
# ###########
WORKDIR /root/
RUN git clone https://github.com/timflutre/trimmomatic.git
WORKDIR /root/trimmomatic
RUN make
RUN make install INSTALL="/usr/local/"

# SeqKit
# ######
WORKDIR /root/
RUN wget -t 0 https://github.com/shenwei356/seqkit/releases/download/v0.12.0/seqkit_linux_amd64.tar.gz
RUN tar zxvf seqkit_linux_amd64.tar.gz
RUN mv seqkit /usr/local/bin/

# fastp
# #####
WORKDIR /root/
RUN git clone https://github.com/OpenGene/fastp.git
WORKDIR /root/fastp
RUN make ; make install

# HTStream
# ########
# WORKDIR /root/
# RUN git clone https://github.com/ibest/HTStream.git
# WORKDIR /root/HTStream
# RUN mkdir build
# WORKDIR /root/HTStream/build
# RUN cmake .. ; make ; make install

# fqtrim
# ######
# https://ccb.jhu.edu/software/fqtrim/
WORKDIR /root/
RUN wget -t 0 http://ccb.jhu.edu/software/fqtrim/dl/fqtrim-0.9.7.tar.gz
RUN tar zxvf fqtrim-0.9.7.tar.gz
WORKDIR /root/fqtrim-0.9.7/
RUN make ; mv fqtrim /usr/local/bin/



WORKDIR /root/

# Showing versions
# ################

RUN blastn -version
# RUN diamond --version
RUN muscle -version
RUN mafft --version
RUN tophat --version
RUN hisat2 --version
RUN bowtie2 --version
RUN STAR --version
RUN salmon --version
RUN bbmap.sh --version

