bits 64
default rel

global printNewline

extern GetStdHandle
extern WriteFile

; my functions
extern GetCstrLength
extern IntToAscii

section .data
    newline db 0x0D, 0x0A ; \r\n

section .text

; printNewline =================
;
; Writes a char to stdout
;
; 4294967295 characters or less please.
;
; args:
; None.
;
; Returns bytes written in EAX.

printNewline:
    ; Shadow space + stack alignment for Win64 calls
    sub rsp, 64

    ; args
    lea r10, [newline] ; cant move mem to mem, so i have to load the addr into a register
    mov qword [rsp + 56], r10 ; buffer = prt to newline
    mov dword [rsp + 48], 2 ; length = 1

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
