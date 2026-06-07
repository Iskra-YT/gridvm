[BITS 64]

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

    itoa2:
        mov rax, rsi

        xor rdx, rdx
        mov rcx, 10
        div rcx

        add al, '0'
        mov [rdi], al

        mov rax, rdx
        add al, '0'
        mov [rdi+1], al

        mov rax, rdi
        ret