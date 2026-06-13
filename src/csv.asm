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
        push r12
        push r13

        sub rsp, 32 ; Adjusted stack for saved registers

        SYSCALL_OPEN rdi, O_RDONLY, 0
        mov [rbp-24], rax ; Adjusted offset due to extra pushes
        test rax, rax
        js .error

        mov rdi, rax
        lea rsi, [rel buffer]
        SYSCALL_READ rdi, rsi, 65535
        mov [rbp-32], rax

        SYSCALL_CLOSE [rbp-24]

        xor r12, r12
        xor r13, r13
        mov qword [rbp-40], 0 ; col
        mov qword [rbp-48], 0 ; row

        .loop:
            mov rdx, [rbp-32]
            cmp r12, rdx
            jae .flush_eof
        
            mov al, [rel buffer + r12]
        
            cmp al, ';'
            je .cell
        
            cmp al, 10
            je .newline
        
            inc r12
            jmp .loop
        
        .cell:
            mov byte [rel buffer + r12], 0
        
            lea rdx, [rel buffer]
            add rdx, r13
        
            mov rdi, [rbp-40]
            mov rsi, [rbp-48]
            call setCell
        
            inc qword [rbp-40]
            mov r13, r12
            inc r13
        
            inc r12
            jmp .loop
        
        .newline:
            mov byte [rel buffer + r12], 0
        
            lea rdx, [rel buffer]
            add rdx, r13
        
            mov rdi, [rbp-40]
            mov rsi, [rbp-48]
            call setCell
        
            mov qword [rbp-40], 0
            inc qword [rbp-48]
        
            mov r13, r12
            inc r13
        
            inc r12
            jmp .loop
        
        .flush_eof:
            cmp r13, r12
            jae .done
        
            mov byte [rel buffer + r12], 0
        
            lea rdx, [rel buffer]
            add rdx, r13
        
            mov rdi, [rbp-40]
            mov rsi, [rbp-48]
            call setCell
        
        .done:
            mov rax, 0
            add rsp, 32
            pop r13
            pop r12
            leave
            ret
        
        .error:
            mov rax, 1
            add rsp, 32
            pop r13
            pop r12
            leave
            ret