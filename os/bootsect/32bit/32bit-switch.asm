[bits 16]
switch_to_pm:
    cli ; Disable interrupts
    lgdt [gdt_descriptor] ; load gdt desc
    mov eax, cr0
    or eax, 0x1 ; set 32bit mode in cr0
    mov cr0, eax
    jmp CODE_SEG:init_pm ; far jump

[bits 32]
init_pm: ; 32 bits now!!!
    mov ax, DATA_SEG ; update segment registers
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000 ; update stack
    mov esp, ebp

    call BEGIN_PM