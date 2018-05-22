

;         (32位栈每次push一个字)
;	|-----------------------|
;	|       3rd param       | <---ebp + 16 , caller push and pass it too callee
;	|-----------------------|
;	|       2nd param       | <---ebp + 12 , caller push and pass it too callee
;	|-----------------------|
;	|       1st param       | <---ebp + 8  , caller push and pass it too callee
;	|-----------------------|
;	|   return address      | <---ebp + 4  , caller using "call" will push it auto
;	|-----------------------|
;	|       old ebp         | <-----ebp, callee push to save ebp
;	|-----------------------|
;	|   local variables     |
;	|   registers saved     | <-----ebp - n, callee free to use
;	|-----------------------|
;	|       ... ...         |
;	|-----------------------|
;	|       ... ...         | <-----esp
;	|-----------------------|
;	|                       |
;	|       empty stack     |
;	|                       |

global  entry
extern  showInfo
extern  main
extern  print_str
extern  print_str_uppercase
extern  input_num
extern  choose
extern  print_num_enter
extern  clr_screen

OffSetOfUserPrg equ 0x1000

bits 16

segment .text

entry:
        push    dword KernelInfo       ;push param on stack
        call    dword showInfo
        add     esp, 4                 ;clean params on stack

        push    dword SuccessInfo      ;push param on stack
        call    dword print_str
        add     esp, 4                 ;clean params on stack

        push    dword SelectInfo
        call    dword print_str
        add     esp, 4

        call    dword input_num
        add     esp, 4

        cmp     al, 2
        je      jump

        push    dword TestInfo
        call    dword print_str
        add     esp, 4

        push    dword TestInfo_2
        call    dword print_str
        add     esp, 4

        push    dword TestInfo
        call    dword print_str_uppercase
        add     esp, 4

        push    dword TestInfo
        call    dword print_str
        add     esp, 4

test_:

        push    dword InputInfo
        call    dword print_str
        add     esp, 4

        call    dword input_num
        mov     ebp, Arr
        mov     [ebp], eax
        add     esp, 4
        
        call    dword input_num
        mov     ebp, Arr
        mov     [ebp + 4], eax
        add     esp, 4

        call    dword input_num
        mov     ebp, Arr
        mov     [ebp + 8], eax
        add     esp, 4

        call    dword input_num
        mov     ebp, Arr
        mov     [ebp + 12], eax
        add     esp, 4

        push    dword Enter
        call    dword print_str    

continue: 
        mov     ebp, Arr
        push    dword [ebp]
        push    dword [ebp + 4]
        push    dword [ebp + 8]
        push    dword [ebp + 12]
        call    dword choose
        add     esp, 12

jump:
        call    dword main
        jmp     $ ;will not return

        

segment .data

KernelInfo:
        db 'Loading Kernel...',0x0d,0x0a,0x00     ;0x0d means '\n', 0x0a means '\r', 0x00 means '\0'

SuccessInfo:
        db 'Success.',0x0d,0x0a,0x00

SelectInfo:
        db '1.Continue testing',0x0d,0x0a,'2.Jump to main',0x0d,0x0a,0x00

JumpSelect:
        db '1.Add',0x0d,0x0a,'2.Prime',0x0d,0x0a,'3.Hello',0x0d,0x0a,0x00

TestInfo:
        db 'heLlo wOrld!',0x0d,0x0a,0x00

TestInfo_2:
        db 'Now change it to uppercase.',0x0d,0x0a,0x00

InputInfo:
        db 'Test for choose',0x0d,0x0a,'Please Input four integers',0x0d,0x0a,0x00

Enter:
        db 0x0d,0x0a,0x00

Arr:    
        dd 0000h,0000h,0000h,0000h
