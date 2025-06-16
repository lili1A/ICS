section .data; program data initialization 
    welcome_msg db "Welcome to the ICS assignment program of the group 15", 10; 10 - ASCII for \n - moves the cursor to the next line when printing 
    welcome_len equ $ - welcome_msg; equ - defines a constant value, $ - current address in memory
    ; user prompts
    prompt db "Choose a shape:", 10
           db "1 - Line", 10
           db "2 - Rectangle", 10
           db "3 - Circle (TP075586)", 10
           db "4 - Square", 10
           db "5 - Triangle", 10
           db "6 - Exit", 10
           db "Enter your choice (Program reads only 1st input character!): ", 0
    prompt_len equ $ - prompt

    invalid_msg db "Invalid input! Try again!", 10, 0
    invalid_len equ $ - invalid_msg

    finish_msg db "Program is finished!", 10, 0
    finish_len equ $ - finish_msg

    ; shape characters
    fill_char db 42; ASCII code for "*" - shape filling character 
    space_char db 32; ASCII code for space - spacing 

    ; circle parameters
    circle_radius equ 15; defines a circle's radius: 15 units 
    
    ; WRITE YOUR SHAPE PARAMETERS BELOW

section .bss; declares initialized variables, reserves space in memory 
    input_buffer resb 10; program reserves 10 bytes (characters) for input

section .text; main instructions sety 
    global _start; begin execution 

_start:
    ; welcome message print 
    mov eax, 4; syscall write 
    mov ebx, 1; file descriptor stdout - standart output 
    mov ecx, welcome_msg; data location pointer 
    mov edx, welcome_len; number of bytes to wrire 
    int 0x80; call kernel 
    
main_loop:
    ; main loop for prompt 
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80

    ; Read input
    mov eax, 3; syscall number to read 
    mov ebx, 0; stdin - standart input 
    mov ecx, input_buffer
    mov edx, 10; defines how many bytes to read (maximum)
    int 0x80

    ; Check input
    mov al, [input_buffer]; move only first character 
    cmp al, '1'; compare with 1
    je draw_line; if equal, jump to draw_line
    cmp al, '2'; compare with 1
    je draw_rectangle; compare with 2
    cmp al, '3'; compare with 3
    je draw_circle; if equal, jump to draw_circle
    cmp al, '4'; compare with 4
    je draw_square; if equal, jump to draw_square
    cmp al, '5'; compare with 5
    je draw_triangle; if equal, jump to draw_triangle
    cmp al, '6'; compare with 6
    je program_done; if equal, jump to draw_triangle
    

    ; invalid input
    mov eax, 4
    mov ebx, 1
    mov ecx, invalid_msg
    mov edx, invalid_len
    int 0x80
    jmp main_loop; jump back to the main loop in case of invalid input

draw_line:

draw_rectangle:

draw_circle:
    ; circle is drawn by initializing y coordinate (- rad to + rad)
    mov ecx, circle_radius; circle rad is loaded into ecx
    neg ecx; - radius (y), convert to negative, x starts here (left)
    
circle_y_loop:
; looping y coordinate
    push ecx; saving y coordinate
    mov ecx, circle_radius; ecx is reset for x coordinate 
    neg ecx
circle_x_loop:
    push ecx;  saving x coordinate
    
    ; circle equation: x² + y²
    mov eax, ecx; eax = x 
    imul eax, eax        ; eax = x²
    mov ebx, [esp+4]     ; y value, ebx = y from stack
    imul ebx, ebx        ; y²
    add eax, ebx         ; x² + y², sum of squares
    
    ; compare with adjusted r² 
    mov ebx, circle_radius
    imul ebx, ebx; ebx = r²
    sub ebx, circle_radius  ; adjusting ASCII 
    
    ; printinh circle
    cmp eax, ebx
    jg circle_space; if x²+y² > r², draw space
    
    ; draw circle pixel (inside circle)
    mov eax, 4
    mov ebx, 1
    mov ecx, fill_char; *
    mov edx, 1; length is 1
    int 0x80
    jmp circle_next
    
; draw outside the circle (" ")
circle_space:
    mov eax, 4
    mov ebx, 1
    mov ecx, space_char; (" ")
    mov edx, 1
    int 0x80
    
; controlling the loop   
circle_next:
    pop ecx; restore x coordinate
    inc ecx; x++
    cmp ecx, circle_radius
    jle circle_x_loop; continue until x > radius
    
    ; \n at the end of each row 
    call print_newline
    pop ecx; restoring y coordinate 
    inc ecx; y++
    cmp ecx, circle_radius
    jle circle_y_loop; continue until y > radius
    jmp program_done; exit drawing

draw_square:
    
draw_triangle:
 
print_newline:
    ; saving registers
    push eax
    push ebx
    push ecx
    push edx
    mov eax, 4
    mov ebx, 1
    mov ecx, newline; \n
    mov edx, 1; length 1
    int 0x80
    ; restoring registers 
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

program_done:
    ; finish message
    mov eax, 4
    mov ebx, 1
    mov ecx, finish_msg
    mov edx, finish_len
    int 0x80

    ; exit the program
    mov eax, 1; syscall exit 
    xor ebx, ebx; exit code 0
    int 0x80; call kernel

section .data
    newline db 10
