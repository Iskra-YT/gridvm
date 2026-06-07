%ifndef GRIDVM_FILE_ASM
%define GRIDVM_FILE_ASM

%define O_RDONLY 0
%define O_WRONLY 1
%define O_RDWR 2

%define O_CREAT 0x40
%define O_TRUNC 0x200
%define O_APPEND 0x400

%define S_IRUSR   0400
%define S_IWUSR   0200

%define S_IRGRP   0040
%define S_IROTH   0004

%define DEFAULT_MODE S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH

%endif ; GRIDVM_FILE_ASM