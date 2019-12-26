[bits 16]
print_keyboard:
    mov ah, 0x00                ; read keyboard blocking
    int 0x16                    ; al = ascii, ah = scan code
    mov byte [char], al         ; only use the ascii code
    mov bx, char
    call print                  ; print(bx)
    cmp al, 'a'
    jne print_keyboard
    call print
    jmp print_keyboard
    ret

char dd 0                       ; 0x0000 0000
                                ; print expects a null terminated
                                ; string, so only the first byte
                                ; is used
