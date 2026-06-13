[BITS 64]

%include "syscalls.h.asm"
%include "string.h.asm"
%include "csv.h.asm"
%include "terminal.h.asm"
%include "tui.h.asm"

section .rodata
    argc_error: db "Usage: gridvm <filename>", 0xA, 0x00
    argc_error_len: equ $ - argc_error
    parse_error: db "Invalid input file", 0xA, 0x00
    parse_error_len: equ $ - parse_error

    test: db "Hello, World!", 0x00

section .bss
    key: resb 1

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

        call terminalInit
        call terminalClear

        .loop:
            call drawGrid
            call flushScreen
            SYSCALL_READ 0, key, 1

            mov al, [rel key]

            cmp al, 17          ; Ctrl+Q
            je .exit

            jmp .loop

        .exit:
            call terminalClear
            call terminalRestore
            SYSCALL_EXIT 0

        .error:
            SYSCALL_WRITE 2, rsi, rcx
            SYSCALL_EXIT 1