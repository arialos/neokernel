#include "multiboot.h"
#include "paging.h"
#include <stdint.h>

void outb(uint16_t port, uint8_t val) { asm volatile("outb %1, %0" : : "dN"(port), "a"(val)); }

uint8_t inb(uint16_t port)
{
  uint8_t ret;
  asm volatile("inb %1, %0" : "=a"(ret) : "dN"(port));
  return ret;
}

void writeSerial(char *stri)
{
  while (*stri)
  {
    char ch = *stri++;

    while (inb(0x3F8 + 5) & 0x20 == 0)
      ;
    outb(0x3F8, ch);
  }
}

void main(multiboot_info_t *mbi, unsigned long magic)
{
  if (magic != MULTIBOOT_BOOTLOADER_MAGIC)
  {
    // Panic here
  }

  // check the 6th bit of the flage to see if a vaild
  // memory map is available
  if (!(mbi->flags >> 6 & 0x1))
  {
    // Panic here
  }

  outb(0x3F8 + 1, 0x00); // Disable all interrupts
  outb(0x3F8 + 3, 0x80); // Enable DLAB (set baud rate divisor)
  outb(0x3F8 + 0, 0x03); // Set divisor to 3 (lo byte) 38400 baud
  outb(0x3F8 + 1, 0x00); //                  (hi byte)
  outb(0x3F8 + 3, 0x03); // 8 bits, no parity, one stop bit
  outb(0x3F8 + 2, 0xC7); // Enable FIFO, clear them, with 14-byte threshold
  outb(0x3F8 + 4, 0x0B); // IRQs enabled, RTS/DSR set
  outb(0x3F8 + 4, 0x1E); // Set in loopback mode, test the serial chip
  outb(0x3F8 + 0, 0xAE); // Test serial chip (send byte 0xAE and check if serial returns same byte)

  if (inb(0x3F8 + 0) != 0xAE)
  {
    // panic here
  }
  else
  {
    outb(0x3F8 + 4, 0x0F); // Enable interrupts, RTS/DSR set
  }

  initPaging(mbi);

  writeSerial("Hello World!\n");
}