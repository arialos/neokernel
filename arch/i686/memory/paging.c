#include <stdint.h>
#include "paging.h"
#include "multiboot.h"

extern char _kernel_start;
extern char _kernel_end;

// Assuming these are defined somewhere in your kernel
uint32_t boot_page_table1[1024] __attribute__((aligned(4096)));
uint32_t boot_page_directory[1024] __attribute__((aligned(4096)));

int initPaging(multiboot_info_t *mbi)
{
  // Map 1023 pages
  for (uint32_t i = 0; i < 1023; i++)
  {
    // Only map the kernel
    if (i * 4096 >= (uint32_t)&_kernel_start && i * 4096 < (uint32_t)&_kernel_end)
    {
      // Map physical address as "present, writable"
      boot_page_table1[i] = (i * 4096) | 3;
    }
  }

  // Map VGA video memory to 0xC03FF000 as "present, writable"
  boot_page_table1[1023] = 0x000B8000 | 3;

  // Map the page table to both virtual addresses 0x00000000 and 0xC0000000
  boot_page_directory[0] = ((uint32_t)boot_page_table1) | 3;
  boot_page_directory[768] = ((uint32_t)boot_page_table1) | 3;

  // Set cr3 to the address of the boot_page_directory
  loadPageDirectory(boot_page_directory);

  // Enable paging and the write-protect bit
  enablePaging();

  // // Unmap the identity mapping as it is now unnecessary
  // boot_page_directory[0] = 0;

  // // Reload cr3 to force a TLB flush so the changes take effect
  // loadPageDirectory(boot_page_directory);

  return 0;
}