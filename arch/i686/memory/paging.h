#ifndef PAGING_H
#define PAGING_H

#include <stdint.h>
#include "multiboot.h"

extern void loadPageDirectory(unsigned int *);
extern void enablePaging();

// Page Directory Entry (PDE)
struct page_directory_entry
{
  uint32_t P : 1;        // Present
  uint32_t RW : 1;       // Read/Write
  uint32_t US : 1;       // User/Supervisor
  uint32_t PWT : 1;      // Page-Level Write-Through
  uint32_t PCD : 1;      // Page-Level Cache Disable
  uint32_t A : 1;        // Accessed
  uint32_t D : 1;        // Dirty
  uint32_t PS : 1;       // Page Size
  uint32_t G : 1;        // Global
  uint32_t PAT : 1;      // Page Attribute Table
  uint32_t reserved : 2; // Reserved for future use
  uint32_t addr : 20;    // Page table base address
};
typedef struct page_directory_entry page_directory_entry_t;

// Page Table Entry (PTE)
struct page_table_entry
{
  uint32_t P : 1;        // Present
  uint32_t RW : 1;       // Read/Write
  uint32_t US : 1;       // User/Supervisor
  uint32_t PWT : 1;      // Page-Level Write-Through
  uint32_t PCD : 1;      // Page-Level Cache Disable
  uint32_t A : 1;        // Accessed
  uint32_t D : 1;        // Dirty
  uint32_t PAT : 1;      // Page Attribute Table
  uint32_t G : 1;        // Global
  uint32_t reserved : 3; // Reserved for future use
  uint32_t addr : 20;    // Page base address
};
typedef struct page_table_entry page_table_entry_t;

int initPaging(multiboot_info_t *mbi);
#endif // PAGING_H