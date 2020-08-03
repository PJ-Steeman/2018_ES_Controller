;Anton Peeters en Pieter-Jan Steeman

$NOLIST
$nomod51
$INCLUDE (c:/reg832.pdf)
$LIST

stack_init	equ	07fh

		org	0000h
		ljmp	start

start:		mov	sp,#stack_init
opnieuw:	mov	p2,#0ffh
teller:		lcall	delay
		dec	p2
		jmp 	teller

delay:		mov	a,#10
delay1:		mov	r0,#10
delay2:		mov	r1,#10
delay3:		djnz	r1,delay3
		djnz	r0,delay2
		djnz	acc,delay1
		ret
end
