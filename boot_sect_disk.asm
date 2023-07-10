; load dh sectors from drive dl into ES:BX
disk_load:
    pusha
    ; save parameters for later
    push dx

    mov ah, 0x02 ; ah <- int 0x13 func. 0x02 = read command
    mov al, dh   ; al <- num of sectors to read
    mov cl, 0x02 ; cl <- sector
    ; 0x01 is boot, 0x02 is first available sector

    mov ch, 0x00 ; ch <- cylinder (0x0 .. 0x3FF, upper 2 bits in cl
    ; dl <- drive number
    ; 0 = floppy, 1 = floppy2, 0x80 = hdd, 0x81 = hdd2 ...

    mov dh, 0x00 ; dh <- head number



    int 0x13 ; BIOS interrupt
    jc disk_error ; if error

    pop dx
    cmp al, dh
    jne sectors_error
    popa
    ret


disk_error:
    mov bx, DISK_ERROR
    call print
    call print_nl
    mov dh, ah ; ah = error code, dl = disk drive w/ error
    call print_hex
    jmp disk_loop

sectors_error:
    mov bx, sectors_error
    call print

disk_loop:
    jmp $

DISK_ERROR: db "Bad Disk", 0
SECTORS_ERROR: db "Bad Sector Count", 0