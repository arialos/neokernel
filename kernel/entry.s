# Declare constants for the multiboot header. 
.set ALIGN,         1<<0             # align loaded modules on page boundaries 
.set MEMINFO,       1<<1             # provide memory map 
.set FRAMEBUFFER,   1<<2           # provide framebuffer information 
.set FLAGS,         ALIGN | MEMINFO | FRAMEBUFFER  # this is the Multiboot 'flag' field 
.set MAGIC,         0x1BADB002       # 'magic number' lets bootloader find the header 
.set CHECKSUM,      -(MAGIC + FLAGS) # checksum of above, to prove we are multiboot 

# Declare the multiboot header. 
.section .multiboot.data, "aw"
    .align 4
multiboot_header:
    .long MAGIC
    .long FLAGS
    .long CHECKSUM
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0 # 1 = Text mode only, 0 = Graphics
    .long 600 # Screen Width
    .long 800 # Screen Height
    .long 32
 
# Allocate the initial stack.
.section .bootstrap_stack, "aw", @nobits
stack_bottom:
.skip 16384 # 16 KiB
stack_top:

# Preallocate pages used for paging. Don't hard-code addresses and assume they
# are available, as the bootloader might have loaded its multiboot structures or
# modules there. This lets the bootloader know it must avoid the addresses.
.section .bss, "aw", @nobits
	.align 4096
boot_page_directory:
	.skip 4096
boot_page_table1:
	.skip 4096
# Further page tables may be required if the kernel grows beyond 3 MiB.

# The kernel entry point.
.section .multiboot.text, "a"
.global _start
.type _start, @function
_start:
1:
	mov $stack_top, %esp
    push %eax # push the multiboot header onto the stack
    push %ebx # push the multiboot magic number onto the stack
	call main
	cli
1:
  hlt
	jmp 1b