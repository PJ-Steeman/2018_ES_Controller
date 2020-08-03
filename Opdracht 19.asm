;Anton Peeters en Pieter-Jan Steeman

$nolist
$nomod51
$include (c:/reg832.pdf)
$list

stack_init	equ	07fh
		org	0000h
		
		ljmp	start
		org	000bh
		ljmp	int0_rout
		
start:		mov	sp,#stack_init
		mov	dptr, #seq1
		mov	rcap2l,#0B2h
		mov	rcap2h,#0E4h
		mov	PLLCON,#00h
		setb	TR2
		setb	ea
		setb	et2
		clr	exen2
		mov	r0,#8
loop:		sjmp	loop

int0_rout:	mov	th2,#0E4h
		mov	tl2,#0B2h
		mov	a,#0
		movc	a,@a+dptr
		mov	p2,a
		inc	dptr
		
		push	acc
		dec	r0
		mov	a,r0
		jnz	pjenis
		mov	r0,#8
		mov	dptr, #seq1

pjenis:		pop	acc
		clr	tf2
		reti	
		
seq1:		DB	11111110b
		DB	11111010b
		DB	11111011b
		DB	11111001b
		DB	11111101b
		DB	11110101b
		DB	11110111b
		DB	11110110b

$include (c:/aduc800_mideA.inc)
end