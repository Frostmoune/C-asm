global main_prime

main_prime:
    mov bh, 0
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
    mov	ax, cs	       
    mov	ds, ax	       		 
    mov	bp, myinput		 
    mov	ax, ds		
    mov	es, ax		 
    mov	cx, inputlength  
    mov	ax, 1301h		 
    mov	bx, 0007h		 			 
    int	10h
    mov word[0], 0
    mov byte[i], 1		 

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
    mov ax, word[0]
    cmp al, 2
    jb main_prime

myprime:
    mov word[j], 2
    mov dx, word[j]
    push dx
    jmp output_begin

continue:
    mov cx, 0002h
    mov dx, 0003h

; word[0]是输入的数字，dx是当前的数字（即需要判断dx是否为质数）
; cx用于判断dx是否为质数，外层循环是dx自增，直到大于word[0]结束，
; 内层循环是cx自增。
isprime:
    push dx
    cmp dx, word[0]
    ja exit
    mov bx, cx
    mov ax, dx
    xchg bx, ax
    mul cx
    cmp bx, ax ; ax(now is saved in bx)<cx^2 means ax is a prime
    jnae quit_2
    mov ax, bx
    div cx 
    add dx, 0 ; ah saves the value of ax%cl
    jne next ; if ah%cl!=0 jump to next
    jmp again

quit_2:
    pop dx
    mov word[j], dx
    mov byte[i], 2
    inc dx
    push dx
    jmp output

again:
    pop dx
    mov byte[i], 2
    inc dx
    mov cx, 0002h
    jmp isprime

next:
    pop dx
    inc cx 
    jmp isprime ; else continue the loop

output_begin:
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
    mov	bp, myoutput		 
	mov	ax, ds		
	mov	es, ax		 
	mov	cx, outputlength  
	mov	ax, 1301h		 
	mov	bx, 0007h		 			 
	int	10h

output:
    mov cx, -1
    push cx ; the end of push
    mov bx, 10
    mov ax, word[j]

todec:
    xor dx, dx
    div bx
    mov cx, ax
    or cx, dx
    jz print
    push dx
    jmp todec

print:
    pop dx
    cmp dx, -1 
    je continue_prime
    mov ax, dx
    add al, '0'
    mov ah, 0eh ;0eh号调用
    int 10h
    jmp print

continue_prime:
    mov al, ' '
    mov ah, 0eh ;0eh号调用
    int 10h
    mov al, 1
    cmp al, byte[i]
    jz continue
    pop dx
    mov cx, 0002h
    jmp isprime

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
    int     19h

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
    db 0dh,0ah,'Please input the number:',0dh,0ah
inputlength equ ($-myinput)

myoutput:
    db 0dh,0ah,'Now output the results:',0dh,0ah
outputlength equ ($-myoutput)

exitinfo:
    db 0dh,0ah,'Enter any key to exit',0dh,0ah
exitlength equ ($-exitinfo)

data:
    i dw 7
    j dw 15
    max dw 80h

times 510-($-$$) db 0
db 0x55,0xaa