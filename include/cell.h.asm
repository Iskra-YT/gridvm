%ifndef GRIDVM_CELL_ASM
%define GRIDVM_CELL_ASM

section .bss
    extern grid

%define MAX_X 5
%define MAX_Y 7

section .text
    extern setCell
    extern getCell

%endif ; GRIDVM_CELL_ASM