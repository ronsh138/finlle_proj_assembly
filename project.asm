IDEAL
MODEL small
STACK 256h
DATASEG
bloopcountert dw 0000h
sloopcountert dw 0000h
countert dw 0000h

T_REX_x dw 29
T_REX_y dw 190
T_REX_x0 dw 29
T_REX_y0 dw 190
obstacle1_y dw 190
obstacle1_x dw 320
obstacle2_y dw 190
obstacle2_x dw 320
obstacle_y0 dw 190
obstacle_x0 dw 320
prev_time db 0h
bloopcounter dw 0000h
sloopcounter dw 0000h

compering db 0h
starting_text_and_keybindes db "Hello!, and welcome to the T-REX RUNNER(cursed edition).",10,10,"In this game you are a dinasour(T-REX) that runs in a field full of obstacles that you must avoid to survive.",10,10,"this game is suppose to simulate T-REX RUNNER so dont expect it to be the game, this game is suppose to help you learn how to avoid the obstacles and time your jump right",10,10,"to jump you simply press the space button.",10,10,10,"----to start please press space----$"
ending_text_and_keybindes db "You lost, nice try"
ending_text_and_keybindes2 db 10,10,"would you like to play again?, if you do please press space else press anything else$"
new_game1 db 0
lose db 0
skip_to_up_down db 0
up_down_count db 0
down db 0
up db 1
CODESEG
Clock  equ  40:6Ch

proc starting_message
	push ax
	push dx
	mov ah, 0
	mov al, 2
	int 10h
	mov ah, 9h
	mov dx,offset starting_text_and_keybindes
	int 21h
	pop ax
	pop dx
	ret
endp starting_message

proc key_detecting
	push ax
	mov ah, 00h
    int 16h
	mov [compering], al
	pop ax
	ret
endp key_detecting

proc key_pressed
	push ax
	mov ah, 01h
    int 16h
	pop ax
	ret
endp key_pressed

proc screen_set
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push si
	mov dx, 1
	mov si, 1
	mov cx, 320
screen_draw:
	mov [bloopcounter], cx
	mov cx, 200
	draw:
		mov [sloopcounter], cx
		mov cx, si
		mov ah, 0Ch
		mov bh, 0
		cmp dx, 190
		jg land
	background:
		mov al, 100
		int 10h
		jmp repeatloop
	land:
		mov al, 255
		int 10h
	repeatloop:
		mov cx, [sloopcounter]
		inc dx
		loop draw
	mov dx, 1
	inc si
	mov cx, [bloopcounter]
	loop screen_draw	
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
endp screen_set
proc dinsor
	push bp
	mov bp, sp
	push ax;+1
	push bx;+4
	push cx;+6
	push dx;+8
	push si
	mov cx, 15;17
paint1:
	sub [T_REX_y0], 40
	mov [bloopcountert], cx
	mov cx, [T_REX_x]
y_paint1:
	mov bh, 0h
	mov dx, [T_REX_y]
	mov si, 0
	mov ax, 0C01h
	int 10h
	dec [T_REX_y]
	mov ax, [T_REX_y0]
	cmp [T_REX_y], ax
	jg y_paint1
	inc [T_REX_x]
	add [T_REX_y0], 40
	mov ax, [T_REX_y0]
	mov [T_REX_y], ax
	mov cx, [bloopcountert]
	loop paint1
	mov ax, [T_REX_x0]
	mov [T_REX_x], ax
	mov ax, [T_REX_y0]
	mov [T_REX_y], ax
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
endp dinsor
proc obstacle
	push bp
	mov bp, sp
	push ax;+1
	push bx;+4
	push cx;+6
	push dx;+8
	push si
	mov cx, 6
paint_o:
	mov [bloopcountert], cx
	mov cx, [obstacle1_x]
y_paint_o:
	mov bh, 0h
	mov dx, [obstacle1_y]
	mov si, 0
	mov ax, 0C02h
	int 10h
	dec [obstacle1_y]
	cmp [obstacle1_y], 180
	jg y_paint_o
	dec [obstacle1_x]
	mov [obstacle1_y], 190
	mov cx, [bloopcountert]
	loop paint_o
	cmp [obstacle1_x], 3 ; once we are at beginning of the screen, we should reset the counters
	jle reset
	add [obstacle1_x], 3 ; we can control speed by using 1-6 values 
	jmp end_ol
