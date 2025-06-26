section .data; program data initialization: strings and parameters 
    welcome_msg db "Welcome to the ICS assignment program of the group 15", 10; 10 - ASCII for \n - moves the cursor to the next line when printing 
    welcome_len equ $ - welcome_msg; equ - defines a constant value, $ - current address in memory
    ; user prompts
    prompt db "Choose a shape:", 10
           db "1 - Line (MD ABIR HOSSAIN SHIAM)", 10
           db "2 - Rectangle (MUNASHE ALFRED DEVE)", 10
           db "3 - Circle (GUBAEVA LILIIA)", 10
           db "4 - Oval (GILANG SUHERLAMBANG)", 10
           db "5 - Triangle (SALMAN FARSI NUDRAAT)", 10
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
    
    ; SHAPE PARAMETERS
    ; circle parameters
    circle_radius equ 15
    circle_y_scale equ 5       ; terminal character compensation
 
    
    ; LINE PARAMETERS 
    line_length equ 40      ;length 
    line_indent equ 5       ; umof spaces before line starts
    line_style db '-'   
    line_style_len equ 1    
    
    ; oval parameters
    oval_width equ 16       ; horizontal "radius" (half width)
    oval_height equ 8  ; vertical "radius" (half height)
    
    ; Triangle parameters 
    triangle_height equ 10      ; height of triangle
    triangle_base equ 19        ; base width 
    
    ; Rectangle parameters
    rectangle_height equ 6     ; total rows (including top & bottom)
    rectangle_width  equ 20    ; total columns (including sides)
    plus_char   db '+'
    dash_char   db '-'
    pipe_char   db '|'
    newline     db 10


section .bss; declares initialized variables, reserves space in memory 
    input_buffer resb 2; program reserves 2 bytes (allows reading 1 character + 1 \n) for input

section .text; main instructions set
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

    ; read input
    mov eax, 3; sys_read
    mov ebx, 0; stdin
    mov ecx, input_buffer; buffer wher einput is stored
    mov edx, 2; read up to 2 bytes
    int 0x80; syscall 
    
    ; validating input: first charavter (must be 1-6)
    mov al, [input_buffer]; loads first character 
    cmp al, '1'; compare with 1 
    jb invalid_input; if below 1 - jumb to invalid_input
    cmp al, '6'; compare with 6
    ja invalid_input; if above 6 - jump to invalid_input
    
    ; checking whether second character is \n or null
    mov al, [input_buffer+1]; second character
    cmp al, 10; compare with \n
    je process_valid_input; valid if \n
    cmp al, 0;compare with null
    je process_valid_input; if null then valid
    
    ; other inputs are not allowed 
    jmp invalid_input
    
process_valid_input:
    ; Check input
    mov al, [input_buffer]; 1st character 
    cmp al, '1'; compare with 1
    je draw_line; proceed to draw_line if 1 
    cmp al, '2'; compare with 2
    je draw_rectangle; proceed to draw_rectangle if 2
    cmp al, '3'; compare with 3
    je draw_circle; proceed to draw_rectangle if 3
    cmp al, '4'; compare with 4
    je draw_oval; proceed to draw_oval if 4
    cmp al, '5'; compare with 5
    je draw_triangle; proceed to draw_triangle if 5
    cmp al, '6'; compare with 6
    je program_done; proceed to program_done if 6
    
    ; in case of any other inputs, proceed to invalid_input
    jmp invalid_input
    
invalid_input:
    ; printing error message
    mov eax, 4; write 
    mov ebx, 1; stdout 
    mov ecx, invalid_msg; load adress 
    mov edx, invalid_len; load length
    int 0x80; call kernel
    call flush_input     ; discard remaining user input to ensure clean input buffer for next read
    jmp main_loop; re-display main menu after invalid input

flush_input:
    ; read and discard characters until newline (0x0A)
.flush_loop: ;local labels
    mov eax, 3; syscall read
    mov ebx, 0; stdin
    mov ecx, input_buffer; loads address of input_buffer
    mov edx, 1; read 1 byte
    int 0x80; executes the read syscall, reading a single character into input_buffer.
    cmp byte [input_buffer], 0x0A; compares the byte in input_buffer with 0x0A
    jne .flush_loop;  jump if not equal, keep looping until newline
    ret; return from procedure, returns to the caller (invalid_input) once the newline is found


draw_line:
    ; === Draw indentation ===
    mov ecx, line_indent    
    cmp ecx, 0              
    jle draw_line_main      ; Skip if no indentation needed

