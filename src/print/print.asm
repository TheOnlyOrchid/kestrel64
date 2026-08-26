bits 64
default rel

global prINT

extern GetStdHandle
extern WriteFile

; my functions
extern GetCstrLength
extern IntToAscii

section .text

; prINT =================
;
; Writes an int to stdout
;
; args:
; rax - the INT to prINT!
prINT:
    ; Shadow space + stack alignment for Win64 calls
    sub rsp, 64

    ; turn int into cstr
    call IntToAscii ; rax = ptr to cstr
    mov qword [rsp + 56], rax

    ; get length of cstr
    mov rcx, rax ; rcx = arg1
    call GetCstrLength
    mov dword [rsp + 48], eax

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
