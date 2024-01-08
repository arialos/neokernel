TARGET=i686-elf
PROJDIRS := arch boot kernel lib
DESTDIR = build
INCLUDES = -Ikernel -Iboot -Iarch/i686 -Iarch/i686/memory

CC = $(HOME)/opt/cross/bin/$(TARGET)

VERSIONFILE = kernel/version.h
CFILES := $(shell find $(PROJDIRS) -type f -name "*.c")
ASMFILES := $(shell find $(PROJDIRS) -type f -name "*.s")
HDRFILES := $(shell find $(PROJDIRS) -type f -name "*.h")
DEPFILES := $(patsubst %.c,%.d,$(CFILES))

SRCFILES := $(CFILES) $(ASMFILES)

OBJFILES := $(patsubst %.c,%.o,$(SRCFILES))

WARNINGS = -Wall -Wextra -pedantic -Wshadow -Wpointer-arith -Wcast-align \
            -Wwrite-strings -Wmissing-prototypes -Wmissing-declarations \
            -Wredundant-decls -Wnested-externs -Winline -Wno-long-long \
            -Wconversion -Wstrict-prototypes

OPTFLAGS = -fexpensive-optimizations -ftree-loop-vectorize -finline-functions -fomit-frame-pointer -ftree-vectorize -O1 -mtune=generic
CFLAGS = -std=gnu99 -ffreestanding -fno-stack-protector -nostdlib $(WARNINGS) -m32 $(INCLUDES) -g
LDFLAGS = -ffreestanding -O2 -nostdlib -lgcc
ASFLAGS = -march=i686 --32

.PHONY: all clean run iso
.SUFFIXES: .o .c .s

all: neo.elf

neo.elf: version.h $(OBJFILES) linker.ld
	@$(CC)-gcc -T linker.ld -o $@ $(LDFLAGS) $(OBJFILES)
	@echo Linking $@
    

version.h: 
	@echo "#define KERNEL_VERSION \"0.0.1\"" > $(VERSIONFILE)
	@echo "#define KERNEL_BUILD_DATE \"`date +%Y-%m-%d`\"" >> $(VERSIONFILE)
	@echo "#define KERNEL_BUILD_TIME \"`date +%H:%M:%S`\"" >> $(VERSIONFILE)
	@echo "#define KERNEL_BUILD_NUMBER \"`date +%Y%m%d%H%M%S`\"" >> $(VERSIONFILE)

.c.o:
	@echo Compiling $<
	@$(CC)-gcc $(CFLAGS) $(OPTFLAGS) -c $< -o $@

.s.o:
	@echo Assembling $<
	@$(CC)-as $(ASFLAGS) -c $< -o $@

iso: neo.elf
	@mkdir build
	@cp neo.elf limine.cfg limine/limine-bios.sys limine/limine-bios-cd.bin limine/BOOTIA32.EFI build
	@xorriso -as mkisofs -b limine-bios-cd.bin -no-emul-boot -boot-load-size 4 -boot-info-table --efi-boot BOOTIA32.EFI -efi-boot-part --efi-boot-image --protective-msdos-label build -o build/arial.iso

format:
	@clang-format -i $(CFILES) $(HDRFILES)

clean:
	@echo "Cleaning build directory..."
	@rm -f $(OBJ) $(DEPFILES) arial.* *.img *.iso
	@rm -f $(VERSIONFILE)
	@rm -rf $(DESTDIR)

run: clean iso
	qemu-system-i386 -serial stdio -cdrom build/arial.iso -vga std -d int -no-reboot

debug: clean iso
	qemu-system-i386 -s -cdrom build/arial.iso

-include $(DEPFILES)