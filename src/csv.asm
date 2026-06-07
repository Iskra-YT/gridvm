[BITS 64]

%include "csv.h.asm"
%include "syscalls.h.asm"
%include "file.h.asm"
%include "cell.h.asm"

section .bss
    buffer: resb 65535

section .text
    parseFile:
        push rbp
        mov rbp, rsp

        sub rsp, 48

        SYSCALL_OPEN rdi, O_RDONLY, 0
        mov [rbp-8], rax
        test rax, rax
        js .error

        mov rdi, rax
        lea rsi, [rel buffer]
        SYSCALL_READ rdi, rsi, 65535
        mov [rbp-16], rax

        SYSCALL_CLOSE [rbp-8]

        xor rcx, rcx
        xor r11, r11
        mov qword [rbp-24], 0
        mov qword [rbp-32], 0

        .loop:
            mov rdx, [rbp-16]
            cmp rcx, rdx
            jae .flush_eof
        
            mov al, [rel buffer + rcx]
        
            cmp al, ';'
            je .cell
        
            cmp al, 10
            je .newline
        
            inc rcx
            jmp .loop
        
        .cell:
            mov byte [rel buffer + rcx], 0
        
            lea rdx, [rel buffer]
            add rdx, r11
        
            mov rdi, [rbp-24]
            mov rsi, [rbp-32]
            call setCell
        
            inc qword [rbp-24]
            mov r11, rcx
            inc r11
        
            inc rcx
            jmp .loop
        
        .newline:
            mov byte [rel buffer + rcx], 0
        
            lea rdx, [rel buffer]
            add rdx, r11
        
            mov rdi, [rbp-24]
            mov rsi, [rbp-32]
            call setCell
        
            mov qword [rbp-24], 0
            inc qword [rbp-32]
        
            mov r11, rcx
            inc r11
        
            inc rcx
            jmp .loop
        
        .flush_eof:
            cmp r11, rcx
            jae .done
        
            mov byte [rel buffer + rcx], 0
        
            lea rdx, [rel buffer]
            add rdx, r11
        
            mov rdi, [rbp-24]
            mov rsi, [rbp-32]
            call setCell
        
        .done:
            mov rax, 0
            leave
            ret
        
        .error:
            mov rax, 1
            leave
            ret