;Anton Peeters en Pieter-Jan Steeman

$nolist
$nomod51
$include (c:/reg832.pdf)
$list

stack_init	equ	07fh
		org	0000h
		ljmp	start
		
msB		equ 	31h
lsB		equ	30h

start:		mov	sp,#stack_init
		mov	a,#0
		mov	msB,#00h
		mov     lsB,#00h
		lcall	initlcd
		lcall	lcdlighton
		
loop:		mov	dptr, #text
		lcall	outmsgalcd
		mov	a,msB
		lcall	outniblcd
		mov	a,lsB
		lcall	outbytelcd
		acall	delay
		acall	incr
		sjmp	loop
		
incr:		clr	a
		clr	c
		mov	a,lsB
		inc	a
		da	a
		mov	lsB,a
		mov	a,msB
		addc	a,#0
		da	a
		mov	msB,a
		ret
		
delay:		push 	acc
		mov 	a,p0
		jnz	delay1
		orl	a,#00000001b
delay1:		mov	r0,#20
delay2:		mov	r1,#20
delay3:		djnz	r1,delay3
		djnz	r0,delay2
		djnz	acc,delay1
		pop	acc
		ret
		
text:		db	80h,013h,0
		
$include (c:/aduc800_mideA.inc)
end