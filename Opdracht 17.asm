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
		mov	p2,#0FFh
		mov	tl0,#64h
		mov	th0,#0c9h
		mov	tmod,#1
		mov	PLLCON,#00h
		setb	TR0
		setb	ea
		setb	et0
loop:		sjmp	loop

int0_rout:	clr	tr0
		mov	tl0,#64h
		mov	th0,#0c9h
		setb	tr0
		dec	p2
		reti

$include (c:/aduc800_mideA.inc)
end