dev:
	nasm -o boot_intel.bin boot.asm
	qemu-system-x86_64 boot_intel.bin

att:
	as -o boot.o boot.s
	ld -o boot.bin --oformat binary -e init -Ttext 0x7c00 boot.o
	qemu-system-x86_64 boot.bin
