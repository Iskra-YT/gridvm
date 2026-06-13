%include "tui.h.asm"
%include "cell.h.asm"
%include "terminal.h.asm"

section .text
    drawGrid:
        push r12
        push r13
        push r14
        push r15

        xor r13, r13 ; row

        .rowLoop:
            cmp r13, VIEW_H
            jge .done

            xor r12, r12 ; col

        .colLoop:
            cmp r12, VIEW_W
            jge .nextRow

            mov rax, CELL_W
            imul rax, r12
            mov r14, rax ; screen x

            mov rax, 2
            imul rax, r13
            mov r15, rax ; screen y

            mov rdi, r14
            mov rsi, r15
            mov al, '|'
            call putCharXY

            mov rdi, r12
            mov rsi, r13
            call getCell

            test rax, rax
            jz .empty

            ; rax is string pointer
            mov rsi, rax
            
            ; calculate screen index: screen_y * SCREEN_W + screen_x + 1
            mov rdi, r15
            imul rdi, SCREEN_W
            add rdi, r14
            inc rdi

            call putString

        .empty:
            inc r12
            jmp .colLoop

        .nextRow:
            inc r13
            jmp .rowLoop

        .done:
            pop r15
            pop r14
            pop r13
            pop r12
            ret