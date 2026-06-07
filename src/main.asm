[BITS 64]

%include "syscalls.h.asm"
%include "string.h.asm"
%include "csv.h.asm"

section .rodata
    argc_error: db "Usage: gridvm <filename>", 0xA
    argc_error_len: equ $ - argc_error
    parse_error: db "Invalid input file", 0xA
    parse_error_len: equ $ - parse_error

section .text
    global _start
    _start:    
        cmp qword [rsp], 2

        mov rsi, argc_error
        mov rcx, argc_error_len
        jne .error

        mov rdi, [rsp + 16]
        call parseFile
        cmp rax, 0

        mov rsi, parse_error
        mov rcx, parse_error_len
        jne .error

        SYSCALL_EXIT 0

        .error:
            SYSCALL_WRITE 2, rsi, rcx
            SYSCALL_EXIT 1