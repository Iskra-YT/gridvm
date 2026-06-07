%ifndef GRIDVM_TERMINAL_ASM
%define GRIDVM_TERMINAL_ASM

%define TCGETS 0x5401
%define TCSETS 0x5402

%define ICANON 0x2
%define ECHO 0x8
%define ISIG 0x1
%define ECHOE 0x10
%define IEXTEN 0x100000

%define IXON 0x2000
%define ICRNL 0x400
%define BRKINT 0x100
%define INPCK 0x2
%define ISTRIP 0x40

section .text
    extern terminalInit
    extern terminalRestore

    extern terminalClear
    extern terminalCursorSet

%endif ; GRIDVM_TERMINAL_ASM