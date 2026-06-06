[BITS 64]

%include "syscalls.asm"

section .text
    global _start
    _start:
        SYSCALL_EXIT 0