
/* stm32f103rb.ld - minimal linker script for STM32F103RB
 * Flash: 128 KB starting at 0x08000000
 * RAM:   20 KB starting at 0x20000000
 */

MEMORY
{
  FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 128K
  RAM   (rwx): ORIGIN = 0x20000000, LENGTH = 20K
}

/* Sections */
SECTIONS
{
  /* Vector table + code + constants */
  .text :
  {
    KEEP(*(.isr_vector))   /* Interrupt vectors */
    *(.text*)              /* Program code */
    *(.rodata*)            /* Read-only data */
    _etext = .;            /* End of code */
  } > FLASH

  /* Initialized data section (copied from Flash to RAM) */
  .data : AT (ADDR(.text) + SIZEOF(.text))
  {
    _sdata = .;
    *(.data*)              /* Global/static variables with init values */
    _edata = .;
  } > RAM

  /* Zero-initialized data (BSS) */
  .bss :
  {
    _sbss = .;
    *(.bss*)
    *(COMMON)
    _ebss = .;
  } > RAM

  /* Stack top symbol */
  _estack = ORIGIN(RAM) + LENGTH(RAM);

  /* Provide symbols for startup */
  PROVIDE(_etext = .);
  PROVIDE(_sdata = .);
  PROVIDE(_edata = .);
  PROVIDE(_sbss = .);
  PROVIDE(_ebss = .);
}
