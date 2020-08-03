;Anton Peeters en Pieter-Jan Steeman

$nolist
$nomod51
$include (c:/reg832.pdf)
$list

stack_init	equ	07fh
		org	0000h
		ljmp	start

start:		mov	sp,#stack_init
		mov	a,#0
		lcall	initlcd
		mov	dptr,#text
		lcall	outmsgalcd
		sjmp	$
einde:		sjmp	einde

text:		db	013h,80h
		db	'\(o.o)/ Anton',0C0h
		db	'Pieter-Jan D:',0
		
$include (c:/aduc800_mideA.inc)
end