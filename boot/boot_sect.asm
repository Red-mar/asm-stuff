[org 0x7c00]
KERNEL_OFFSET equ 0x1000
    mov al, 0x03                ; init graphics mode
    mov ah, 0x00
    int 0x10

    mov [BOOT_DRIVE], dl

    mov bp, 0x9000
    mov sp, bp

    call load_kernel

    call switch_to_pm
    jmp $

%include "prints.asm"
%include "disk_load.asm"
%include "switch_pm.asm"

[bits 16]
load_kernel:
    mov bx, KERNEL_OFFSET
    mov dh, 15
    mov dl, [BOOT_DRIVE]
    call disk_load
    ret

BOOT_DRIVE: db 0xff

MULTIBOOT_HEADER_MAGIC: equ 0x1badb002
MULTIBOOT_HEADER_FLAGS: equ 0x00000003
MULTIBOOT_HEADER_CHECKSUM: equ -(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)

ALIGN 4
multiboot_header:
multiboot_magic: dd MULTIBOOT_HEADER_MAGIC
multiboot_flags: dd MULTIBOOT_HEADER_FLAGS
multiboot_checksum: dd MULTIBOOT_HEADER_CHECKSUM
e:  dd 0, 0, 0, 0, 0
video_mode: dd 0
width:   dd 1024
height: dd 768
depht:   dd 32

[bits 32]
BEGIN_PM:
    call KERNEL_OFFSET
    jmp $

times 510-($-$$) db 0           ;fill empty space
dw 0xaa55                       ;magic number
