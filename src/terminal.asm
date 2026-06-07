[BITS 64]

%include "terminal.h.asm"
%include "syscalls.h.asm"
%include "string.h.asm"

section .bss
    termios: resb 64
    oldtermios: resb 64
    buffer: resb 16

section .rodata
    clear_screen: db 0x1b, "[2J", 0x1b, "[H"
    clear_len: equ $ - clear_screen
    esc: db 0x1b, "["
    semi: db ";"
    H: db "H"

section .text
    terminalInit:
        SYSCALL_IOCTL 0, TCGETS, termios

        lea rsi, [rel termios]
        lea rdi, [rel oldtermios]
        mov rcx, 8

        .copy:
            mov rax, [rsi]
            mov [rdi], rax
            add rsi, 8
            add rdi, 8
            loop .copy

            mov rax, [termios + 12]

            mov rbx, ~(ICANON | ECHO | ISIG | ECHOE | IEXTEN)
            and rax, rbx

            mov [termios + 12], rax
            mov rax, [termios + 0]

            mov rbx, ~(IXON | ICRNL | BRKINT | INPCK | ISTRIP)
            and rax, rbx

            mov [termios + 0], rax
            mov rax, [termios + 8]

            and rax, ~0x1
            mov [termios + 8], rax

            SYSCALL_IOCTL 0, TCSETS, termios

            ret

    terminalRestore:
        SYSCALL_IOCTL 0, TCSETS, oldtermios
        ret

    terminalClear:
        SYSCALL_WRITE 1, clear_screen, clear_len
        ret

    print_number:
        push rbp
        mov rbp, rsp
        sub rsp, 16

        mov rsi, rdi 
        mov rdi, rsp

        call itoa2

        mov rsi, rax
        mov rdx, 2
        mov rax, 1
        mov rdi, 1
        syscall

        leave
        ret

    terminalCursorSet:
        push rbp
        push rbx

        mov rbp, rsi
        mov rbx, rdi

        SYSCALL_WRITE 1, esc, 2

        mov rdi, rbp
        call print_number

        SYSCALL_WRITE 1, semi, 1

        mov rdi, rbx
        call print_number

        SYSCALL_WRITE 1, H, 1

        pop rbx
        pop rbp
        ret