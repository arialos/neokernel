# neokernel
A simple x86 hobby kernel designed for learning.
## About
A rewrite of [arialos/kernel](https://github.com/arialos/kernel) because the codebase was created in a rush and has become a tangled mess.
## Building
### Linux

First, make sure you have install all the prerequisite tools for building. This guide is designed for Debian based distro but a table of equivalent packages can be found [here](https://wiki.osdev.org/GCC_Cross-Compiler#Installing_Dependencies).

```sh
$ sudo apt install -y build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo xorriso qemu-system-i386
```

Then, simply build the cross compiler with:

```sh
$ ./toolchain/build_cc_linux.sh
```

### macOS

> [!WARNING]
> macOS building can be temperamental and it is recommended to use Linux if posible.

First, make sure you have install all the prerequisite tools for building:

```sh
$ brew install gmp mpfr libmpc autoconf automake xorriso texinfo qemu gdb
```

Then, simply build the cross compiler with:

```sh
$ ./toolchain/build_cc_macos.sh
```




### Windows
> [!WARNING]
> Currently there is no dedicated build script for Windows. It's suggested to use the Linux tools under WSL 2
