    [bits 32]
    [extern cmain]
    push ebx
    push eax
    call cmain
    jmp $
