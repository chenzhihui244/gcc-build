#!/bin/sh

[ -f gcc-9.2.0.tar.xz ] ||
wget https://mirrors.huaweicloud.com/gnu/gcc/gcc-9.2.0/gcc-9.2.0.tar.xz

[ -d gcc-9.2.0 ] || {
        tar xf gcc-9.2.0.tar.xz
        cd gcc-9.2.0 &&
        ./contrib/download_prerequisites
}

download() {
        [ -f gcc-9.2.0/gmp-6.1.0.tar.bz2 ] ||
        wget ftp://gcc.gnu.org/pub/gcc/infrastructure/gmp-6.1.0.tar.bz2
        [ -f gcc-9.2.0/mpfr-3.1.4.tar.bz2 ] ||
        wget ftp://gcc.gnu.org/pub/gcc/infrastructure/mpfr-3.1.4.tar.bz2
        [ -f gcc-9.2.0/mpc-1.0.3.tar.gz ] ||
        wget ftp://gcc.gnu.org/pub/gcc/infrastructure/mpc-1.0.3.tar.gz
        [ -f gcc-9.2.0/isl-0.18.tar.bz2 ] ||
        wget ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-0.18.tar.bz2
}

build_gcc() {
        cd gcc-9.2.0 &&
        rm -rf build &&
        mkdir build &&
        cd build &&
        ../configure --disable-multilib --enable-languages=c,c++,fortran --prefix=/opt/gcc/9.2.0 --disable-static --enable-shared &&
        make -j`nproc` &&
        make install
        cd /opt/gcc/9.2.0 &&
        ln -s gcc cc
}

setup_env() {
        LD_LIBRARY_PATH=/opt/gcc/9.2.0/lib64:$LD_LIBRARY_PATH
        LD_RUN_PATH=/opt/gcc/9.2.0/lib64:$LD_RUN_PATH
        PATH=/opt/gcc/9.2.0/bin:$PATH
        export LD_LIBRARY_PATH PATH LD_RUN_PATH
}

setup_env

