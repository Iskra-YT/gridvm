%ifndef GRIDVM_SYSCALLS_ASM
%define GRIDVM_SYSCALLS_ASM

%macro SYSCALL_WRITE 3 ; write(fd, buf, buflen)
    mov rax, 1
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    syscall
%endmacro

%macro SYSCALL_EXIT 1 ; exit(code)
    mov rax, 60
    mov rdi, %1
    syscall
%endmacro 

%endif ; GRIDVM_SYSCALLS_ASM