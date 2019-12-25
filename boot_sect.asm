[org 0x7c00]
KERNEL_OFFSET equ 0x1000
    mov [BOOT_DRIVE], dl

    mov bp, 0x9000
    mov sp, bp

    mov bx, MSG_REAL_MODE
    call print

    call load_kernel

    mov bx, MSG_LOADED
    call print

    call switch_to_pm

    jmp $

%include "prints.asm"
%include "disk_load.asm"
%include "switch_pm.asm"

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print

    mov bx, KERNEL_OFFSET
    mov dh, 15
    mov dl, [BOOT_DRIVE]
    call disk_load
    ret

[bits 32]
BEGIN_PM:
    mov ebx, MSG_PROT_MODE
    call print_pm

    call KERNEL_OFFSET
    jmp $

MSG_REAL_MODE db "16-bit mode", 0
MSG_PROT_MODE db "32-bit protected mode", 0
MSG_LOAD_KERNEL db "Loading KERNEL", 0
MSG_LOADED db "Loaded KERNEL", 0

times 510-($-$$) db 0
dw 0xaa55
