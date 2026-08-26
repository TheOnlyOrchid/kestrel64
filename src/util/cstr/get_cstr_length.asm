bits 64
default rel

global GetCstrLength

section .bss

section .text
; GetCstrLength
; ======================
; Gets the length of a Cstr
;
; args:
; rcx - ptr to a cstr
;
; ret:
; rax - the length of the cstr
GetCstrLength:
    xor rax,rax ; counter = 0

    .loop:
        cmp byte [rcx + rax], 0
        je .done ; if null byte, return
        inc rax ; counter++
        jmp .loop

    .done:
        ret