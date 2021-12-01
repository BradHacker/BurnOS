bits 16
org 0x7c00

boot:
  ; enable A20 bit
  mov ax, 0x2401
  int 0x15

  ; set to 16/256k color mode
	mov ax, 0x3
	int 0x10

	mov [disk], dl

	mov ah, 0x2    ;read sectors
	mov al, 2      ;sectors to read
	mov ch, 0      ;cylinder idx
	mov dh, 0      ;head idx
	mov cl, 2      ;sector idx
	mov dl, [disk] ;disk idx
	mov bx, copy_target;target pointer
	int 0x13

  ; set up Global Descriptor Table (GDT)
  cli
  lgdt [gdt_pointer]
  mov eax, cr0
  or eax, 0x1 ; set protected bit on cpu register cr0
  mov cr0, eax
  mov ax, DATA_SEG
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  mov ss, ax
  jmp CODE_SEG:boot2

gdt_start:
	dq 0x0
gdt_code:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10011010b
	db 11001111b
	db 0x0
gdt_data:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0
gdt_end:
gdt_pointer:
    dw gdt_end - gdt_start
    dd gdt_start
disk:
    db 0x0
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

times 510 - ($-$$) db 0
dw 0xaa55

copy_target:
bits 32

; hello: db "Hello more than 512 bytes world!!",0
color: db 0x0F
msg: db 1, "                    )      )                       )                            ", "     (  (     (   ( /(   ( /(    (   (           ( /(                           ", "     )\))(   ))\  )\())  )\())  ))\  )(    (     )\())                          ", "    ((_))\  /((_)(_))/  ((_)\  /((_)(()\   )\ ) (_))/                           ", "    (()(_)(_))", 2, "  | |_   | |", 1, "(_)(_))(  ((_) _(_/( ", 2, "| |_                             ", "   / _` | / -_) |  _|  | '_ \| || || '_|| ' \", 1, "))", 2, "|  _|                            ", "   \__, | \___|  \__|  |_.__/ \_,_||_|  |_||_|  \__|                            ", "   |___/" , 0
boot2:
	mov esi,msg
	mov ebx,0xb8000
.loop:
	lodsb
  check_exit:
    or al,al
    jz halt
  check_red:
    cmp al, 1
    jnz check_white
    mov cl, 0x04
    mov [color], cl
    jmp continue
  check_white:
    cmp al, 2
    jnz print_char
    mov cl, 0x0F
    mov [color], cl
    jmp continue
  print_char:
    mov ah, [color]
    mov word [ebx], ax
    add ebx, 2
  continue:
    jmp boot2.loop
halt:
	cli
	hlt

times 2048 - ($-$$) db 0
; copy_target:

; bits 32


; boot2:
;   mov esi, msg
;   mov ah, 0x0e

; ; .loop:
; ; 	lodsb
; ; 	or al,al
; ; 	jz halt
; ; 	or eax,0x0F00
; ; 	mov word [ebx], ax
; ; 	add ebx,2
; ; 	jmp .loop

; .loop:
;   lodsb ; load si into al and increment si
;   or al, al
;   jz done ; quit if we've hit the end of the string
;   or al, 1 ; check if we want to toggle red
;   jnz check_white
;   mov bl, 4
;   jmp boot2.loop
; check_white:
;   or al, 2
;   jnz not_a_color
;   mov bl, 15
;   jmp boot2.loop
; not_a_color:
;   int 0x10
;   jmp boot2.loop
; done:
;   cli
;   hlt

; ; 1 = red
; ; 2 = white


; times 1024 - ($-$$) db 0