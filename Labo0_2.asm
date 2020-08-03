;Anton Peeters en Pieter-Jan Steeman

$nolist
$nomod51
$include (c:/reg832.pdf)
$list
stack_init	equ	07fh
code1		equ	11111110b

		org	0000h
		ljmp	start

start:		mov	sp,#stack_init
		mov	a,#code1
opnieuw:	mov	p2,a
		acall	delay
		rr	a
		sjmp 	opnieuw

delay:		push 	acc
		mov 	a,p0
		jnz	delay1
		orl	a,#00000001b
delay1:		mov	r0,#55
delay2:		mov	r1,#55
delay3:		djnz	r1,delay3
		djnz	r0,delay2
		djnz	acc,delay1
		pop	acc
		ret
end
