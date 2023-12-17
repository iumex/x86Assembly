bits 64

extern ExitProcess
extern InitWindow
extern BeginDrawing
extern ClearBackground
extern EndDrawing
extern DrawText
extern WindowShouldClose
extern SetTargetFPS
extern DrawRectangle
extern IsKeyDown
extern IsKeyPressed


start:
    sub rsp, 8

    ; Initialization of the window
    sub rsp, 32
    mov rcx, 1024
    mov rdx, 768
    mov r8, wintitle
    call [InitWindow]
    add rsp, 32

    ; Set the FPS of the window
    sub rsp, 32
    mov rcx, 60
    call [SetTargetFPS]
    add rsp, 32

jmp gameloop


init:
    ; Initialization of the position of the rect
    mov r10d, [recty]
    mov r11d, [rectx]

    ; x_Offset of the rect fire
    add r11d, 20

    ; Initialization of the position of the rect fire
    mov dword [firey], r10d
    mov dword [firex], r11d

gameloop:
    
    sub rsp, 32
    call [WindowShouldClose]
    cmp rax, 0
    jnz end
    add rsp, 32

    ; Implementation of the rect fire pressing key_space
    sub rsp, 32
    mov rcx, [key_space]
    call [IsKeyPressed]    
    cmp rax, 0
    jnz drawfire
    add rsp, 32
    
    ; Implementation of the input according to different directions
    sub rsp, 32
    mov rcx, [key_right]        
    call [IsKeyDown]
    cmp rax, 0
    jnz moveright
    add rsp, 32

    sub rsp, 32
    mov rcx, [key_left]        
    call [IsKeyDown]
    cmp rax, 0
    jnz moveleft
    add rsp, 32

    sub rsp, 32
    mov rcx, [key_up]        
    call [IsKeyDown]
    cmp rax, 0
    jnz moveup
    add rsp, 32

    sub rsp, 32
    mov rcx, [key_down]        
    call [IsKeyDown]
    cmp rax, 0
    jnz movedown
    add rsp, 32

    ; Stop moving if the key is released
    sub rsp, 32
    mov rcx, 0        
    call [IsKeyDown]
    cmp rax, 0
    je stop
    add rsp, 32




    ; Implementation of the movement
    moveright:
        add dword [rectx], 4
        jmp continue

    moveleft:
        sub dword [rectx], 4
        jmp continue

    moveup:
        sub dword [recty], 4
        jmp continue

    movedown:
        add dword [recty], 4
        jmp continue


    
    ; When the key is released, the rect stops moving
    stop:
        add dword [rectx], 0
        add dword [recty], 0



    continue:



    sub rsp, 32
    call [BeginDrawing]
    add rsp, 32

    sub rsp, 32
    mov rcx, 0xFF00FFFF    
    call [ClearBackground]
    add rsp, 32

    ; parameter of the function DrawRectangle for the rect
    mov rcx, [rectx]   
    mov rdx, [recty]

    mov r8, 60
    mov r9, 60
    
    ; fifth parameter: color
    sub rsp, 8
    mov rax, 0xFF0000FF
    push rax
    sub rsp, 32
    call [DrawRectangle]
    add rsp, 32
    add rsp, 8
    pop rax


    ; Movement of the rect fire
    sub dword [firey], 8
    cmp dword [firey], 0
    jg drawfire


    jmp enddraw


    drawfire:    
    cmp dword [firey], 0
    jl init
 
    ; parameter of the function DrawRectangle for the rect fire
    mov rcx, [firex]
    mov rdx, [firey]
    mov r8, 20
    mov r9, 20


    ; fifth parameter: color
    sub rsp, 8
    mov rax, 0xFFFF00FF
    push rax
    sub rsp, 32
    call [DrawRectangle]
    add rsp, 32
    add rsp, 8
    pop rax



    enddraw:



    sub rsp, 32
    call[EndDrawing]
    add rsp, 32
    jmp gameloop



end:
sub rcx, 32
mov rcx, 100
call [ExitProcess]
add rsp, 32

add rsp, 8

ret

section .data

wintitle:
db "RectFireTest", 0



rectx:
dq 0

recty:
dq 0

firex:
dq 0

firey:
dq 0


key_right:
dq 68

key_left:
dq 65

key_up:
dq 87

key_down:
dq 83

key_space:
dq 32