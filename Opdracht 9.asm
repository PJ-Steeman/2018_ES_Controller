;Anton Peeters en Pieter-Jan Steeman

$nolist
$nomod51
$include (c:/reg832.pdf)
$list
stack_init	equ	07fh
code1		equ	01111111b

		org	0000h
		ljmp	start

start:		mov	sp,#stack_init
		mov	a,#code1
rechts:		mov	p2,a
		acall	delay
		rr	a
		jb	acc.0,rechts
links:		mov	p2,a
		acall	delay
		rl	a
		jb	acc.7, links
		sjmp 	rechts

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