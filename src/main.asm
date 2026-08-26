; src/main.asm
; Minimal Windows x64 entry using prINT.

bits 64
default rel

global main

extern prINT
extern printCstr

section .rdata
    hello_cstr db "Hello World", 0
    example_int dq -9356

; this file serves as a test for all "high level" functions in the lib
; what is a "high level" function?
;
; it roughly means a function that isnt created to be a dependency for other functions,
; essentially the equivalent to what would be a "public" function in typical libs.
section .text
main:
    sub rsp, 40

    ; prINT
    mov rax, [example_int]
    call prINT

    ; i wish to define a printChar and printNewLine in the future, i will place them here.

    ; print_cstr
    mov rcx, hello_cstr
    call printCstr

    xor eax, eax
    add rsp, 40
    ret
