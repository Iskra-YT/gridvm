[BITS 64]

%include "cell.h.asm"

section .bss
    grid: resq MAX_X * MAX_Y

section .text
    ; rdi = x (bigint)
    ; rsi = y (bigint)
    ; rdx = value (str*)
    setCell:
        lea rcx, [rel grid]

        imul rax, rsi, MAX_X
        add  rax, rdi

        mov [rcx + rax*8], rdx

        ret

    ; rdi = x (bigint)
    ; rsi = y (bigint)
    getCell:
        lea rcx, [rel grid]

        imul rax, rsi, MAX_X
        add rax, rdi

        mov rax, [rcx + rax*8]

        ret