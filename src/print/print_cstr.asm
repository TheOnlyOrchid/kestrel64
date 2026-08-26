bits 64
default rel

global printCstr

extern GetStdHandle
extern WriteFile

; my functions
extern GetCstrLength
extern IntToAscii

section .text

; printCstr =================
;
; Writes a cstr to stdout
;
; 4294967295 characters or less please.
;
; args:
; rcx - a pointer to the beginning of the cstr you want to print

printCstr:
    ; Shadow space + stack alignment for Win64 calls
    sub rsp, 64

    ; get Cstr to print
    ; rsp + 56 = ptr to cstr
    mov qword [rsp + 56], rcx

    ; get length of cstr
    call GetCstrLength ; takes rcx, returns rax
    mov dword [rsp + 48], eax ; we kind of just assume that its less than 4b characters, if it was more this wouldnt print the whole thing
    ; but i think thats a fine caveat

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
    ; clear EAX
    xor eax, eax
    ; restore stack pointer
    add rsp, 64
    ret
