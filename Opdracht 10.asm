;Anton Peeters en Pieter-Jan Steeman

$nolist
$nomod51
$include (c:/reg832.pdf)
$list
stack_init	equ	07fh

		org	0000h
		ljmp	start

start:		mov	sp,#stack_init
		mov	dptr,#tabelstart

loop:		mov	a,#0
		movc	a,@a+dptr
		xrl	a,#255
		mov	p2,a
		acall	delay
		inc	dptr
		jnz	loop
		jmp	einde
		
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
		
tabelstart:	db	10h
		db	48h
		db	32h
		db	59h
		db	03h
		db	43h
		db	10h
		db	48h
		db	32h
		db	59h
		db	03h
		db	43h
		db	10h
		db	48h
		db	32h
		db	59h
		db	03h
		db	43h
		db	00h
einde:
end