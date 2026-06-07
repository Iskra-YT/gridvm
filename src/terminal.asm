[BITS 64]

%include "terminal.h.asm"
%include "syscalls.h.asm"

section .bss
    termios: resb 64
    oldtermios: resb 64

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