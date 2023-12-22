.text
.global loadPageDirectory
loadPageDirectory:
  push %ebp
  mov %esp, %ebp
  mov 8(%esp), %eax
  mov %eax, %cr3
  mov %ebp, %esp
  pop %ebp
  ret

.text
.global enablePaging
enablePaging:
  push %ebp
  mov %esp, %ebp

  # enable 4mb pages
  mov %cr4, %eax
  or $0x00000010, %eax
  mov %eax, %cr4
  
  # enable paging
  mov %cr0, %eax
  or $0x80000000, %eax
  mov %eax, %cr0

  mov %ebp, %esp
  pop %ebp
  ret