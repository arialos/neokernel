#include <stdint.h>
#include "paging.h"
#include "multiboot.h"

int initPaging(multiboot_info_t *mbi)
{
  uint32_t page_directory[1024] __attribute__((aligned(4096)));

  for (int i = 0; i < 1024; i++)
  {
    // This sets the following flags to the pages:
    //   Supervisor: Only kernel-mode can access them
    //   Write Enabled: It can be both read from and written to
    //   Not Present: The page table is not present
    page_directory[i] = 0x00000002;
  }

  for (int t = 0; t < 6; t++)
  {
    uint32_t page_table[1024] __attribute__((aligned(4096)));

    // we will fill all 1024 entries in the table, mapping 4 megabytes
    for (unsigned int i = 0; i < 1024; i++)
    {
      // As the address is page aligned, it will always leave 12 bits zeroed.
      // Those bits are used by the attributes ;)
      page_table[i] = (i * 0x1000) | 3; // attributes: supervisor level, read/write, present.
    }
    // attributes: supervisor level, read/write, present
    page_directory[0] = ((unsigned int)page_table) | 3;
  }

  loadPageDirectory(page_directory);
  enablePaging();

  return 0;
}