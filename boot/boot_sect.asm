[org 0x7c00]
KERNEL_OFFSET equ 0x1000
    mov [BOOT_DRIVE], dl

    mov bp, 0x9000
    mov sp, bp


    call set_cursor_shape
    call main_loop
    jmp $

;    call load_kernel
;
;    mov bx, MSG_LOADED
;    call print
;
;    call switch_to_pm

    jmp $

%include "prints.asm"
%include "disk_load.asm"
%include "switch_pm.asm"
%include "input.asm"

[bits 16]
main_loop:
    call sleep_bios
    call input
    call set_cursor_pos
    jmp main_loop

set_cursor_shape:
    mov cx, 0x0007              ; fill line 0 - 7
    mov ah, 0x01                ; set cursor shape
    int 0x10
    ret

set_cursor_pos:                     ; dh = row, dl = column
    mov bh, 0x0                 ; page number[?]
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

[bits 16]
load_kernel:
    mov bx, KERNEL_OFFSET
    mov dh, 15
    mov dl, [BOOT_DRIVE]
    call disk_load
    ret

[bits 32]
BEGIN_PM:
    call KERNEL_OFFSET
    jmp $

;MSG_REAL_MODE db "16-bit mode", 0
;MSG_PROT_MODE db "32-bit protected mode", 0
;MSG_LOAD_KERNEL db "Loading KERNEL", 0
;MSG_LOADED db "Loaded KERNEL", 0

times 510-($-$$) db 0           ;fill empty space
dw 0xaa55                       ;magic number
