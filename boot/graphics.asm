    ;; some graphics functions for 16-bit real mode
[bits 16]

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

clear_vmem:
    pusha
    mov ax, 0xf000
    mov es, ax
    mov cx, bx
    add cx, 0xd000
write_loop:
    mov byte [es:bx], 0xffff
    add bx, 1                     ; increase mem pointer
    cmp bx, cx            ; check if at the end
    jne write_loop              ; if not more 0's
    popa
    ret

draw_pixel:
    pusha
    mov bx, dx                  ; save the cursor pos
    mov ah, 0x0C                ; draw graphics pixel
    mov al, 0x05                ; color
    mov cl, bl                  ; position in cx:dx
    mov dl, bh
    xor ch, ch                  ; since cursor pos is only 1 bytes
    xor dh, dh                  ; higher bytes will have to be cleared
    mov bh, byte [n_page]
    int 0x10
    popa
    ret

init:
    ;; 0x0d 320x200 16c 8pages A000
    ;; 0x6A +
    pusha
    mov al, 0x0d                ; init graphics mode
    mov ah, 0x00
    int 0x10
;    mov cx, 0x0007              ; fill line 0 - 7
;    mov ah, 0x01                ; set cursor shape
;    int 0x10
    popa
    ret

print_dx:
    push dx
    mov dx, 0x0f01
    call set_cursor_pos
    pop dx
    call print_hex
    ret


set_cursor_pos:                     ; dh = row, dl = column
    pusha
    mov bh, byte [n_page]
    mov ah, 0x02
    int 0x10
    popa
    ret

c_page db 0
n_page db 0                     ;both are 0 so paging is disabled
                                ;
switch_page:                    ;doesn't work, don't know bios
                                ;implementation details
    mov al, byte [c_page]
    mov ah, byte [n_page]
    mov byte [n_page], al
    mov byte [c_page], ah       ;swap current and next page

;    mov ah, 0x05
;    mov al, byte [c_page]      ;switch current displayed page
;    int 0x10

    cmp byte [c_page], 0
    je c_page_clr               ;switch vmem starting point to clear(?)
    mov bx, 0x0
    jmp c_page_clr_end
c_page_clr:
    mov bx, 0x0
c_page_clr_end:

main_loop:
    call clear_vmem

    call print_dx
    call set_cursor_pos
    call draw_pixel
    call input

    call sleep_bios

    jmp main_loop
