;Anton Peeters en Pieter-Jan Steeman

$NOLIST
$nomod51
$include(c:/reg832.pdf)
$list

stack_init	equ	07fh
code1		equ 	00001111b
		org 	0000h
		
msB1		equ 	31h
lsB1		equ	30h

msB2		equ	33h
lsB2		equ	32h

msBuit		equ	36h
Buit		equ	35h
lsBuit		equ	34h

		ljmp	start

start:		mov	sp,#stack_init

		mov	msB1,#0ffh
		mov     lsB1,#0ffh
		mov	msB2,#0ffh
		mov	lsB2,#0ffh
		
som:		clr	a
		clr	c
		mov	a,lsB1
		addc	a,lsB2 
		mov	lsBuit,a
		mov	a,msB1
		addc	a,msB2 
		mov	Buit,a
		mov	a,msBuit
		addc	a,#0
		mov	msBuit,a
einde:		sjmp	einde
end