;Anton Peeters & Pieter-Jan Steeman

$nolist
$nomod51
$include (c:/reg832.pdf)
$list

stack_init	equ	090h
startbuffer	equ	080h
rammsb		equ	071h
ramlsb		equ	070h
teller		equ	072h
		org	0000h
		
		ljmp	start
		org	002bh
		ljmp	int_rout
		
start:		mov	sp,#stack_init		;init van de stack
		mov	pllcon,#0
		mov	r6,#startbuffer		;locatie van de start van de barrel
		mov	r0,#1			;voor lcd init
		lcall	initlcd
		lcall	lcdlighton
			
		lcall 	adc_init	
		mov	daccon,#00011101b
		
		setb	rs1
		
		mov	dptr,#barchars
		lcall	build
		
		setb	ea
		setb	et2
		
		mov	tl2,#0b1h
		mov	th2,#0e4h
		mov	rcap2l,#0b1h		;wacht 5ms
		mov	rcap2h,#0e4h		;wacht 5ms
		mov	t2con,#00000100b
		
loop:		;doe een context switch naar een andere registerbank, zodat het scherm niet flipt.
		lcall	bar			;zet de waardes om naar een barchart
		sjmp	loop
		
int_rout:	push	acc
		push	psw
		clr	rs1	
		clr	tf2	
		lcall	adcbuffer		;adc en buffer toewijzing
		lcall	gemiddelde
		lcall	todac	
		cpl	p2.0
		pop	psw
		pop	acc
		reti
		
adcbuffer:	mov	r0,#00100111b		;initialiseer de nodige waardes voor een 12bit signaal
		lcall	adc_single		
		mov	a,r0			;zet ingelezen waardes in r2 en r3(lsb en msb)
		mov	r2,a
		mov	a,r1
		mov	r3,a
		mov	a,r6
		mov	r0,a
		mov	a,r2
		mov	@r0,a			;zet lsb in barrel
		inc	r0
		mov	a,r3
		mov	@r0,a			;zet msb in barrel
		inc	r0
		mov	a,r0
		anl	a,#08fh			;indien buiten barrelregister zou gaan -> terug naar onder
		mov	r6,a
		ret

todac:		mov	r1,rammsb			;gemiddelde msb in r1
		mov	dac0h,r1		;gemiddelde msb naar DAC
		mov	r0,ramlsb			;gemiddelde lsb in r0
		mov	dac0l,r0		;gemiddelde lsb naar DAC
		ret
	
bar:		mov	r1,rammsb			;gemiddelde msb in r1
		mov	r0,ramlsb			;gemiddelde lsb in r0
		mov	r5,#0
		mov	r4,#105			;nodig voor div16 (4096/40)
		lcall	div16			;quotient terug in r0
		mov	a,r0
		;lcall	outbytelcd
		mov	r2,a			;zet de waarde om in bars
		mov	r0,#40
		mov	a,#40h
		mov	b,r2
		lcall	barlcd
		ret
				
gemiddelde:	mov	r7,#startbuffer		;start van de barrel in r7
		mov	teller,#8			;looptiloop init
		mov	r1,#0
		mov	r0,#0
looptiloop:	mov	a,r1
		mov	r3,a
		mov	a,r7
		mov	r1,a
		mov	a,@r1
		mov	r4,a			;lsb in r4
		inc	r1
		mov	a,@r1			;msb in r5
		mov	r5,a
		inc	r1
		mov	a,r1
		mov	r7,a
		mov	a,r3
		mov	r1,a
		lcall	add16			;16 bit opteller
		mov	a,teller
		dec	a
		mov	teller,a
		jnz	looptiloop
		mov	r5,#0
		mov	r4,#8
		lcall	div16
		mov	ramlsb,r0			;lsb in RAM
		mov	rammsb,r1			;msb in RAM
		ret	

$include (c:/aduc800_mideA.inc)
end