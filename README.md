This is a minimal functioning program that will run on a Cortex-M0. It simply calls __libc_init_array() and then loops. 

1) Set xpack arm-none-eabi-gcc v11.3 to be first in your PATH.

Run ./build.sh

Output:

```
   text    data     bss     dec     hex filename
   4084       0     512    4596    11f4 build/test.elf
```

`build/test.map` reveals that `lib_a-init.o` references symbol `__aebi_unwind_cpp_pr0`, and thus the linker included `unwind-arm.o`. This then causes `libunwind.o` and `pr-support.o` to be included.
This ends up being a little under 4kB of code added to the .text section.

2) Uncomment this line in main.cc:

```
char __aeabi_unwind_cpp_pr0[0];
```

Run ./build.sh

Output:

```
   text    data     bss     dec     hex filename
    136       0     520     656     290 build/test.elf
```

We see the size has shrunk to a reasonable 136 bytes.



