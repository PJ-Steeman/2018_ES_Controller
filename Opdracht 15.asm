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
		setb	ex0
		setb	TR0
		setb	ea
		setb	et0
loop:		jmp	loop

int0_rout:	mov 	p2,th0
eind_tel:	reti
		
$include (c:/aduc800_mideA.inc)
end