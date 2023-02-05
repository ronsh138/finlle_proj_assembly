IDEAL
MODEL small
STACK 256h
DATASEG
bloopcountert dw 0000h
sloopcountert dw 0000h
countert dw 0000h

T_REX_x dw 20
T_REX_y dw 190
T_REX_x0 dw 20
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
starting_text_and_keybindes db "Hello!, and welcome to the T-REX RUNNER(cursed adition).",10,10,"In this game you are a dinasour(T-REX) that runs in a field full of obstacles that you must avoid to survive.",10,10,"every 100 points the speed of the dinasour will increase so be carefull.",10,10,"to jump you simply press the space button.",10,10,10,"----to start please press space----$"
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
	mov ah, 0h
	int 16h
	call start_game
	pop ax
	pop dx
	ret
endp starting_message
proc space_detecting
	push ax
	mov ah, 1
	int 21h
	mov [compering], al
	pop ax
	ret
endp space_detecting
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
		jg background
	land:
		mov al, 100
		int 10h
		jmp repeatloop
	background:
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
;proc pixel_painter
;	push bp
;	mov bp, sp
;	push ax;+1
;	push bx;+4
;	push cx;+6
;	push dx;+8
;	mov cx, [bp+6]
;	mov dx, [bp+8]
;	mov ax, [bp+2]
;	mov bx, [bp+4]
;	int 10h
;	pop dx
;	pop cx
;	pop bx
;	pop ax
;	pop bp
;	ret
;endp pixel_painter
proc dinsor
	push bp
	mov bp, sp
	push ax;+1
	push bx;+4
	push cx;+6
	push dx;+8
	push si
	mov cx, 17h;17
paint:
	mov [bloopcountert], cx
	mov cx, [T_REX_x]
y_paint:
	mov bh, 0h
	mov dx, [T_REX_y]
	mov si, 0
	mov ax, 0C01h
	int 10h
	dec [T_REX_y]
	cmp [T_REX_y], 150
	jg y_paint
	inc [T_REX_x]
	mov [T_REX_y], 190
	mov cx, [bloopcountert]
	loop paint
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
	cmp [obstacle1_x], 1
	je reset
	add [obstacle1_x], 5
	add [obstacle1_y], 10
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
	pop ax
	ret
endp start_game
start:
	mov ax, @data
	mov ds, ax
	mov ax, 13h
    int 10h
	call starting_message
wait_for_space:
	call space_detecting
	cmp [compering], 20h
	je startg
	jmp wait_for_space
startg:	call dinsor
	call obstacle
mov_obstacle:
	dec [obstacle1_x]
	call obstacle
	mov cx, 6
	call space_detecting
	cmp [compering], 20h
	je up
	jmp mov_obstacle
up:
	dec [T_REX_y]
	dec [T_REX_y0]
	call screen_set
	call dinsor
	dec [obstacle1_x]
	call obstacle
	loop up
	mov cx, 6
down:
	inc [T_REX_y]
	inc [T_REX_y0]
	call screen_set
	call dinsor
	dec [obstacle1_x]
	call obstacle
	loop down
	call space_detecting
	cmp [compering], 107
	je exit
	jmp mov_obstacle
exit:
	mov ax, 4c00h
	int 21h
end start
