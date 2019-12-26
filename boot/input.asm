[bits 16]
print_keyboard:
    mov ah, 0x00                ; read keyboard blocking
    int 0x16                    ; al = ascii, ah = scan code
    mov byte [char], ah         ; only use the ascii code
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


input:                          ; nonblocking input NOTE: only one key
    mov ah, 0x01                ; check if key is available
    int 0x16
    jz input_end                ; if not end
    mov ah, 0x00                ; else clear buffer
    int 0x16                    ; and continue
    cmp ah, 0x4b
    je input_left
    cmp ah, 0x4d
    je input_right
    cmp ah, 0x48
    je input_up
    cmp ah, 0x50
    je input_down
    jmp input_unknown
input_left:
    dec dl                      ; dx is used for the cursor pos
    jmp input_end
input_right:
    inc dl
    jmp input_end
input_up:
    dec dh
    jmp input_end
input_down:
    inc dh
    jmp input_end
input_unknown:
    call print_hex
input_end:
    ret
