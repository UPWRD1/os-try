[org 0x7c00]
    mov bp, 0x8000 ; set the stack safely away from us
    mov sp, bp

    mov bx, MSG_REAL_MODE
    call print ; Written after BIOS

    call switch_to_pm
    jmp $ ; never executed

%include "boot_sect_print.asm"
%include "32bit-gdt.asm"
%include "32bit-print.asm"
%include "32bit-switch.asm"

[bits 32]
BEGIN_PM: ; after switch
    mov ebx, MSG_PROT_MODE
    call print_string_pm ; Written top left
    jmp $

MSG_REAL_MODE db "[INFO] Initializing 16-bit real mode", 0
MSG_PROT_MODE db "[INFO] Loaded 32-bit protected mode", 0

; bootsector
times 510-($-$$) db 0
dw 0xaa55