[org 0x7c00]
KERNAL_OFFSET equ 0x1000 ; same as linking

    mov [BOOT_DRIVE], dl ; Boot Drive is in dl
    mov bp, 0x9000
    mov sp, bp

    mov bx, MSG_REAL_MODE
    call print ; Written after BIOS
    call print_nl

    call load_kernel ; read kernel from the disk
    call switch_to_pm ; disable interrupts, load GDT, etc
    jmp $ ; never executed

%include "os/bootsect/16bit/boot_sect_print.asm"
%include "os/bootsect/16bit/boot_sect_print_hex.asm"
%include "os/bootsect/16bit/boot_sect_disk.asm"

%include "os/bootsect/32bit/32bit-gdt.asm"
%include "os/bootsect/32bit/32bit-print.asm"
%include "os/bootsect/32bit/32bit-switch.asm"

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print
    call print_nl
    mov bx, KERNAL_OFFSET ; Read from disk and store in 0x1000
    mov dh, 2
    mov dl, [BOOT_DRIVE]
    call disk_load
    ret

[bits 32]
BEGIN_PM: ; after switch
    mov ebx, MSG_PROT_MODE
    call print_string_pm ; Written top left
    call KERNAL_OFFSET ; Give control to the kernel
    jmp $ ; stay if or when the kernel returns


BOOT_DRIVE db 0 ; Store it just in case dl gets overwritten
MSG_REAL_MODE db "[INFO] Initializing 16-bit real mode ", 0
MSG_ENTER_PROT db "[INFO] Entering 32-bit protected mode ", 0
MSG_PROT_MODE db "[INFO] Loaded 32-bit protected mode ", 0
MSG_LOAD_KERNEL db "[INFO] Initializing kernel ", 0


; padding and magic number (!)
times 510-($-$$) db 0
dw 0xaa55