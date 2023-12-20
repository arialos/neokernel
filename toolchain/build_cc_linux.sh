#!/bin/sh
export PREFIX="$HOME/opt/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"

mkdir -p $HOME/src
mkdir -p $PREFIX

cd $HOME/src
if [ ! -d "binutils-2.41" ]; then
  curl https://ftp.gnu.org/gnu/binutils/binutils-2.41.tar.gz > binutils-2.41.tar.gz
  tar xfz binutils-2.41.tar.gz
  
  rm binutils-2.41.tar.gz
fi

mkdir -p build-binutils
cd build-binutils
../binutils-2.41/configure --target=$TARGET --prefix="$PREFIX" --enable-interwork --enable-multilib --disable-nls --disable-werror
make
make install

# gcc
cd $HOME/src

if [ ! -d "gcc-13.2.0" ]; then
  curl https://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.gz > gcc-13.2.0.tar.gz
  tar xfz gcc-13.2.0.tar.gz

  rm gcc-13.2.0.tar.gz
fi

mkdir -p build-gcc
cd build-gcc
../gcc-13.2.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc
make all-target-libgcc
make install-gcc
make install-target-libgcc
