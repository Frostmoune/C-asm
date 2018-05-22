bits 16

KN_FName    db 'kernel  '
KN_ExName   db 'bin'
KN_Attr     db 0x20
KN_Reserved dw 0x0000
KN_CreateT  dw 0x2C47
KN_CreateD  dw 0xB44C
KN_LastAD   dw 0xB44C
KN_Ignore   dw 0x0000
KN_LastWT   dw 0x2C47
KN_LastWD   dw 0xB44C
KN_FirstC   dw 0x0003
KN_Size     dd 0x000012C9

times 512*14-($-$$) db 0x00