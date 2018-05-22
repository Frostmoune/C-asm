;	+--------+
;	|        |
;	|        |
;	|        |
;	|        |
;	|--------|
;	|BOOT SEC|
;	|ORIGIN  | 07C0:0000
;	|--------|
;	|        |
;	|        |
;	|        |
;	|--------|
;	|KERNEL  |
;	|LOADED  |
;	|--------| 0060:0000
;	|        |
;	+--------+


bits 16

segment .text

jmp near entry

BS_OEMName         db 'SYSU    '    ;厂商名
BPB_BytsPerSec     dw 200h          ;每个扇区大小，单位：字节
BPB_SecPerClus     db 1             ;每个簇占用扇区个数
BPB_RsvdSecCnt     dw 1             ;保留扇区数
BPB_NumFATs        db 2             ;FAT表的数量
BPB_RootEntCnt     dw 0e0h          ;最大根目录文件数
BPB_TotSec16       dw 0b40h         ;逻辑扇区总数
BPB_Media          db 0f0h          ;媒体描述符
BPB_FATSz16        dw 9             ;每个FAT占用扇区数
BPB_SecPerTrk      dw 12h           ;每个磁道扇区数
BPB_NumHeads       dw 2             ;磁头数
BPB_HiddSec        dd 0             ;隐藏扇区数
BPB_TotSec32       dd 0             ;如果BPB_TotSec16是0，则在这里记录扇区总数
BS_DrvNum          db 0             ;中断13的驱动器号
BS_Reserved        db 0             ;未使用
BS_BootSig         db 29            ;扩展引导标志
BS_VolID           dd 0             ;卷序列号
BS_VolLab          db 'MyOS       ' ;卷标，必须是11个字符，不足以空格填充
BS_FileSysType     db 'FAT12   '    ;文件系统类型，必须是8个字符，不足填充空格


%define     BASE        0x7c00
%define     LOADSEG     0x0060
%define     KERSIZE     10
%define     KERSTART    17

        org  BASE
entry:
        sub     ax, ax
        mov     ds, ax
        mov     ss, ax          ; initialize stack
        mov     bp, 0x7c00
        mov     sp, 0x7c00
        call    print
        db      "Loading Boot...",13,10,0

read_floppy:
        mov     ax, LOADSEG           ;段地址 ; 存放数据的内存基地址
        mov     es, ax                ;设置段地址（不能直接mov es,段地址）
        mov     bx, 0                 ;偏移地址; 存放数据的内存偏移地址
        mov     ah, 2                 ; 功能号
        mov     al, KERSIZE           ;扇区数
        mov     dl, 0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
        mov     dh, 1                 ;磁头号 ; 起始编号为0
        mov     ch, 0                 ;柱面号 ; 起始编号为0
        mov     cl, KERSTART          ;起始扇区号 ; 起始编号为1
        int     13H                   ;调用读磁盘BIOS的13h功能
        cmp     ah, 0;
        jmp     word LOADSEG:0x0000
        jmp     $

print_char:
        xor     bx, bx                   ; video page 0
        mov     ah, 0x0E                 ; else print it
        int     0x10                     ; via TTY mode
print:
        pop     si                       ; this is the first character
        lodsb                          ; get token
        push    si                       ; stack up potential return address
        cmp     al, 0                    ; end of string?
        jne     print_char              ; until done
        ret                            ; and jump to it


        times   0x01fe-$+$$ db 0

sign            dw      0xAA55
