make:
	nasm -fbin boot_main.asm -o boot_main.bin
run:
	qemu-system-x86_64 --nographic --display curses boot_main.bin
