print_hex:
    pusha

iter_hex:
    shr dx, 0x1                 ; shift the adress
    jc bzero                    ; if cf is zero go to z

    shr cl, 1                   ;shift by one

    jmp bzero_end               ;
bzero:
    shr cl, 1
    or cl, 1000b                ;replace shifted 0 with 1
bzero_end:

    dec byte [hex_i]
    cmp byte [hex_i], 0         ; do hex_i times
    jne iter_hex

    and ch, 0
    dec byte [full_hex_i]       ; write to 5,4,3,2
                                ; 1 and 0 are '0x'
                                ; start at 5 otherwise it
                                ; will be backwards
    mov bx, HEX_OUT
    and ax, 0
    mov al, byte [full_hex_i]   ; add index to HEX_OUT address
    add bx, ax

    push bx
    mov bx, hex_chars           ; go to char address
    add bx, cx                  ; add the hex number
    mov al, [bx]                ; refer hex nubmer to chars
    pop bx
    mov [bx], al                ; add char to hex_out

hex_convert_end:
    cmp byte [full_hex_i], 2    ; stop at 2
    jne hex_c2
    jmp hex_c2_end
hex_c2:
    mov byte [hex_i], 4         ; else do another 4 bits
    jmp iter_hex
hex_c2_end:
    mov bx, HEX_OUT
    call print                  ; finally print hex_out!
    mov byte [hex_i], 4
    mov byte [full_hex_i], 6
    popa
    ret

print:
    pusha
    mov ah, 0x0e                ; tty..
print_loop:
    mov al, [bx]                ; get the char
    cmp al, 0                   ; if 0 end
    je print_loop_end
    int 0x10                    ; else print it
    add bx, 0x0001              ; advance the pointer
    jmp print_loop              ; and start again
print_loop_end:
    popa
    ret

hex_i:   db 4
full_hex_i:   db 6
HEX_OUT: db '0x0000', 0
hex_chars: db '0123456789ABCDEF'

[bits 32]
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f
print_pm:
    pusha
    mov edx, VIDEO_MEMORY
print_pm_loop:
    mov al, [ebx]                ; get the char
    mov ah, WHITE_ON_BLACK
    cmp al, 0                   ; if 0 end
    je print_pm_loop_end
    mov [edx], ax
    add ebx, 1              ; advance the pointer
    add edx, 2
    jmp print_pm_loop              ; and start again
print_pm_loop_end:
    popa
    ret
