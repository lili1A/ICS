section .data; read-only data initialization 
    prompt db "Choose a shape: 1 - Circle, 2 - Square", 10
    prompt_len equ $ - prompt; equ calculates the length of 'prompt'

    newline db 10; 10 - ASCII value foe \n

    ; lines for circle
    circle1     db "   ***   ", 10
    circle2     db " *     * ", 10
    circle3     db "*       *", 10
    circle4     db "*       *", 10
    circle5     db " *     * ", 10
    circle6     db "   ***   ", 10

    ; lines for square 
    square1     db "*********", 10
    square2     db "*       *", 10
    square3     db "*       *", 10
    square4     db "*       *", 10
    square5     db "*********", 10

    finish_msg  db "Program is finished!"
    finish_len  equ $ - finish_msg

section .bss; block starting symbol - section for uninitialized global&static variables in memory 
    input_buffer resb 100; 100 bytes are reserved for user input - made for loop debugging 

section .text; program logic 
    global _start; program entry point 

_start:
; print user promt message 
prompt_user:
    mov eax, 4; syscall for write
    mov ebx, 1; file descriptor stdout 
    mov ecx, prompt; msg address 
    mov edx, prompt_len
    int 0x80; execute

    ; read up to 100 bytes from prompt_user
    mov eax, 3; syscall read 
    mov ebx, 0; file descriptor stdin
    mov ecx, input_buffer; where input is stored 
    mov edx, 100; max bytes num to read from input 
    int 0x80

    ; check the first character only
    mov al, [input_buffer]; load first char only from input 
    cmp al, '1'; if 1 
    je draw_circle; then jump to draw_circle
    cmp al, '2'; if 2
    je draw_square; then jump to draw_square

    ; invalid input => prompt again (1 iteration only)
    jmp prompt_user

; circle function
draw_circle:
    mov ecx, circle1
    call print_line
    mov ecx, circle2
    call print_line
    mov ecx, circle3
    call print_line
    mov ecx, circle4
    call print_line
    mov ecx, circle5
    call print_line
    mov ecx, circle6
    call print_line
    jmp program_done
    
; square function
draw_square:
    mov ecx, square1
    call print_line
    mov ecx, square2
    call print_line
    mov ecx, square3
    call print_line
    mov ecx, square4
    call print_line
    mov ecx, square5
    call print_line
    jmp program_done

; print lines 
print_line:
    mov eax, 4
    mov ebx, 1
    mov edx, 10   ; each line is 9 chars + newline
    int 0x80
    ret
    
; program finish message 
program_done:
    mov eax, 4
    mov ebx, 1
    mov ecx, finish_msg
    mov edx, finish_len
    int 0x80

; exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80
