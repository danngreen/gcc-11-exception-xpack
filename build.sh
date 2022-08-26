rm -rf build
mkdir -p build

arm-none-eabi-g++ -O0 -g2 \
	-mcpu=cortex-m0 -march=armv6-m -mlittle-endian \
	-fno-common -fdata-sections -ffunction-sections \
	-fno-unwind-tables -fno-exceptions \
	-ffreestanding -fno-rtti -fno-threadsafe-statics \
	-nostdlib -nostartfiles \
	-Wall \
	-c main.cc -o build/main.o

arm-none-eabi-g++ -O0 -g2 \
	-mcpu=cortex-m0 -march=armv6-m -mlittle-endian \
	-fno-common -fdata-sections -ffunction-sections \
	-fno-unwind-tables -fno-exceptions \
	-ffreestanding -fno-rtti -fno-threadsafe-statics \
	-nostdlib -nostartfiles \
	-Wall \
	-c startup.s -o build/startup.o

arm-none-eabi-g++ \
	-Wl,--gc-sections \
	-Wl,-Map,build/test.map,--cref \
	-mcpu=cortex-m0 -march=armv6-m -mlittle-endian \
	-T link.ld \
	-nostdlib -nostartfiles -ffreestanding  \
	-o build/test.elf build/main.o build/startup.o 
