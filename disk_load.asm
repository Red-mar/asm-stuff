[bits 16]
disk_load:
    push dx                     ;sectors requested
    mov ah, 0x02                ;bios read
    mov al, dh                  ;read dh sectors
    mov ch, 0x00                ;cylinder 0
    mov dh, 0x00                ;head 0
    mov cl, 0x02                ;read after boot sector
    int 0x13

    jc disk_error

    pop dx
    cmp dh, al
    jne sector_error
    ret

disk_error:
    mov bx, DISK_ERROR_MSG
    call print
    jmp $
sector_error:
    mov bx, SECTOR_ERROR_MSG
    call print
    jmp $


DISK_ERROR_MSG: db "Disk read error!!", 0
SECTOR_ERROR_MSG: db "Did not read enough sectors", 0

BOOT_DRIVE: db 0
