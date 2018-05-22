global key_detect
global clr_screen
global print_string
global print_char
global key_detect_simple
global read_floppy_2
global write_floppy_2
global jump_to_user

User equ 8100h

bits 16

segment .text


print_string:
        push    ebp
        mov     ebp, esp
        mov     esi,    [ebp+0x08]      ;get 1st param
.print_loop:
        lodsb
        or      al, al
        jz      .print_leave
        mov     ah, 0x0e
        mov     bl, 0x00
        int     0x10
        jmp     .print_loop
.print_leave:
        mov     esp, ebp
        pop     ebp
        ret


print_char:
        push    ebp
        mov     ebp, esp
        mov     eax,    [ebp+0x08]      ;get 1st param

        mov     ah, 0x0e
        mov     bl, 0x00
        int     0x10

        mov     esp, ebp
        pop     ebp
        ret     2


key_detect_simple:
        push    ebp
        mov     ebp, esp

        xor     eax, eax
        int     0x16

        mov     esp, ebp
        pop     ebp
        ret     2

key_detect:
        push    ebp
        mov     ebp, esp
        mov     ecx, [ebp+0x08]
        mov     ebx, [ebp+0x0c]
        xor     eax, eax
        cmp     bl, 0   ; 判断是否阻塞
        je      key_no_block
        int     0x16
; 判断是否回显
char_is_show: 
        cmp     cl, 1
        je      char_show
; 退出
key_quit:
        mov     esp, ebp
        pop     ebp
        ret     2
; 回显
char_show:
        mov     ah, 0x0e
        int     0x10
        jmp     key_quit
; 非阻塞
key_no_block:
        mov     ah, 0x01
        int     0x16
        jnz     char_is_show
        jmp     key_quit

clr_screen:
        push    ebp
        mov     ebp, esp
        mov     dx, 0000h
        mov     ah, 0x02
        int     0x10    ; 移动光标到开头
        mov     ax, 0600h
        mov     cx, 0000h
        mov     dx, 184fh
        mov     bh, 0x07
        int     0x10    ; 清屏
        mov     esp, ebp
        pop     ebp
        ret     2
; 将扇区的内容读入内存由汇编实现
read_floppy_2:
        push    ebp
        mov     ebp, esp
        mov     eax, [ebp+0x08]
        mov     ch, al
        mov     eax, [ebp+0x0c]
        mov     dh, al
        mov     eax, [ebp+0x10]
        mov     cl, al
        mov     dl, 0x00
        mov     eax, [ebp+0x14]
        mov     ah, 0x02
        xor     bx, bx
        mov     es, bx
        mov     ebx, [ebp+0x18]
        int     0x13
        xor     ax, ax
        mov     esi, ebx      
        mov     esp, ebp
        pop     ebp
        ret
; 将内存的内容读入扇区由汇编实现
write_floppy_2:
        push    ebp
        mov     ebp, esp
        mov     eax, [ebp+0x08]
        mov     ch, al
        mov     eax, [ebp+0x0c]
        mov     dh, al
        mov     eax, [ebp+0x10]
        mov     cl, al
        mov     dl, 0x00
        mov     eax, [ebp+0x14]
        mov     ah, 0x03
        xor     bx, bx
        mov     es, bx
        mov     ebx, [ebp+0x18]
        int     0x13
        xor     ax, ax
        mov     esi, ebx      
        mov     esp, ebp
        pop     ebp
        ret

jump_to_user:
        push    ebp
        mov     ebp, esp
        mov     eax, [ebp+0x08]
        mov     ch, al
        mov     eax, [ebp+0x0c]
        mov     dh, al
        mov     eax, [ebp+0x10]
        mov     cl, al
        mov     dl, 0x00
        mov     eax, [ebp+0x14]
        mov     ah, 0x02
        mov     bx, User
        mov     es, bx
        xor     bx, bx
        int     0x13
        cmp     ah, 0

        jmp     word User:0x0000
        xor     ax, ax
        mov     esi, ebx      
        mov     esp, ebp
        pop     ebp
        ret     
