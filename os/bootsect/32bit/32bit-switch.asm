[bits 16]
switch_to_pm:
    cli ; Disable interrupts
    lgdt [gdt_descriptor] ; load gdt desc
    mov eax, cr0
    or eax, 0x1 ; set 32bit mode in cr0
    mov cr0, eax
    mov bx, MSG_ENTER_PROT
    call print
    call print_nl

    jmp CODE_SEG:init_pm ; far jump

[bits 32]
init_pm: ; 32 bits now!!!
    mov ebx, MSG_PROT_MODE
    call print_string_pm ; Written top left

    mov ax, DATA_SEG ; update segment registers
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov ebp, 0x90000 ; update stack
    mov esp, ebp

    call BEGIN_PM
    hlt