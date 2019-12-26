[bits 16]
switch_to_pm:
    cli
    lgdt [gdt_descriptor]

    mov eax, cr0                ; load control register
    or eax, 0x1                 ; set first bit to enable protected mode
    mov cr0, eax

    jmp CODE_SEG:init_protected_mode

[bits 32]

init_protected_mode:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x9000
    mov esp, ebp

    call BEGIN_PM

gdt_start:

gdt_null:
    dd 0x0 ;8 null bytes
    dd 0x0

gdt_code:
    dw 0xffff ;limit 0-15
    dw 0x0    ;base 0-15
    db 0x0    ;base 16-23
    db 10011010b ;1st flags, type flags
    db 11001111b ;2nd flags, limit 16-19
    db 0x0       ;base 24-31

gdt_data:
    dw 0xffff ;limit 0-15
    dw 0x0    ;base 0-15
    db 0x0    ;base 16-23
    db 10010010b ;1st flags type flags
    db 11001111b ;2nd flags limit 16-19
    db 0x0       ;base 24-31

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
