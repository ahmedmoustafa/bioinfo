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
WORKDIR /root/
RUN git clone https://github.com/bbuchfink/diamond.git
WORKDIR /root/diamond/
RUN mkdir bin
WORKDIR /root/diamond/bin/
RUN cmake .. ; make install

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
RUN ./reconf ; ./configure ; make ; make install
WORKDIR /root/
RUN git clone https://github.com/agordon/fastx_toolkit.git
WORKDIR /root/fastx_toolkit
RUN wget -t 0 https://github.com/agordon/fastx_toolkit/files/1182724/fastx-toolkit-gcc7-patch.txt
RUN patch -p1 < fastx-toolkit-gcc7-patch.txt
RUN ./reconf ; ./configure ; make ; make install

# Trimmomatic
# ###########
WORKDIR /root/
RUN git clone https://github.com/timflutre/trimmomatic.git
WORKDIR /root/trimmomatic
RUN make ; make install INSTALL="/usr/local/"

# SeqKit
# ######
WORKDIR /root/
RUN wget -t 0 https://github.com/shenwei356/seqkit/releases/download/v0.12.0/seqkit_linux_amd64.tar.gz
RUN tar zxvf seqkit_linux_amd64.tar.gz ; mv seqkit /usr/local/bin/

# fastp
# #####
WORKDIR /root/
RUN git clone https://github.com/OpenGene/fastp.git
WORKDIR /root/fastp
RUN make ; make install

# HTStream
# ########
WORKDIR /root/
# RUN git clone https://github.com/ibest/HTStream.git
# WORKDIR /root/HTStream
# RUN mkdir build
# WORKDIR /root/HTStream/build
# RUN cmake .. ; make ; make install
RUN wget -t 0 https://github.com/ibest/HTStream/releases/download/v1.0.0-release/HTStream_1.0.0-release.tar.gz ; \
tar zxvf HTStream_1.0.0-release.tar.gz ; \
mv hts_* /usr/local/bin/


# fqtrim
# ######
# https://ccb.jhu.edu/software/fqtrim/
WORKDIR /root/
RUN wget -t 0 http://ccb.jhu.edu/software/fqtrim/dl/fqtrim-0.9.7.tar.gz
RUN tar zxvf fqtrim-0.9.7.tar.gz
WORKDIR /root/fqtrim-0.9.7/
RUN make ; mv fqtrim /usr/local/bin/


# Phylogenetics
# #############
# #############

# TreeTime
# ########
RUN pip3 install phylo-treetime

# FastTree
# ########
WORKDIR /root/
RUN wget -t 0 http://www.microbesonline.org/fasttree/FastTree.c ; \
gcc -O3 -finline-functions -funroll-loops -Wall -o FastTree FastTree.c -lm ; \
gcc -DOPENMP -fopenmp -O3 -finline-functions -funroll-loops -Wall -o FastTreeMP FastTree.c -lm ; \
mv FastTree /usr/local/bin ; \
mv FastTreeMP /usr/local/bin 

# RAxML
# #####
WORKDIR /root/
RUN git clone https://github.com/stamatak/standard-RAxML.git
WORKDIR /root/standard-RAxML

RUN rm *.o ; make -f Makefile.gcc ; cp raxmlHPC /usr/local/bin/ ; \
rm *.o ; make -f Makefile.SSE3.gcc ; cp raxmlHPC-SSE3 /usr/local/bin/ ; \
rm *.o ; make -f Makefile.PTHREADS.gcc ; cp raxmlHPC-PTHREADS /usr/local/bin/ ; \
rm *.o ; make -f Makefile.SSE3.PTHREADS.gcc ; cp raxmlHPC-PTHREADS-SSE3 /usr/local/bin/ ; \
rm *.o ; make -f Makefile.MPI.gcc ; cp raxmlHPC-MPI /usr/local/bin/ ; \
rm *.o ; make -f Makefile.SSE3.MPI.gcc ; cp raxmlHPC-MPI-SSE3 /usr/local/bin/

