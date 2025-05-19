section .data
msg1 db 'Hello, World!', 0xA, 0        ; 1st string
len1 equ $ - msg1

msg2 db 'Welcome to NASM programming!', 0xA
len2 equ $ - msg2                      ; 2nd string

section .text
    global _start

_start:
; write 1st str to stdout
    mov eax, 4; sys_write
    mov ebx, 1; stdout
    mov ecx, msg1; mem add for msg1
    mov edx, len1; num of bytes for msg1 
    int 0x80; call kernel 
; write 2nd str to stdout
    mov eax, 4; sys_write call
    mov ebx, 1; stdout - file descriptor 1 
    mov ecx, msg2; memory address of the second string 
    mov edx, len2; num of bytes for msg2
    int 0x80; call kernel
; sys exit
    mov eax, 1; sys_exit
    xor ebx, ebx; return to code 0 
    int 0x80; call kernel 
