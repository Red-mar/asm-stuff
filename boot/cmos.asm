[bits 16]
    sec db 0

read_cmos_status
    mov al, 0x8A                ; cmos status register A
    out 0x70, al                ;
    jmp $+2
    in al, 0x71
    and al, 0xfff0              ; rate selection frequency
    xor al, 0x0003              ; default: 0110
    mov ah, al                  ; needs al, save in ah
    mov al, 0x8A
    out 0x70, al
    jmp $+2
    mov al, ah
    out 0x71, al                ; write to cmos

    mov al, 0x8A                ; confirm write with
    out 0x70, al                ; print hex
    jmp $+2
    in al, 0x71
    or dx, dx
    mov dl, al
    call print_hex

cmos_sleep:
    mov al, 0x00                ; ask for the
    out 0x70, al                ; current seconds
    jmp $+2
    in al, 0x71
    mov [sec], al               ; save them

cmos_sleep_loop:
    mov al, 0x00                ; ask for seconds
    out 0x70, al                ; again
    jmp $+2
    in al, 0x71
    cmp al, [sec]               ; if seconds still the same loop
    je sleep_loop
    ret