# RAxML NG
# ########
WORKDIR /root/
RUN git clone --recursive https://github.com/amkozlov/raxml-ng
WORKDIR /root/raxml-ng
RUN mkdir build
WORKDIR /root/raxml-ng/build
RUN cmake .. ; make ; mv ../bin/raxml-ng /usr/local/bin/ ; \
cmake -DSTATIC_BUILD=ON -DENABLE_RAXML_SIMD=OFF -DENABLE_PLLMOD_SIMD=OFF .. ; make ; mv ../bin/raxml-ng-static /usr/local/bin/ ; \
cmake -DUSE_MPI=ON .. ; make ; mv ../bin/raxml-ng-mpi /usr/local/bin/


# PhyML
# #####
WORKDIR /root/
RUN git clone https://github.com/stephaneguindon/phyml.git
WORKDIR /root/phyml/
RUN sh ./autogen.sh; ./configure ; make ; make install


# BAM Processing
################
################

# HTSlib
########
WORKDIR /root/
RUN git clone https://github.com/samtools/htslib.git
WORKDIR /root/htslib
RUN autoheader ; autoconf ; ./configure ; make ; make install

# Samtools
##########
WORKDIR /root/
RUN git clone git://github.com/samtools/samtools.git
WORKDIR /root/samtools
RUN autoheader ; autoconf ; ./configure ; make ; make install

# Bcftools
##########
WORKDIR /root/
RUN git clone https://github.com/samtools/bcftools.git
WORKDIR /root/bcftools
RUN autoheader ; autoconf ; ./configure ; make ; make install


# Bamtools
##########
WORKDIR /root/
RUN git clone git://github.com/pezmaster31/bamtools.git
WORKDIR /root/bamtools
RUN mkdir build
WORKDIR /root/bamtools/build
RUN cmake .. ; make ; make install

# VCFtools
##########
WORKDIR /root/
RUN git clone https://github.com/vcftools/vcftools.git
WORKDIR /root/vcftools
RUN ./autogen.sh ; ./configure ; make ; make install

# Bedtools
##########
WORKDIR /root/
RUN git clone https://github.com/arq5x/bedtools2.git
WORKDIR /root/bedtools2
RUN make ; make install

# deepTools
###########
WORKDIR /root/
RUN git clone https://github.com/deeptools/deepTools
WORKDIR /root/deepTools
RUN python setup.py install

# BEDOPS
########
WORKDIR /root/
RUN git clone https://github.com/bedops/bedops.git
WORKDIR /root/bedops
RUN make ; make install ; mv ./bin/* /usr/local/bin/

# Assemblers
############
############

# SPAdes
########
WORKDIR /root/
RUN git clone https://github.com/ablab/spades.git
WORKDIR /root/spades/assembler
RUN PREFIX=/usr/local ./spades_compile.sh ; spades.py --test

# ABySS
#######
WORKDIR /root/
RUN git clone https://github.com/sparsehash/sparsehash.git
WORKDIR /root/sparsehash
RUN ./autogen.sh ; ./configure ; make ; make install
WORKDIR /root/
RUN git clone https://github.com/bcgsc/abyss.git
WORKDIR /root/abyss
RUN ./autogen.sh ; ./configure ; make ; make install

# Velvet
########
WORKDIR /root/
RUN git clone https://github.com/dzerbino/velvet.git
WORKDIR /root/velvet/
RUN make ; mv velvet* /usr/local/bin/

# MEGAHIT
#########
WORKDIR /root/
RUN git clone https://github.com/voutcn/megahit.git
WORKDIR /root/megahit
RUN git submodule update --init
RUN mkdir build
WORKDIR /root/megahit/build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release ; make -j4 ; make simple_test  ; make install

# MetaVelvet
############
WORKDIR /root/
RUN git clone git://github.com/hacchy/MetaVelvet.git
WORKDIR /root/MetaVelvet
RUN make ; mv meta-velvetg /usr/local/bin/




WORKDIR /root/

# Showing versions
# ################
RUN python3.7 --version
RUN blastn -version
RUN diamond --version
RUN muscle -version
RUN mafft --version
RUN tophat --version
RUN hisat2 --version
RUN bowtie2 --version
RUN STAR --version
RUN salmon --version
RUN bbmap.sh --version
RUN hts_Stats --version
RUN treetime --version
# RUN FastTree
# RUN phyml --version
RUN raxmlHPC -v
RUN raxml-ng --version
RUN samtools  --version
RUN bcftools  --version
RUN bamtools --version
RUN vcftools --version
RUN bedtools --version
RUN deeptools --version
RUN bedops --version
RUN spades.py --version
RUN megahit --version
