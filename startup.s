/**
  ******************************************************************************
  * @file      startup_stm32f030x6.s
  * @author    MCD Application Team
  * @brief     STM32F030x4/STM32F030x6 devices vector table for GCC toolchain.
  *            This module performs:
  *                - Set the initial SP
  *                - Set the initial PC == Reset_Handler,
  *                - Set the vector table entries with the exceptions ISR address
  *                - Branches to main in the C library (which eventually
  *                  calls main()).
  *            After Reset the Cortex-M0 processor is in Thread mode,
  *            priority is Privileged, and the Stack is set to Main.
  ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; Copyright (c) 2016 STMicroelectronics.
  * All rights reserved.</center></h2>
  *
  * This software component is licensed by ST under BSD 3-Clause license,
  * the "License"; You may not use this file except in compliance with the
  * License. You may obtain a copy of the License at:
  *                        opensource.org/licenses/BSD-3-Clause
  *
  ******************************************************************************
  */

  .syntax unified
  .cpu cortex-m0
  .fpu softvfp
  .thumb

.global g_pfnVectors
.global Default_Handler

/* start address for the initialization values of the .data section.
defined in linker script */
.word _sidata
/* start address for the .data section. defined in linker script */
.word _sdata
/* end address for the .data section. defined in linker script */
.word _edata
/* start address for the .bss section. defined in linker script */
.word _sbss
/* end address for the .bss section. defined in linker script */
.word _ebss

  .section .text.Reset_Handler
  .weak Reset_Handler
  .type Reset_Handler, %function
Reset_Handler:
  ldr   r0, =_estack
  mov   sp, r0          /* set stack pointer */

/* Copy the data segment initializers from flash to SRAM */
  ldr r0, =_sdata
  ldr r1, =_edata
  ldr r2, =_sidata
  movs r3, #0
  b LoopCopyDataInit

CopyDataInit:
  ldr r4, [r2, r3]
  str r4, [r0, r3]
  adds r3, r3, #4

LoopCopyDataInit:
  adds r4, r0, r3
  cmp r4, r1
  bcc CopyDataInit
  
/* Zero fill the bss segment. */
  ldr r2, =_sbss
  ldr r4, =_ebss
  movs r3, #0
  b LoopFillZerobss

FillZerobss:
  str  r3, [r2]
  adds r2, r2, #4

LoopFillZerobss:
  cmp r2, r4
  bcc FillZerobss

/* Call the clock system intitialization function.*/
  /*bl  SystemInit*/
/* Call static constructors */
  bl __libc_init_array
/* Call the application's entry point.*/
  bl main

LoopForever:
    b LoopForever


.size Reset_Handler, .-Reset_Handler

/**
 * @brief  This is the code that gets called when the processor receives an
 *         unexpected interrupt.  This simply enters an infinite loop, preserving
 *         the system state for examination by a debugger.
 *
 * @param  None
 * @retval : None
*/
    .section .text.Default_Handler,"ax",%progbits
Default_Handler:
Infinite_Loop:
  b Infinite_Loop
  .size Default_Handler, .-Default_Handler
/******************************************************************************
*
* The minimal vector table for a Cortex M0.  Note that the proper constructs
* must be placed on this to ensure that it ends up at physical address
* 0x0000.0000.
*
******************************************************************************/
   .section .isr_vector,"a",%progbits
  .type g_pfnVectors, %object
  .size g_pfnVectors, .-g_pfnVectors


