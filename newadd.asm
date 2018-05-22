global main_add

main_add:
    mov	ax, cs	       
    mov	ds, ax	       		 
    mov	bp, myinput		 
    mov	ax, ds		
    mov	es, ax		 
    mov	cx, inputlength  
    mov	ax, 1301h		 
    mov	bx, 0007h		 			 
    int	10h
    mov byte[i], 0
    
start:
    mov word[0], 0
    mov al, 2
    cmp byte[i], al
    jb input
    jmp sum			 

; 接受并处理输入
input:
    mov ax, 0
    mov ah, 0 
    int 16h
    cmp ax, 011bh
    jz exit_to_index
    mov cx, 1
    mov ah, 0eh
    int 10h 
    cmp al, '0'
    jb input_end
    cmp al, '9'
    ja input_end
    mov ah, 0
    sub al, '0'
    ; word[0]用于储存输入，每一次循环都要乘10并加上新的输入数字
    push ax
    mov ax, word[0]
    mov bx, 10
    mul bx
    mov word[0], ax
    pop ax
    add word[0], ax
    jmp input

input_end:
    mov ah, 03h
    int 10h
    add dh, 0
    add dl, 0
    mov ah, 02h
    int 10h
    mov ah, 0eh ;0eh号调用
    mov al, 0ah ;显示换行
    int 10h ;屏幕中断
    mov al, 0dh ;显示回车
    int 10h ;屏幕中断
    inc byte[i]
    mov ax, word[0]
    push ax
    jmp start

sum:
    ; 调整光标位置
    mov ah, 03h
    int 10h
    add dh, 0
    add dl, 0
    mov ah, 02h
    int 10h
    mov ah, 0eh 
    mov al, 0ah 
    int 10h 
    mov al, 0dh 
    int 10h 
    ; 计算和
    pop ax
    mov bx, ax
    pop ax
    add ax, bx
    mov word[0], ax

output:
    mov	bp, myoutput		 
	mov	ax, ds		
	mov	es, ax		 
	mov	cx, outputlength  
	mov	ax, 1301h		 
	mov	bx, 0007h		 			 
	int	10h
    mov cx, -1
    push cx ; the end of push
    mov bx, 10
    mov ax, word[0]

; 转化为10进制
todec:
    xor dx, dx
    div bx
    mov cx, ax
    or cx, dx ;若余数为0则开始输出
    jz print
    push dx
    jmp todec

print:
    pop dx
    cmp dx, -1 
    je exit
    mov ax, dx
    add al, '0'
    mov ah, 0eh ;0eh号调用
    int 10h
    jmp print

exit:
    mov ah, 03h
    int 10h
    add dh, 0
    add dl, 0
    mov ah, 02h
    int 10h
    mov	bp, exitinfo		 
	mov	ax, ds		
	mov	es, ax		 
	mov	cx, exitlength  
	mov	ax, 1301h		 
	mov	bx, 0007h		 			 
	int	10h
    xor cx, cx
    xor dx, dx
    mov ax, 0
    mov ah, 0 
    int 16h

exit_to_index:
    call    clr_screen 
    int     19h ;   子程序返回boot

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

myinput:
    db 0dh,0ah,'Please input two numbers:',0dh,0ah
inputlength equ ($-myinput)

myoutput:
    db 0dh,0ah,'Now output the Result:',0dh,0ah
outputlength equ ($-myoutput)

exitinfo:
    db 0dh,0ah,'Enter any key to exit',0dh,0ah
exitlength equ ($-exitinfo)

data:
    i dw 7

times 510-($-$$) db 0
db 0x55,0xaa