; src/main.asm
; Minimal Windows x64 entry using prINT.

bits 64
default rel

global main

extern prINT
extern printCstr
extern printChar
extern printNewline

section .rdata
    hello_cstr db "Hello World", 0
    example_int dq -9356
    example_char db '@'

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
    
    call printNewline
    call printNewline

    mov al, [example_char]
    call printChar

    call printNewline
    call printNewline

    ; print_cstr
    mov rcx, hello_cstr
    call printCstr

    xor eax, eax
    xor eax, ebx
    add rsp, 40
    ret
