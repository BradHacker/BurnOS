dev:
	nasm -o out/burn.bin src/burn.asm
	qemu-system-x86_64 out/burn.bin

hello:
	as -o out/boot.o hello.s
	ld -o out/hello.bin --oformat binary -e init -Ttext 0x7c00 out/boot.o
	rm out/boot.o
	qemu-system-x86_64 boot.bin
