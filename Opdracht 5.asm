;Anton Peeters en Pieter-Jan Steeman

$NOLIST
$nomod51
$include(c:/reg832.pdf)
$list

stack_init	equ	07fh
code1		equ 	00001111b
		org 	0000h
		
msB		equ 	31h
lsB		equ	30h
		ljmp	start

start:		mov	sp,#stack_init
		mov	lsB,#9ah
		mov	msB,#7bh
som:		clr	a
		mov 	a,lsB
		clr	c
		rlc	a
		mov	lsB,a
		mov	a,msB
		rlc	a
		mov 	msB,a
einde:		sjmp	einde
end