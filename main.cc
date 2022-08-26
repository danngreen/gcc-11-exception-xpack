extern "C" void __libc_init_array();

extern "C" void Reset_Handler() { 
	__libc_init_array();
}

// Stubs:
extern "C" void _init() {}
extern "C" void abort() {}
extern "C" void *memcpy(void *dst, const void *src, unsigned n) {
  return nullptr;
}

// Compiling with this commented out creates a ~4kB .text section
// Compiling with this uncommented creates a <200B .text section
char __aeabi_unwind_cpp_pr0[0];