draw_spaces:
    push ecx                ; save counter
    mov eax, 4              
    mov ebx, 1              
    mov ecx, space_char     
    mov edx, 1          
    int 0x80                
    pop ecx                 ; restore counter
    loop draw_spaces        ; loop until indentation is done

draw_line_main:
    ; === Draw the actual line ===
    mov ecx, line_length    
draw_line_loop:
    push ecx                ; save counter
    mov eax, 4             
    mov ebx, 1             
    mov ecx, line_style     
    mov edx, line_style_len 
    int 0x80                
    pop ecx                 ; restore counter
    loop draw_line_loop     ; loop until line is complete

    call print_newline      ; next line
    jmp main_loop          ; return to menu

draw_rectangle:
    mov ecx, 0              ; Initialize row counter to 0

rectangle_loop:
    push ecx                ; Save current row counter

    ; Check if first or last row (border rows)
    cmp ecx, 0
    je draw_border_row
    mov eax, rectangle_height
    dec eax
    cmp ecx, eax
    je draw_border_row

    ; ===== Draw middle row =====
    ; Print left border
    mov eax, 4
    mov ebx, 1
    mov ecx, pipe_char
    mov edx, 1
    int 0x80

    ; Print spaces (width - 2)
    mov esi, rectangle_width
    sub esi, 2              ; Subtract 2 for the borders
.draw_space:
    push esi                ; Save space counter
    mov eax, 4
    mov ebx, 1
    mov ecx, space_char
    mov edx, 1
    int 0x80
    pop esi                 ; Restore space counter
    dec esi
    jnz .draw_space

    ; Print right border
    mov eax, 4
    mov ebx, 1
    mov ecx, pipe_char
    mov edx, 1
    int 0x80

    jmp next_row            ; Skip border drawing

draw_border_row:
    ; ===== Draw top/bottom border row =====
    ; Print left corner
    mov eax, 4
    mov ebx, 1
    mov ecx, plus_char
    mov edx, 1
    int 0x80

    ; Print dashes (width - 2)
    mov esi, rectangle_width
    sub esi, 2
.draw_dash:
    push esi
    mov eax, 4
    mov ebx, 1
    mov ecx, dash_char
    mov edx, 1
    int 0x80
    pop esi
    dec esi
    jnz .draw_dash

    ; Print right corner
    mov eax, 4
    mov ebx, 1
    mov ecx, plus_char
    mov edx, 1
    int 0x80

next_row:
    ; Print newline after each row
    call print_newline

    ; Move to next row
    pop ecx                 ; Restore row counter
    inc ecx                 ; Increment row counter
    cmp ecx, rectangle_height
    jl rectangle_loop       ; Continue if more rows to draw

    jmp main_loop           ; Return to main menu

draw_circle:
; circle equation: x² + (y² * scaling) ≤ r² - r
; scaling compensates for terminal characters being taller than they are wide
    mov ecx, circle_radius; radius constant 
    neg ecx; start from -radius
    
circle_y_loop:
    push ecx; save y coordinate
    mov ecx, circle_radius
    neg ecx; start x from -radius
    ; mov ecx, circle_radius + neg ecx: resets x to -radius (to scan each row from left to right)
    
circle_x_loop:
    push ecx; save x coordinate
    
    mov eax, ecx; x
    imul eax, eax; x²
    
    mov ebx, [esp+4]; y
    imul ebx, ebx; y²
    imul ebx, circle_y_scale; y² * scaling factor
    
    add eax, ebx; x² + (scaled y²)
    
    ; calculate adjusted radius 
    mov ebx, circle_radius
    imul ebx, ebx; r²
    sub ebx, circle_radius; adjustment for better shape (r² - r)
    
    cmp eax, ebx;  ; compare x² + (scaled y²) with r² - r
    jg circle_space; if >,then point is outside (print space)
    
    ; pixel draw (*)
    mov eax, 4
    mov ebx, 1
    mov ecx, fill_char
    mov edx, 1
    int 0x80
    jmp circle_next; skip printing space
    
; outside circle space 
circle_space:
    mov eax, 4
    mov ebx, 1
    mov ecx, space_char
    mov edx, 1; print 1 character 
    int 0x80
; move to x coordinate
circle_next:
    pop ecx; restore x from the stack
    inc ecx; x++ - move to the next column 
    cmp ecx, circle_radius
    jle circle_x_loop; loop untill x > radius 
    
