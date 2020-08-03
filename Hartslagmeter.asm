;Anton Peeters & Pieter-Jan Steeman

$nolist
$nomod51
$include (c:/reg832.pdf)
$list

stack_init	equ	090h
tijd		equ	1
startbuffer	equ	080h
		org	0000h
		
		ljmp	start
		
start:		mov	sp,#stack_init		;init van de stack
		mov	r6,#startbuffer		;locatie van de start van de barrel
		mov	r0,#1			;voor lcd init
		lcall	initlcd
		lcall	lcdlighton
			
		lcall 	adc_init	
		mov	daccon,#00011101b
		
		mov	dptr,#barchars
		lcall	build
		
infloop:	lcall	adcbuffer		;adc en buffer toewijzing
		lcall	bar			;zet de waardes om naar een barchart
		mov	dptr,#tijd		;zet de gewenste delay in de dptr
		lcall	wait_sel_ms		;wacht het gekozen aantal miliseconden
		sjmp	infloop			;oneindige lus
		
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
		
bar:		mov	a,r6				
		cjne	a,#80h,skip_add		;indien je onderaan het barrelregister zit ga terug naar boven
		add	a,#10h
skip_add:	dec	a			;ga naar de plaats van de msb
		mov	r1,a
		mov	r0,a
		mov	a,@r1			;zet de msb in r1
		mov	r1,a
		mov	dac0h,r1		;msb naar DAC
		dec	r0			;ga naar de plaats van de lsb
		mov	a,@r0			;zet de lsb in r0
		mov	r0,a
		mov	dac0l,r0		;lsb naar DAC
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
	
wait_sel_ms:	mov	a,#0
		clr 	c
		subb 	a,dpl
		mov	dpl,a
		mov	a,#0
		subb	a,dph
		mov	dph,a
wait_1ms:	clr	a
		inc	dptr
		mov	a,#199
delay:		mov	r0,a
		mov	a,r0
		mov	r0,a
		mov	a,r0
		subb	a,#1
		jnz	delay
		mov	a,dpl
		jnz	wait_1ms
		mov	a,dph
		jnz	wait_1ms
		ret		

$include (c:/aduc800_mideA.inc)
end