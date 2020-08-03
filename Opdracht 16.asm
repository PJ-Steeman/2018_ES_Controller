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
		lcall	initlcd
		lcall	lcdlighton
		mov	r0,#0
		setb	ex0
		setb	TR0
		setb	ea
		setb	et0
loop:		sjmp	loop

int0_rout:	mov	dptr, #text
		lcall	outmsgalcd
		mov 	p2,th0
		inc	r0
		mov	a,r0
		lcall	outbytelcd
		reti
		

text:		db	80h,013h,0
		
$include (c:/aduc800_mideA.inc)
end