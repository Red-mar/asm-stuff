#!/bin/bash

PROC=$(nproc)

PREFIX="$HOME/opt/i386"
TARGET=i386-elf
PATH="$PREFIX/bin:$PATH"

echo "Making $TARGET binutils in $PREFIX."
wget https://ftp.gnu.org/gnu/binutils/binutils-2.33.1.tar.gz
tar -xf binutils-2.33.1.tar.gz
pushd binutils-2.33.1.tar.gz
mkdir build-i386
cd build-i386
../configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make -j $PROC
make install

popd

echo "Making $TARGET gcc in $PREFIX."
which -- $TARGET-as || echo "Could not find binutils binaries!" && exit
wget https://ftp.gnu.org/gnu/gcc/gcc-9.2.0/gcc-9.2.0.tar.gz
tar -xf gcc-9.2.0.tar.gz
pushd gcc-9.2.0
mkdir build-i386
cd build-i386
../configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc -j $PROC
make all-target-lib-gcc -j $PROC
make install-gcc
make install-target-libgcc

