bits 64
default rel

global printChar

extern GetStdHandle
extern WriteFile

; my functions
extern GetCstrLength
extern IntToAscii

section .bss
    char_buf resb 1 ; reserve a buffer for the single char as windows WriteFile needs a ptr

section .text

; printChar =================
;
; Writes a char to stdout
;
; 4294967295 characters or less please.
;
; args:
; al - must contain the character to be written.

printChar:
    ; Shadow space + stack alignment for Win64 calls
    sub rsp, 64

    ; args
    lea r10, [char_buf] ; cant move mem to mem, so i have to load the addr into a register
    mov [r10], al 
    mov qword [rsp + 56], r10 ; buffer = prt to char_buf
    mov dword [rsp + 48], 1 ; length = 1

    ; HANDLE GetStdHandle(DWORD nStdHandle = -11)
    ; Returns in RAX
    mov ecx, -11
    call GetStdHandle

    ; BOOL WriteFile(HANDLE, LPCVOID, DWORD, LPDWORD, LPOVERLAPPED)
    ; rcx = handle
    ; rdx = buffer
    ; r8d = length (DWORD)
    ; r9  = &writte
    ; dword rsp+32 = number of bytes written
    ; qword lpOverlapped = Null
    mov rcx, rax
    mov rdx, qword [rsp + 56]
    mov r8d, dword [rsp + 48]
    lea r9, [rsp + 40]
    mov qword [rsp + 32], 0
    mov dword [rsp + 40], 0
    call WriteFile

    ; test result written to EAX != 0
    test eax, eax
    jz .fail

    ; set EAX (return value) to the number of bytes written
    mov eax, dword [rsp + 40]
    ; restore stack pointer
    add rsp, 64
    ret

.fail:
    ; bytes written = 0
    xor eax, eax
    ; restore stack pointer
    add rsp, 64
    ret
