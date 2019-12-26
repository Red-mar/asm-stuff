[org 0x7c00]
;KERNEL_OFFSET equ 0x1000

    mov bp, 0x9000
    mov sp, bp

    call init
    call main_loop

;    call load_kernel
;
;    mov bx, MSG_LOADED
;    call print
;
;    call switch_to_pm

    jmp $

%include "prints.asm"
;; %include "disk_load.asm"
;; %include "switch_pm.asm"
%include "input.asm"

    [bits 16]

main_loop:
    call clear_vmem
    call print_dx
    call set_cursor_pos
    call draw_pixel

    call sleep_bios
    call input
    jmp main_loop
    ret

clear_vmem:
    pusha
    mov ebx, 0xa0000            ; go to memory start
write_loop:
    mov word [ebx], 0           ; write 0
    inc ebx                     ; increase mem pointer
    cmp ebx, 0xb1000            ; check if at the end
    jne write_loop              ; if not more 0's
    popa
    ret

draw_pixel:
    pusha
    mov bx, dx                  ; save the cursor pos
    mov ah, 0x0C                ; draw graphics pixel
    mov al, 0x0f                ; color
    mov cl, bl                  ; position in cx:dx
    mov dl, bh
    xor ch, ch                  ; since cursor pos is only 1 bytes
    xor dh, dh                  ; higher bytes will have to be cleared
    int 0x10
    popa
    ret

print_dx:
    push dx
    mov dx, 0x0f01
    call set_cursor_pos
    pop dx
    call print_hex
    ret

init:
    mov al, 0x6A                ; init graphics mode
    mov ah, 0x00                ; 800x600 16 color (?)
    int 0x10
;    mov cx, 0x0007              ; fill line 0 - 7
;    mov ah, 0x01                ; set cursor shape
;    int 0x10
    ret

set_cursor_pos:                     ; dh = row, dl = column
    mov bh, 0x00
    mov ah, 0x02
    int 0x10
    ret

ticks dd 0
sleep_bios:
    pusha
    mov ah, 0x00                ; get ticks cx:dx
    int 0x1A
    mov word [ticks], cx        ; NOTE: not used
    mov word [ticks+2], dx      ; save ticks
    add word [ticks+2], 0x0001  ; when to end sleep
sleep_bios_loop:
    int 0x1A                    ; get ticks again
    cmp word [ticks+2], dx      ; check again if not
    jne sleep_bios_loop         ; yet at end sleep
    popa
    ret

;[bits 16]
;load_kernel:
;    mov bx, KERNEL_OFFSET
;    mov dh, 15
;    mov dl, [BOOT_DRIVE]
;    call disk_load
;    ret
;
;[bits 32]
;BEGIN_PM:
;    call KERNEL_OFFSET
;    jmp $

;MSG_REAL_MODE db "16-bit mode", 0
;MSG_PROT_MODE db "32-bit protected mode", 0
;MSG_LOAD_KERNEL db "Loading KERNEL", 0
;MSG_LOADED db "Loaded KERNEL", 0

times 510-($-$$) db 0           ;fill empty space
dw 0xaa55                       ;magic number
