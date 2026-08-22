; src/main.asm
; Minimal Windows x64 entry using prINT.

bits 64
default rel

global main
extern prINT

section .rdata

section .text
main:
    sub rsp, 40
    mov rax, -9356
    call prINT
    xor eax, eax
    add rsp, 40
    ret