reset:
	mov ax, [obstacle_x0]
	mov [obstacle1_x], ax
	mov ax, [obstacle_y0]
	mov [obstacle1_y], ax
end_ol:
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
endp obstacle
proc start_game
	push ax
screen:
	mov ax, 13h
	int 10h
	call screen_set
	call dinsor
	call obstacle
	pop ax
	ret
endp start_game
proc con_game
	call screen_set
	call dinsor
	call obstacle
	ret
endp con_game
proc losecheck; obstacle1_y == 180,190 == T_REX_y, obstacle1_x, T_REX_x0==29, T_REX_x==44
	push bp
	mov bp, sp
	push ax
	push dx
	mov ax, [T_REX_y]
	cmp ax, 180
	jg check_x
	jmp cont
check_x:
	mov ax, 45
	cmp ax, [obstacle1_x]
	jge check_x2
	jmp cont
check_x2:
	mov ax, 15
	cmp ax, [obstacle1_x]
	jle lose_screen
	jmp cont
lose_screen:
	mov ah, 0
	mov al, 2
	int 10h
	mov ah, 9h
	mov dx,offset ending_text_and_keybindes
	int 21h
	mov ah, 9h
	mov dx,offset ending_text_and_keybindes2
	int 21h
restart:
	call key_detecting
	cmp [compering], 32
	je new_game
	mov ax, 4c00h
	int 21h
new_game:
	mov [new_game1], 1
	mov ax, [obstacle_x0]
	mov [obstacle1_x], ax
	mov ax, [obstacle_y0]
	mov [obstacle1_y], ax
cont:
;	add [obstacle1_x], 3
;	mov ax, [T_REX_y0]
;	mov [T_REX_y], ax
;	mov ax, [T_REX_x0]
;	mov [T_REX_x], ax
	pop dx
	pop ax
	pop bp
	ret
endp losecheck
start:
	mov ax, @data
	mov ds, ax
	mov [new_game1], 0
	mov ax, 13h
    int 10h
	call starting_message
wait_for_space:
	call key_detecting
	cmp [compering], 20h
	je startg
	jmp wait_for_space
startg:	
	call start_game
gameloop:
	mov ah, 2Ch ; Loop system: checks every iteration if time has passed
    int 21h ; ch=hour cl=minute dh=second dl=1/100 second
    cmp dl, [prev_time]
    je gameloop
	mov [prev_time], dl
	call losecheck
	cmp [new_game1], 1
	je start
    call key_pressed ; If no key was pressed, skip input stage
    jz mov_obstacle
	call key_detecting
	cmp [compering], 1bh ; if esc was pressed - exit the game
	je exit1
	cmp [compering], 20h;  if space was pressed - jump up
	je jump
	jmp mov_obstacle
jump:
	mov [skip_to_up_down], 1
	cmp [up], 1
	je up1
	cmp [down], 1
	je down1
up1:
	dec [T_REX_y]
	dec [T_REX_y0]
	dec [obstacle1_x]
	call con_game
	inc [up_down_count]
	cmp [up_down_count], 20
	je go_down
	jmp gameloop
exit1:
	jmp exit
go_down:
	mov [up_down_count], 0
	mov [down], 1
	mov [up], 0
	jmp gameloop
down1:
	inc [T_REX_y]
	inc [T_REX_y0]
	dec [obstacle1_x]
	call con_game
	inc [up_down_count]
	cmp [up_down_count], 20
	je go_back_to_normal
	jmp gameloop
mov_obstacle:
	cmp [skip_to_up_down], 1 ; if nothing was pressed - see if we are in the jump process
	je jump
	dec [obstacle1_x]
	call con_game
	jmp gameloop
go_back_to_normal:
	mov [skip_to_up_down], 0
	mov [up_down_count], 0
	mov [up], 1
	mov [down], 0
	jmp gameloop
exit:
	mov ax, 4c00h
	int 21h
end start
