[BITS 64]

%include "cell.h.asm"

section .bss
    grid: resq MAX_X * MAX_Y

section .text
    ; rdi = x (bigint)
    ; rsi = y (bigint)
    ; rdx = value (str*)
    setCell:
        cmp rdi, MAX_X
        jae .done
        cmp rsi, MAX_Y
        jae .done

        imul rax, rsi, MAX_X
        add  rax, rdi

        lea rcx, [rel grid]
        mov [rcx + rax*8], rdx

    .done:
        ret

    ; rdi = x (bigint)
    ; rsi = y (bigint)
    getCell:
        cmp rdi, MAX_X
        jae .error
        cmp rsi, MAX_Y
        jae .error

        imul rax, rsi, MAX_X
        add rax, rdi

        lea rcx, [rel grid]
        mov rax, [rcx + rax*8]
        ret

    .error:
        xor rax, rax
        ret