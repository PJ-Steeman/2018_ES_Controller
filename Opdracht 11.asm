;Anton Peeters en Pieter-Jan Steeman

$nolist
$nomod51
$include (c:/reg832.pdf)
$list

FF1		BIT	00h
FF2		BIT	01h
AND1		BIT	02h
FF3		BIT	03h
AND2		BIT	04h

stack_init	equ	07fh

		org	0000h
		ljmp	start

start:		mov	sp,#stack_init
		mov	a,#0
		mov	r2,#255
		
loop:		acall	flankdetector
		jnb	AND2,noteql
		acall	teller
		
noteql:		acall	delay
		jmp	loop
		
flankdetector:	mov	c,FF3
		cpl	c
		anl	c,AND1
		mov	AND2,c
		
		mov	c,AND1
		mov	FF3,c
		
		mov	c,FF1
		anl	c,FF2
		mov	AND1,c
		
		mov	c,FF1
		mov	FF2,c
		mov	c,p3.7
		cpl	c
		mov	FF1,c
		ret
		
teller:		dec	r2
		mov	p2,r2
		ret
		
delay:		push 	acc
		mov 	a,p0
		jnz	delay1
		orl	a,#00000001b
delay1:		mov	r5,#1
delay2:		mov	r6,#1
delay3:		djnz	r6,delay3
		djnz	r5,delay2
		djnz	acc,delay1
		pop	acc
		ret
end