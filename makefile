# $@ = target file
# $< = first dependency
# $^ = all dependencies

# First rule is the one executed when no parameters are fed to the Makefile
all: run

# Notice how dependencies are built as needed
kernel.bin: kernel_entry.o kernel.o
# ld -o $@ -Ttext 0x1000 $^ --oformat binary
	ld -m elf_i386 -Ttext 0x1000 --oformat binary -o $@ $^

kernel_entry.o: os/bootsect/kernel_entry.asm
	nasm $< -f elf -o $@

kernel.o: os/kernel/kernel.c
	gcc -fno-pic -m32 -ffreestanding -c $< -o $@
	
# Rule to disassemble the kernel - may be useful to debug
kernel.dis: kernel.bin
	ndisasm -b 32 $< > $@

bootsect.bin: os/bootsect/bootsect.asm
	nasm $< -f bin -o $@

os-image.bin: bootsect.bin kernel.bin
	cat $^ > $@

run:
	cargo bootimage
	qemu-system-x86_64 -display curses -drive format=raw,file=/workspaces/os-try/target/x86_64-volumeos/debug/bootimage-os-try.bin,

clean:
	rm *.bin *.o *.dis