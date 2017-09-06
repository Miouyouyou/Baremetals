PREFIX=armv7a-hardfloat-linux-gnueabi-
AS=${PREFIX}as
CC=${PREFIX}gcc
LD=${PREFIX}ld
OBJCOPY=${PREFIX}objcopy

.PHONY: all
all:
	${AS} print_uart.S -o UPrint.o
	${LD} -T Test.map UPrint.o -o UPrint.elf
	${OBJCOPY} -O binary UPrint.elf UPrint.bin

.PHONY: test_debug
test_debug:
	qemu-system-arm -M versatilepb -m 128M -nographic -s -S -kernel UPrint.bin

.PHONY: test
test:
	qemu-system-arm -M versatilepb -m 128M -nographic -kernel UPrint.bin
