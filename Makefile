
builddir = build
binaryname = test

linkscript = link.ld
SOURCES = main.cc startup.s 


objdir   = $(builddir)

objects  = $(addprefix $(objdir)/, $(addsuffix .o, $(basename $(SOURCES))))
deps   	= $(addprefix $(objdir)/, $(addsuffix .d, $(basename $(SOURCES))))

mcu =  -mcpu=cortex-m0 -march=armv6-m -mlittle-endian

optflag ?= -O0

aflags = $(mcu)

cflags = -g2 \
		 -fno-common \
		 $(arch_cflags) \
		 $(mcu) \
		 -fdata-sections -ffunction-sections \
		 -fno-unwind-tables \
		 -fno-exceptions \
		 -nostdlib \
		 -nostartfiles \
		 -ffreestanding \

cxxflags = $(cflags) \
		-std=c++20 \
		-fno-rtti \
		-fno-threadsafe-statics \
		-Wall

lflags = -Wl,--gc-sections \
		 -Wl,-Map,$(builddir)/$(binaryname).map,--cref \
		 $(mcu)  \
		 -T $(linkscript) \
		 -nostdlib \
		 -nostartfiles \
		 -ffreestanding \

elf 	= $(builddir)/$(binaryname).elf
hex 	= $(builddir)/$(binaryname).hex
bin 	= $(builddir)/$(binaryname).bin


ARCH 	= /Users/dann/4ms/stm32/xpack-arm-none-eabi-gcc-11.2.1-1.2/bin/arm-none-eabi
# ARCH 	= /Users/dann/4ms/stm32/gcc-arm-none-eabi-10-2021-q1-update/bin/arm-none-eabi
CC 		= $(ARCH)-gcc
CXX 	= $(ARCH)-g++
LD 		= $(ARCH)-g++
AS 		= $(ARCH)-as
OBJCPY 	= $(ARCH)-objcopy
OBJDMP 	= $(ARCH)-objdump
GDB 	= $(ARCH)-gdb
SZ 		= $(ARCH)-size

all: Makefile $(hex) $(elf)

$(objdir)/%.o: %.s
	@mkdir -p $(dir $@)
	$(info BL: Building $< at $(optflag))
	$(AS) $(aflags) $< -o $@ 

$(objdir)/%.o: %.c $(objdir)/%.d
	@mkdir -p $(dir $@)
	$(info BL: Building $< at $(optflag))
	$(CC) -c $(optflag) $(cflags) $< -o $@

$(objdir)/%.o: %.c[cp]* $(objdir)/%.d
	@mkdir -p $(dir $@)
	$(info BL: Building $< at $(optflag))
	$(CXX) -c $(optflag) $(cxxflags) $< -o $@

$(elf): $(objects) $(linkscript)
	$(info BL: Linking...)
	$(LD) $(lflags) -o $@ $(objects) 

%.bin: %.elf
	$(OBJCPY) -O binary $< $@

%.hex: %.elf
	$(OBJCPY) --output-target=ihex $< $@
	$(SZ) -d $(elf)

%.d: ;

clean:
	rm -rf $(builddir)

.PRECIOUS:  $(objects) $(elf)
.PHONY: all clean 

.PHONY: compile_commands
compile_commands:
	compiledb make
	compdb -p ./ list > compile_commands.tmp 2>/dev/null
	rm compile_commands.json
	mv compile_commands.tmp compile_commands.json
