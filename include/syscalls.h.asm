%ifndef GRIDVM_SYSCALLS_ASM
%define GRIDVM_SYSCALLS_ASM

%macro SYSCALL_READ 3 ; read(fd, buf, count)
    mov rax, 0
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    syscall
%endmacro

%macro SYSCALL_WRITE 3 ; write(fd, buf, count)
    mov rax, 1
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    syscall
%endmacro

%macro SYSCALL_OPEN 3 ; open(filename, flags, mode)
    mov rax, 2
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    syscall
%endmacro

%macro SYSCALL_CLOSE 1 ; close(fd)
    mov rax, 3
    mov rdi, %1
    syscall
%endmacro

%macro SYSCALL_MMAP 1 ; mmap(size)
    mov rax, 9
    xor rdi, rdi
    mov rsi, %1
    mov rdx, 3
    mov r10, 0x22
    mov r8, -1
    xor r9, r9
    syscall
%endmacro

%macro SYSCALL_IOCTL 3 ; ioctl(fd, cmd, arg)
    mov rax, 16
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