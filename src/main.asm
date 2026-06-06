[BITS 64]

%include "syscalls.h.asm"
%include "string.h.asm"

section .text
    global _start
    _start:
        mov rdi, [rsp + 16]
        mov rsi, rdi
        call strlen

        mov rcx, rax

        SYSCALL_WRITE 1, rsi, rcx

        SYSCALL_EXIT 0