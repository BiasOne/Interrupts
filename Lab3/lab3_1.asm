.include "ATxmega128a1udef.inc"
;******************************END OF INCLUDES*********************************
.equ stackInit = 0x3FFF
.equ BIT6 = 0x40
.equ BLUE = ~(BIT6)
;
;********************************MAIN PROGRAM**********************************
.cseg
; configure the reset vector 
;	(ignore meaning of "reset vector" for now)
.org 0x0
	rjmp MAIN

.org TCC0_OVF_vect
rjmp ISR
; place main program after interrupt vectors 
;	(ignore meaning of "interrupt vectors" for now)
.org 0x100
MAIN:
ldi r16, low(stackInit)
out CPU_SPL, r16		
ldi r16, high(stackInit)
out CPU_SPH, r16		

ldi r16, 0xFF ;1111 1111
sts PORTC_DIRSET, r16 ;output
sts PORTD_DIRSET, r16 ;output

ldi r16, 0x0F ;clock period L
sts TCC0_PER, r16
ldi r16, 0x1F ;clock period H
sts TCC0_PER+1, r16
ldi r16, TC_CLKSEL_DIV64_gc 

sts TCC0_CTRLA, r16

ldi r16, 0x01 ;interrupt priority 
sts TCC0_INTCTRLA,  r16



sts PMIC_CTRL, r16
sei

END:
rjmp END

ISR:
ldi r16, 0xFF
ldi r17, 1
sts PORTC_OUTTGL, r16
ldi r16, BLUE
sts PORTD_OUTTGL, r16
sts TCC0_INTFLAGS, r17
reti