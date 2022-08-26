rm -rf build
mkdir -p build

arm-none-eabi-g++ -O0 \
	-mcpu=cortex-m0 -march=armv6-m -mlittle-endian \
	-fno-unwind-tables -fno-exceptions \
	-ffreestanding -fno-rtti -fno-threadsafe-statics \
	-nostdlib -nostartfiles \
	-c main.cc -o build/main.o

arm-none-eabi-g++ \
	-Wl,--gc-sections \
	-Wl,-Map,build/test.map,--cref \
	-mcpu=cortex-m0 -march=armv6-m -mlittle-endian \
	-T link.ld \
	-nostdlib -nostartfiles \
	-o build/test.elf build/main.o

arm-none-eabi-size build/test.elf
