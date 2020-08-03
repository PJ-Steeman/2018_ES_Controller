;Anton Peeters en Pieter-Jan Steeman

$NOLIST
$nomod51
$include(c:/reg832.pdf)
$list

stack_init	equ	07fh
mask		equ 	00001111b
tijd		equ	200
		org 	0000h
		
		ljmp	start
		
start:		mov	sp,#stack_init
		mov	dptr,#tijd
		lcall	wait_ms		
		sjmp	einde
		
wait_ms:	mov	a,#0
		clr 	c
		subb 	a,dpl
		mov	dpl,a
		mov	a,#0
		subb	a,dph
		mov	dph,a
wait_1ms:	clr	a
		inc	dptr
		mov	a,#199
muney:		mov	r0,a
		mov	a,r0
		mov	r0,a
		mov	a,r0
		subb	a,#1
		jnz	muney
		mov	a,dpl
		jnz	wait_1ms
		mov	a,dph
		jnz	wait_1ms
		ret
einde:		
end