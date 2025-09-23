#include "led.h"
#include "registers.h"

void ledInit() {
  // Open GPIOA clock
  RCC_APB2ENR |= (1 << 2);

  // Reset LED
  GPIOA_BSRR = (LED_PIN << 16);

  // set CNF/MODE TO 0000
  GPIOA_CRL &= ~(0xF << 20);

  // set MODE to OUTPUT
  GPIOA_CRL |= (0x2 << 20);
}
