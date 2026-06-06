%include "string.h.asm"

section .text
    ; rdi = str*
    strlen:
        xor rax, rax

        .loop:
            cmp byte [rdi + rax], 0
            je .done

            inc rax
            jmp .loop

        .done:
            ret