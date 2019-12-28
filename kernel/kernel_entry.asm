    [bits 32]
    [extern cmain]
    mov eax, 0x2badb002
    mov ebx, multiboot_info
    push ebx
    push eax
    call cmain
    jmp $

ALIGN 4
multiboot_info:
multiboot_info_flags:   dd 0
mutliboot_mem_lower:    dd 0
multiboot_mem_upper:    dd 0
multiboot_boot_device:  dd 0
multiboot_cmd_line:     dd 0
multiboot_mods_count:   dd 0
multiboot_mods_addr:    dd 0

multiboot_syms:
multiboot_tabsize:  dd 0
mutliboot_strsize:  dd 0
mutliboot_syms_addr:    dd 0
mutliboot_reserved: dd 0

multiboot_elf_num:  dd 0
multiboot_elf_size:  dd 0
multiboot_elf_addr:  dd 0
multiboot_elf_shndx:  dd 0

multiboot_mmap_length:  dd 0
multiboot_mmap_addr:    dd 0
multiboot_drives_length:    dd 0
mutliboot_drives_addr:  dd 0
multiboot_config_table: dd 0
multiboot_boot_loader_name: dd 0
mutliboot_apm_table:    dd 0
multiboot_vbe_control_info: dd 0
multiboot_vbe_mode_info: dd 1
multiboot_vbe_mode: dw 0
multiboot_vbe_interface_seg: dw 0
multiboot_vbe_interface_off: dw 0
multiboot_vbe_interface_len: dw 0

mutliboot_framebuffer_addr: dq 0
mutliboot_framebuffer_pitch: dd 0
mutliboot_framebuffer_width: dd 12
mutliboot_framebuffer_height: dd 0
mutliboot_framebuffer_bpp: db 0

multiboot_color_info:
multiboot_framebuffer_palette_addr: dd 1
multiboot_framebuffer_palette_num_colors: dd 1

multiboot_framebuffer_red_field_position: db 0
multiboot_framebuffer_red_mask_size: db 0
multiboot_framebuffer_green_field_position: db 0
multiboot_framebuffer_green_mask_size: db 0
multiboot_framebuffer_blue_field_position: db 0
multiboot_framebuffer_blue_mask_size: db 0
