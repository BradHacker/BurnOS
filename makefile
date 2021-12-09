dev32:
	nasm -o out/burn32.bin src/burn_32.asm
	qemu-system-x86_64 -drive file=out/burn32.bin,format=raw

dev:
	nasm -o out/burn.bin src/burn.asm
	qemu-system-x86_64 -drive file=out/burn.bin,format=raw

hello:
	as -o out/boot.o hello.s
	ld -o out/hello.bin --oformat binary -e init -Ttext 0x7c00 out/boot.o
	rm out/boot.o
	qemu-system-x86_64 boot.bin
