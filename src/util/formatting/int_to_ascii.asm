bits 64
default rel

global IntToAscii

section .bss
    ; 21 bytes is the max for a 64 bit signed int with a null terminator
    string_buf resb 24 ; 24 bytes for 8byte alignment

section .text
; IntToAscii 
; ==================
; Takes a signed int from RAX and returns a pointer to a cstr
; in RAX.
; 
; args:
; rax - the int to turn into a cstr
;
; ret:
; rax - ptr to the cstr
IntToAscii:
    push rbx 

    lea r10, [string_buf + 23] ; get address to the end of the string
    mov [r10], 0 ; Null terminator
    mov rbx, 10 ; divisor - i could actually make this into an argument so the function can turn abitrary-base numbers into ascii.

    cmp rax, 0
    jg .check_zero ; rax > 0
    neg rax ; make it positive for conversion.
    mov r11, 0 ; using this as a flag, 0 = negative
    jmp .convert_loop

    .check_zero:
        mov r11, 1 ; using this as a flag, 1 = positive
        test rax,rax
        jnz .convert_loop ; positive and not 0

        ; rax = 0 
        dec r10
        mov byte [r10], '0'
        jmp .done 

    .convert_loop:
        xor rdx,rdx ; at this point, inputs are positive
        div rbx ; rdx = remainder
        add dl, '0' ; move the base char into dl
        dec r10 ; work backwards in the string
        mov [r10], dl
        
        test rax,rax
        jnz .convert_loop ; if not 0, keep going.

        test r11,r11 
        jnz .done ; if number != negative
        dec r10
        mov byte [r10], '-' ; if negative, put "-" befor ethe number.

    .done:
        mov rax, r10 ; addr of beginning of cstr
        pop rbx
        ret