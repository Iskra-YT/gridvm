[BITS 64]

%include "syscalls.h.asm"
%include "string.h.asm"

section .rodata
    argc_error: db "Usage: gridvm <filename>", 0xA
    argc_error_len: equ $ - argc_error

section .text
    global _start
    _start:    
        cmp qword [rsp], 2

        mov rsi, argc_error
        mov rcx, argc_error_len
        jne .error

        mov rdi, [rsp + 16]
        mov rsi, rdi
        call strlen

        mov rcx, rax

        SYSCALL_WRITE 1, rsi, rcx

        SYSCALL_EXIT 0

        .error:
            SYSCALL_WRITE 2, rsi, rcx
            SYSCALL_EXIT 1