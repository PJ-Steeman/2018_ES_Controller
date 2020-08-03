;Anton Peeters en Pieter-Jan Steeman

$nolist
$nomod51
$include (c:/reg832.pdf)
$list

stack_init	equ	07fh
		
		org	0000h
		ljmp	start
		org	0003h
		ljmp	int_handler_int0
		
start:		mov	sp,#stack_init
		mov	a,#100
		lcall	subrout1
loop:		jmp	loop
		
subrout1:	setb	it0
		setb	ea
		setb	ex0
		ret
		
int_handler_int0:
		dec	a
		jz	teller
eind_tel:	reti

teller:		dec	p2
		mov	a,#100
		jmp 	eind_tel
		
$include (c:/aduc800_mideA.inc)
end