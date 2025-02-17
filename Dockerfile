FROM ubuntu:20.04 as build

ENV LANG C.UTF-8
ARG DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        binutils:i386 \
        gcc-10:i386 \
        g++-10:i386 \
        python3 \
        python \
        make \
        cmake \
        curl \
        git \
        lld \
        libsdl2-dev:i386 \
        zlib1g-dev:i386 \
        libbz2-dev:i386 \
        libpng-dev:i386 \
        libgles2-mesa-dev && \    
    ln -s /usr/bin/gcc-10 /usr/bin/gcc && \
    ln -s /usr/bin/gcc-10 /usr/bin/cc && \
    ln -s /usr/bin/g++-10 /usr/bin/g++ && \
    ln -s /usr/bin/g++-10 /usr/bin/c++

RUN git clone https://github.com/Perlmint/glew-cmake.git && \
    cmake glew-cmake && \
    make -j$(nproc) && \
    make install ARCH64=false
    
ENV    SDL2VER=2.0.22
RUN    \
    curl -sLO https://libsdl.org/release/SDL2-${SDL2VER}.tar.gz && \
    tar -xzf SDL2-${SDL2VER}.tar.gz && \
    cd SDL2-${SDL2VER} && \
    ./configure --build=i386-linux-gnu --prefix=/usr && \
    make && make install && \
    rm ../SDL2-${SDL2VER}.tar.gz && \
    cp -av /lib/libSDL* /lib/i386-linux-gnu/
    
RUN mkdir /soh
WORKDIR /soh
