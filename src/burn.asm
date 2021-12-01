[bits 16]
[org 0x7c00]
mov ax, 0
mov ds, ax

init:
  mov ah, 0
  mov al, 0x12 ; set to 16/256k color mode
  int 0x10

  mov ah, 0x0b
  mov bh, 0 
  mov bl, 0
  int 0x10 ; set the background to black

  mov ax, 0x0700
  mov bh, 0x00 ; white characters on black background
  mov cx, 0x0000 ; put cursor at 0, 0
  mov dx, 0x184f ; row = 24, col = 79
  int 0x10

  mov si, msg
  mov ah, 0x0e
  print_char:
    lodsb ; load si into al and increment si
    cmp al, 1 ; check if we want to toggle red
    jne check_white
    mov bl, 4
    jmp print_char
    check_white:
    cmp al, 2
    jne not_a_color
    mov bl, 15
    jmp print_char
    not_a_color:
    cmp al, 0
    je done
    int 0x10
    jmp print_char
  done:
    hlt

; 1 = red
; 2 = white

msg: db 1, "                    )      )                       )", 13, 10, "     (  (     (   ( /(   ( /(    (   (           ( /(", 13, 10, "     )\))(   ))\  )\())  )\())  ))\  )(    (     )\())", 13, 10, "    ((_))\  /((_)(_))/  ((_)\  /((_)(()\   )\ ) (_))/", 13, 10, "    (()(_)(_))", 2, "  | |_   | |", 1, "(_)(_))(  ((_) _(_/( ", 2, "| |_", 13, 10, "   / _` | / -_) |  _|  | '_ \| || || '_|| ' \))|  _|", 13, 10, "   \__, | \___|  \__|  |_.__/ \_,_||_|  |_||_|  \__|", 13, 10,  "   |___/" 

times 510-($-$$) db 0
dw 0xaa55
