section .data; - data declaration to store in memory 
    msg db 'Hello World!', 0xA; msg (var) db (define byte - sequence of bytes) '' 
    ; (str) 0xA = \n
    len equ $ - msg; len=num of bytes in the str (const) equ (define const) $ - cur. mem. address 
    ; $ - msg = len of msg (cur address minus msg address)
section .text; programm instrustions section 
    global _start; linker for the entry point - 1st instruction to execute when program starts 
_start:; entry point 
    mov eax, 4; eax - sys call number, 4 - sys call num for 'write'
    mov ebx, 1; ebx - file descriptor, 1 - stansart output=stdout
    mov ecx, msg; ecx - pointer to the msg to print 
    mov edx, len ; edx - num of bytes to write 
    int 0x80
    
    mov eax, 1; 1 = sys call for exit 
    xor ebx, ebx; - exit code, xor ebx, ebx - set ebx to 0
    int 0x80; interrupt for system call => write message 
; https://www.jdoodle.com/compile-assembler-nasm-online
