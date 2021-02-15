.include "ATxmega128a1udef.inc"
;******************************END OF INCLUDES*********************************
.equ stackInit = 0x3FFF
.equ BIT6 = 0x40
.equ BLUE = ~(BIT6)
.equ count = 255
;
;********************************MAIN PROGRAM**********************************
.cseg
; configure the reset vector 
;	(ignore meaning of "reset vector" for now)
.org 0x0
	rjmp MAIN

.org PORTF_INT0_vect
rjmp ISR
; place main program after interrupt vectors 
;	(ignore meaning of "interrupt vectors" for now)
.org 0x100
MAIN:
ldi r25, count

ldi r16, low(stackInit)
out CPU_SPL, r16		
ldi r16, high(stackInit)
out CPU_SPH, r16		

ldi r16, 0xFF ;1111 1111
;sts PORTC_OUT, r16
sts PORTC_DIRSET, r16 ;output

ldi r16, 0b01000000
sts PORTD_DIRSET, r16 ;output

ldi r16, 4
sts PORTF_DIRCLR, r16 ;input 
sts PORTF_INT0MASK, r16 ;button that causes the interrupt
l;sts PORTF_PIN0CTRL, 2 <-- pull up or pull down 

;ldi r16, 0x50 ;clock period L
;sts TCC0_PER, r16
;ldi r16, 0xC3 ;clock period H
;sts TCC0_PER+1, r16

;ldi r16, TC_CLKSEL_DIV8_gc 
;sts TCC0_CTRLA, r16

ldi r16, 0x01 ;interrupt priority 
;sts TCC0_INTCTRLA,  r16
sts PORTF_INTCTRL, r16


sts PMIC_CTRL, r16
sei

END:
rjmp END

ISR:
dec r25
ldi r17, 1
ldi r16, BLUE
sts PORTC_OUT, r25
sts PORTD_OUTTGL, r16
sts PORTD_INTFLAGS, r17
reti