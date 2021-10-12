# Allow control over the ERAN version which is being built
ARG eran_version=master

FROM --platform=linux/amd64 debian:latest

LABEL org.opencontainers.image.authors="tobias.lorenz@cispa.de"

# install ERAN dependencies
RUN apt-get update && apt-get install -y \
    # ERAN dependencies
    m4 build-essential autoconf libtool texlive-latex-base \
    # ONNX dependencies
    protobuf-compiler libprotoc-dev \
    # general setup tools
    wget git

# install cmake 3
RUN wget -nv https://github.com/Kitware/CMake/releases/download/v3.19.7/cmake-3.19.7-Linux-x86_64.sh \
    && bash ./cmake-3.19.7-Linux-x86_64.sh --skip-license \
    && ln -s ./cmake-3.19.7-Linux-x86_64/bin/cmake /usr/bin/cmake

# install miniconda3
RUN wget -nv https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH="/root/miniconda3/bin:$PATH"

# clone ERAN repository
RUN git clone https://github.com/eth-sri/ERAN.git \
    && git checkout $eran_version

WORKDIR /ERAN

# install ERAN
RUN bash ./install.sh

# install python dependencies
RUN pip install -r requirements.txt

WORKDIR /ERAN/tf_verify
