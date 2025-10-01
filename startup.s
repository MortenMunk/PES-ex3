
/* startup.s - minimal startup for STM32F103RB (Cortex-M3) */

.syntax unified
.cpu cortex-m3
.fpu softvfp
.thumb

/* --------------------------------------------------
 * Vector table (goes at start of flash, 0x08000000)
 * -------------------------------------------------- */
.section .isr_vector, "a", %progbits
.type g_pfnVectors, %object
.size g_pfnVectors, .-g_pfnVectors

g_pfnVectors:
  .word  _estack            /* Initial stack pointer */
  .word  Reset_Handler      /* Reset vector */
  .word  NMI_Handler        /* NMI */
  .word  HardFault_Handler  /* Hard Fault */
  .word  0                  /* MemManage (not used) */
  .word  0                  /* BusFault */
  .word  0                  /* UsageFault */
  .word  0                  /* Reserved */
  .word  0                  /* Reserved */
  .word  0                  /* Reserved */
  .word  0                  /* Reserved */
  .word  SVC_Handler        /* SVCall */
  .word  0                  /* DebugMonitor */
  .word  0                  /* Reserved */
  .word  PendSV_Handler     /* PendSV */
  .word  SysTick_Handler    /* SysTick */

/* --------------------------------------------------
 * Default handlers (weak aliases to Default_Handler)
 * -------------------------------------------------- */
.section .text.Default_Handler, "ax", %progbits
Default_Handler:
  b .

.weak NMI_Handler
.weak HardFault_Handler
.weak SVC_Handler
.weak PendSV_Handler
.weak SysTick_Handler

NMI_Handler:
HardFault_Handler:
SVC_Handler:
PendSV_Handler:
SysTick_Handler:
  b Default_Handler

/* --------------------------------------------------
 * Reset_Handler: set up .data/.bss and jump to main
 * -------------------------------------------------- */
.section .text.Reset_Handler, "ax", %progbits
.global Reset_Handler
.type Reset_Handler, %function
Reset_Handler:
  /* Copy .data from FLASH to SRAM */
  ldr r0, =_sdata
  ldr r1, =_edata
  ldr r2, =_etext
1:
  cmp r0, r1
  ittt lt
  ldrlt r3, [r2], #4
  strlt r3, [r0], #4
  blt 1b

  /* Zero-fill .bss */
  ldr r0, =_sbss
  ldr r1, =_ebss
  movs r2, #0
2:
  cmp r0, r1
  it lt
  strlt r2, [r0], #4
  blt 2b

  /* Call main() */
  bl main

  /* If main returns, loop forever */
  b .
