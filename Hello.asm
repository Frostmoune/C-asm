global begin
delay equ 900					
ddelay equ 200 ; 用于显示延迟

begin:
    xor ax, ax
    mov ax, cs
	mov ds, ax					
	mov es, ax					
	mov	ax, 0B800h				
	mov	gs, ax
    mov byte[i], 1
    mov byte[j], 0
    mov byte[k], 1
    mov byte[m], 0
    mov word[count], 1
    mov word[dcount], 1

; 主显示模块
show_All:
    mov ax, 0
    mov ah, 1 
    int 16h
    cmp ax, 011bh 
    jz exit_to_index
    dec word[count]				
	jnz show_All					
	mov word[count], delay
	dec word[dcount]				
    jnz show_All
	mov word[count], delay
	mov word[dcount], ddelay
    inc byte[j]
    mov al, 1
    cmp al, byte[i]
    jz show_H
    mov al, 2
    cmp al, byte[i]
    jz show_E
    mov al, 3
    cmp al, byte[i]
    jz show_L
    mov byte[m], 9
    mov al, 4
    cmp al, byte[i]
    jz show_L
    mov byte[m], 18
    mov al, 4
    cmp al, byte[i]
    jz show_L
    mov al, 5
    cmp al, byte[i]
    jz show_O
    jmp end
; 画H
show_H:
    mov word[x], 4
    mov word[y], 5
    mov word[z], 10
    mov al, 1
    mov byte[k], 1
    cmp al, byte[j]
    jz draw_col
    mov word[x], 7
    mov word[y], 5
    mov word[z], 9
    mov al, 2
    mov byte[k], 2
    cmp al, byte[j]
    jz draw_row
    mov word[x], 4
    mov word[y], 9
    mov word[z], 10
    mov al, 3
    cmp al, byte[j]
    mov byte[k], 1
    jz draw_col
    mov byte[i], 2
    mov byte[j], 0
    jmp show_All
; 画E
show_E:
    mov word[x], 4
    mov word[y], 14
    mov word[z], 10
    mov al, 1
    mov byte[k], 1
    cmp al, byte[j]
    jz draw_col
    mov word[x], 5
    mov word[y], 14
    mov word[z], 19
    mov al, 2
    mov byte[k], 2
    cmp al, byte[j]
    jz draw_row
    mov word[x], 7
    mov word[y], 14
    mov word[z], 18
    mov al, 3
    cmp al, byte[j]
    jz draw_row
    mov word[x], 9
    mov word[y], 14
    mov word[z], 19
    mov al, 4
    cmp al, byte[j]
    jz draw_row
    mov byte[i], 3
    mov byte[j], 0
    jmp show_All
; 画L
show_L:
    mov word[x], 4
    mov ax, 23
    add ax, word[m]
    mov word[y], ax
    mov word[z], 10
    mov al, 1
    mov byte[k], 1
    cmp al, byte[j]
    jz draw_col
    mov word[x], 9
    mov ax, 23
    add ax, word[m]
    mov word[y], ax
    mov ax, 28
    add ax, word[m]
    mov word[z], ax
    mov al, 2
    mov byte[k], 2
    cmp al, byte[j]
    jz draw_row
    inc byte[i]
    mov byte[j], 0
    jmp show_All
; 画O
show_O:
    mov byte[k], 3
    mov word[x], 7
    mov word[y], 41
    mov al, 1
    cmp al, byte[j]
    jz draw
    dec word[x]
    inc word[y]
    mov al, 2
    cmp al, byte[j]
    jz draw
    dec word[x]
    inc word[y]
    mov al, 3
    cmp al, byte[j]
    jz draw
    inc word[y]
    mov al, 4
    cmp al, byte[j]
    jz draw
    inc word[y]
    mov al, 5
    cmp al, byte[j]
    jz draw
    inc word[x]
    inc word[y]
    mov al, 6
    cmp al, byte[j]
    jz draw
    inc word[x]
    inc word[y]
    mov al, 7
    cmp al, byte[j]
    jz draw
    inc word[x]
    dec word[y]
    mov al, 8
    cmp al, byte[j]
    jz draw
    inc word[x]
    dec word[y]
    mov al, 9
    cmp al, byte[j]
    jz draw
    dec word[y]
    mov al, 10
    cmp al, byte[j]
    jz draw
    dec word[y]
    mov al, 11
    cmp al, byte[j]
    jz draw
    dec word[x]
    dec word[y]
    mov al, 12
    cmp al, byte[j]
    jz draw
    inc byte[i]
    mov byte[j], 0
    jmp show_All

; word[x]表示纵坐标，word[y]表示横坐标，word[z]表示画线的终止横/纵坐标
; 画一条竖线
draw_col:
    inc word[x]
    mov ax, word[x]
    mov bx, word[z]
    sub bx, ax
    jnz draw
    jmp show_All
; 画一条横线
draw_row:
    inc word[y]
    mov ax, word[y]
    mov bx, word[z]
    sub bx, ax
    jnz draw
    jmp show_All
; 在当前坐标上画字符
draw:
    xor ax, ax                 
    mov ax, word[x]
	mov bx, 80
	mul bx
	add ax, word[y]
	mov bx, 2
	mul bx
	mov bp, ax
	mov ah, 0Fh				
	mov al, '*'			
	mov word[gs:bp], ax ;画‘*’		
	mov al, 1
    cmp al, byte[k] ;byte[k]用于判断当前是在画竖线、画横线还是画O
    jz draw_col
    mov al, 2
    cmp al, byte[k]
    jz draw_row
    mov al, 3
    cmp al, byte[k] 
    jz show_All

end:
    xor ax, ax
    mov dh, 0
    mov dl, 0
    mov ah, 02h
    int 10h
    mov ah, 0 
    int 16h
    cmp ax, 011bh
    jz exit_to_index
    jmp $

clr_screen:
    mov     dx, 0000h
    mov     ah, 0x02
    int     0x10
    mov     ax, 0600h
    mov     cx, 0000h
    mov     dx, 184fh
    mov     bh, 0x07
    int     0x10
    ret

exit_to_index:
    call    clr_screen
    int 19h

data:
    x dw 0
    y dw 7
    z dw 15 ; 储存值
    i dw 0 ; 判断显示哪个字母
    j dw 7 ; 判断显示竖还是行
    k dw 15 ; 判断跳回哪一个函数
    m dw 23 ; 表示横坐标偏移值
    count dw delay
    dcount dw ddelay
    times 1022-($-$$) db 0
    db 0x55,0xaa