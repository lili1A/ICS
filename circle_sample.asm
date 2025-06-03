section .data; static data initialization, define byte 
    line1 db "   ***   ", 10; \n - 10 - newline ASCII value 
    line2 db " *     * ", 10
    line3 db "*       *", 10
    line4 db "*       *", 10
    line5 db " *     * ", 10
    line6 db "   ***   ", 10

section .text; code section definition 
    global _start; entry point for the program 

_start:
    ; each line consists in 9 characters + 1 newline => 10 bytes

    ; print line 1
    mov eax, 4; syscall write
    mov ebx, 1; stdout - file descriptor 
    mov ecx, line1; string address 
    mov edx, 10; num of bytes to write 
    int 0x80; call for kernel to exit 

    ; print line 2
    mov eax, 4
    mov ebx, 1
    mov ecx, line2
    mov edx, 10
    int 0x80

    ; print line 3
    mov eax, 4
    mov ebx, 1
    mov ecx, line3
    mov edx, 10
    int 0x80

    ; print line 4
    mov eax, 4
    mov ebx, 1
    mov ecx, line4
    mov edx, 10
    int 0x80

    ; print line 5
    mov eax, 4
    mov ebx, 1
    mov ecx, line5
    mov edx, 10
    int 0x80

    ; print line 6
    mov eax, 4
    mov ebx, 1
    mov ecx, line6
    mov edx, 10
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