; move to your coordinate (newline)
    call print_newline; move to the next line 
    pop ecx; restore y coordinate from the stack
    inc ecx; y++ - move the next row
    cmp ecx, circle_radius
    jle circle_y_loop; loop until y > radius
   
   ; return to the main menu after drawing  
    jmp main_loop
    
draw_oval:
    ; Set y = -oval_height
    mov ecx, oval_height
    neg ecx           ; y = -oval_height

oval_y_loop:
    push ecx          ; save y on stack for later use

    mov ecx, oval_width
    neg ecx           ; x = -oval_width

oval_x_loop:
    push ecx          ; save x

    ; Calculate (x / oval_width)^2 + (y / oval_height)^2 <= 1
    ; To avoid floating point, use scaled integer math:
    ; left = (x^2 * oval_height^2) + (y^2 * oval_width^2)
    ; right = (oval_width^2) * (oval_height^2)

    mov eax, [esp]    ; x
    imul eax, eax     ; x^2

    mov ebx, oval_height
    imul ebx, oval_height  ; oval_height^2

    imul eax, ebx     ; x^2 * oval_height^2

    mov edx, [esp+4]  ; y (saved y, from previous push)
    imul edx, edx     ; y^2

    mov ebx, oval_width
    imul ebx, oval_width   ; oval_width^2

    imul edx, ebx     ; y^2 * oval_width^2

    add eax, edx      ; sum of two terms

    ; Calculate right side = (oval_width^2)*(oval_height^2)
    mov ebx, oval_width
    imul ebx, oval_width       ; oval_width^2
    mov edx, oval_height
    imul edx, oval_height      ; oval_height^2
    imul ebx, edx              ; (oval_width^2)*(oval_height^2)

    cmp eax, ebx
    jg oval_print_space        ; if left > right, outside oval, print space

oval_print_char:
    mov eax, 4
    mov ebx, 1
    mov ecx, fill_char
    mov edx, 1
    int 0x80
    jmp oval_next_x

oval_print_space:
    mov eax, 4
    mov ebx, 1
    mov ecx, space_char
    mov edx, 1
    int 0x80

oval_next_x:
    pop ecx          ; restore x
    inc ecx          ; x++
    cmp ecx, oval_width
    jle oval_x_loop  ; loop x until x > oval_width

    ; print newline
    call print_newline

    pop ecx          ; restore y
    inc ecx          ; y++
    cmp ecx, oval_height
    jle oval_y_loop  ; loop y until y > oval_height

    jmp main_loop    ; back to menu
    
; Triangle drawing implementation 
draw_triangle:
    ; Draw triangle row by row from top to bottom
    mov ecx, 0              ; row counter (starting from 0)
    
triangle_row_loop:
    push ecx                ; save row counter
    
    ; Calculate number of spaces for centering
    ; spaces = (triangle_base - (2*row + 1)) / 2
    mov eax, triangle_base  ; load base width
    mov ebx, ecx            ; current row
    shl ebx, 1              ; multiply row by 2 (2*row)
    inc ebx                 ; add 1 (2*row + 1)
    sub eax, ebx            ; triangle_base - (2*row + 1)
    shr eax, 1              ; divide by 2 for centering
    
    ; Draw leading spaces
    mov edx, eax            ; number of spaces to draw
    cmp edx, 0
    jle triangle_draw_stars ; if no spaces needed, go to stars

triangle_spaces_loop:
    push edx                ; save space counter
    mov eax, 4
    mov ebx, 1
    mov ecx, space_char
    mov edx, 1
    int 0x80
    pop edx                 ; restore space counter
    dec edx
    jnz triangle_spaces_loop

triangle_draw_stars:
    ; Calculate number of stars for this row: 2*row + 1
    mov eax, [esp]          ; get current row from stack
    shl eax, 1              ; multiply by 2
    inc eax                 ; add 1
    mov edx, eax            ; number of stars to draw

triangle_stars_loop:
    push edx                ; save star counter
    mov eax, 4
    mov ebx, 1
    mov ecx, fill_char      ; use '*' character
    mov edx, 1
    int 0x80
    pop edx                 ; restore star counter
    dec edx
    jnz triangle_stars_loop

    ; Move to next line
    call print_newline
    
    ; Check if we've drawn all rows
    pop ecx                 ; restore row counter
    inc ecx                 ; next row
    cmp ecx, triangle_height
    jl triangle_row_loop    ; continue if more rows to draw
    
    jmp main_loop           ; return to main menu
 
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
