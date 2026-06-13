[BITS 64]

%include "terminal.h.asm"
%include "syscalls.h.asm"
%include "string.h.asm"
%include "tui.h.asm"

section .bss
    termios: resb 64
    oldtermios: resb 64
    buffer: resb 16
    screen_buffer: resb 2000

section .rodata
    clear_screen: db 0x1b, "[2J", 0x1b, "[H"
    clear_len: equ $ - clear_screen

    esc: db 0x1b, "["
    semi: db ";"
    H: db "H"

    alt_screen_on:  db 0x1b, "[?1049h"
    alt_screen_on_len: equ $ - alt_screen_on

    alt_screen_off: db 0x1b, "[?1049l"
    alt_screen_off_len: equ $ - alt_screen_off

    screen_width:  equ 80
    screen_height: equ 25

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

            SYSCALL_WRITE 1, alt_screen_on, alt_screen_on_len
            ret

    terminalRestore:
        SYSCALL_WRITE 1, alt_screen_off, alt_screen_off_len
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

    flushScreen:
        call terminalClear
        SYSCALL_WRITE 1, screen_buffer, 2000
        ret

    ; rdi = index
    ; al = char
    putChar:
        mov [rel screen_buffer + rdi], al
        ret

    ; rdi = index
    ; rsi = string
    putString:
        .loop:
            mov al, [rsi]
            test al, al
            jz .done

            call putChar
            inc rsi
            inc rdi
            jmp .loop
        .done:
            ret

    ; rdi = screen x
    ; rsi = screen y
    ; al  = char
    putCharXY:
        mov r8, rsi
        imul r8, SCREEN_W
        add r8, rdi

        mov rdi, r8
        call putChar
        ret