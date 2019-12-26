[org 0x7c00]
KERNEL_OFFSET equ 0x1000
    mov [BOOT_DRIVE], dl

    mov bp, 0x9000
    mov sp, bp



    call cursor
   
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

[bits 16]
cursor:
    mov cx, 0x0007
    mov ah, 0x01
    int 0x10
    call set_cursor
    ret

set_cursor:
    mov dh, 0x0f
    mov dl, 0x00
    mov bh, 0x0
cur_loop:
    inc dl
    mov ah, 0x02
    int 0x10
    call sleep_bios_time
    jmp cur_loop
    ret

ticks dd 0
sleep_bios_time:
    mov ah, 0x00                ; set ticks cx:dx
    int 0x1A
    call print_hex
    mov dword [ticks], edx

    call print_hex
    jmp $

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

MSG_REAL_MODE db "16-bit mode", 0
;MSG_PROT_MODE db "32-bit protected mode", 0
;MSG_LOAD_KERNEL db "Loading KERNEL", 0
;MSG_LOADED db "Loaded KERNEL", 0

times 510-($-$$) db 0
dw 0xaa55
