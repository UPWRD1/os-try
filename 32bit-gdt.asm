gdt_start:
    ; null 8-byte
    dd 0x0 ; 4 byte
    dd 0x0 ; 4 byte

gdt_code:
    dw 0xffff    ; segment length
    dw 0x0       ; segment base 0-15
    db 0x0       ; segment base 16-23
    db 10011010b ; flags (8 bits)
    db 11001111b ; flags (4 bits) + seg len, bits 16-19
    db 0x0       ; segment base, bits 24-31

gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0

gdt_end:

; GDT descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; size (16 bit), one less
    dd gdt_start ; address (32bit)

; constants
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start