g_pfnVectors:
  .word  _estack
  .word  Reset_Handler
  .word  NMI_Handler
  .word  HardFault_Handler
  .word  0
  .word  0
  .word  0
  .word  0
  .word  0
  .word  0
  .word  0
  .word  SVC_Handler
  .word  0
  .word  0
  .word  PendSV_Handler
  .word  SysTick_Handler
  .word IRQ_Trampoline_0		//WWDG_IRQHandler               
  .word 0						//0                             
  .word IRQ_Trampoline_2		//RTC_IRQHandler                
  .word IRQ_Trampoline_3		//FLASH_IRQHandler              
  .word IRQ_Trampoline_4		//RCC_IRQHandler                
  .word IRQ_Trampoline_5		//EXTI0_1_IRQHandler            
  .word IRQ_Trampoline_6		//EXTI2_3_IRQHandler            
  .word IRQ_Trampoline_7		//EXTI4_15_IRQHandler           
  .word 0						//0                             
  .word IRQ_Trampoline_9		//DMA1_Channel1_IRQHandler      
  .word IRQ_Trampoline_10		//DMA1_Channel2_3_IRQHandler    
  .word IRQ_Trampoline_11		//DMA1_Channel4_5_IRQHandler    
  .word IRQ_Trampoline_12		//ADC1_IRQHandler               
  .word IRQ_Trampoline_13		//TIM1_BRK_UP_TRG_COM_IRQHandler
  .word IRQ_Trampoline_14		//TIM1_CC_IRQHandler            
  .word 0						//0                             
  .word IRQ_Trampoline_16		//TIM3_IRQHandler               
  .word 0						//0                             
  .word 0						//0                             
  .word IRQ_Trampoline_19		//TIM14_IRQHandler              
  .word 0						//0                             
  .word IRQ_Trampoline_21		//TIM16_IRQHandler              
  .word IRQ_Trampoline_22		//TIM17_IRQHandler              
  .word IRQ_Trampoline_23		//I2C1_IRQHandler               
  .word 0						//0                             
  .word IRQ_Trampoline_25		//SPI1_IRQHandler               
  .word 0						//0                             
  .word IRQ_Trampoline_27		//USART1_IRQHandler             

/*******************************************************************************
*
* Provide weak aliases for each Exception handler to the Default_Handler.
* As they are weak aliases, any function with the same name will override
* this definition.
*
*******************************************************************************/

  .weak      NMI_Handler
  .thumb_set NMI_Handler,Default_Handler

  .weak      HardFault_Handler
  .thumb_set HardFault_Handler,Default_Handler

  .weak      SVC_Handler
  .thumb_set SVC_Handler,Default_Handler

  .weak      PendSV_Handler
  .thumb_set PendSV_Handler,Default_Handler

  .weak      SysTick_Handler
  .thumb_set SysTick_Handler,Default_Handler

  .weak      IRQ_Trampoline_0
  .thumb_set IRQ_Trampoline_0,Default_Handler
  .weak      IRQ_Trampoline_2
  .thumb_set IRQ_Trampoline_2,Default_Handler
  .weak      IRQ_Trampoline_3
  .thumb_set IRQ_Trampoline_3,Default_Handler
  .weak      IRQ_Trampoline_4
  .thumb_set IRQ_Trampoline_4,Default_Handler
  .weak      IRQ_Trampoline_5
  .thumb_set IRQ_Trampoline_5,Default_Handler
  .weak      IRQ_Trampoline_6
  .thumb_set IRQ_Trampoline_6,Default_Handler
  .weak      IRQ_Trampoline_7
  .thumb_set IRQ_Trampoline_7,Default_Handler
  .weak      IRQ_Trampoline_9
  .thumb_set IRQ_Trampoline_9,Default_Handler
  .weak      IRQ_Trampoline_10
  .thumb_set IRQ_Trampoline_10,Default_Handler
  .weak      IRQ_Trampoline_11
  .thumb_set IRQ_Trampoline_11,Default_Handler
  .weak      IRQ_Trampoline_12
  .thumb_set IRQ_Trampoline_12,Default_Handler
  .weak      IRQ_Trampoline_13
  .thumb_set IRQ_Trampoline_13,Default_Handler
  .weak      IRQ_Trampoline_14
  .thumb_set IRQ_Trampoline_14,Default_Handler
  .weak      IRQ_Trampoline_16
  .thumb_set IRQ_Trampoline_16,Default_Handler
  .weak      IRQ_Trampoline_19
  .thumb_set IRQ_Trampoline_19,Default_Handler
  .weak      IRQ_Trampoline_21
  .thumb_set IRQ_Trampoline_21,Default_Handler
  .weak      IRQ_Trampoline_22
  .thumb_set IRQ_Trampoline_22,Default_Handler
  .weak      IRQ_Trampoline_23
  .thumb_set IRQ_Trampoline_23,Default_Handler
  .weak      IRQ_Trampoline_25
  .thumb_set IRQ_Trampoline_25,Default_Handler
  .weak      IRQ_Trampoline_27
  .thumb_set IRQ_Trampoline_27,Default_Handler
