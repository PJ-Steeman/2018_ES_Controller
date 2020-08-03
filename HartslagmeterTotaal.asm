;Anton Peeters & Pieter-Jan Steeman

$nolist
$nomod51
$include (c:/reg832.pdf)
$list

;@====================================================================================@
;@ 										      @
;@ Initialisatie van de flags en variabelen					      @
;@ 										      @
;@====================================================================================@

stack_init	equ	090h
startbuffer	equ	080h
rammsb		equ	071h
ramlsb		equ	070h
teller		equ	072h
dispcount	equ	050h
dispflag	bit	00h
bpmflag		bit	01h
vorige_samplel	equ	051h
vorige_sampleh	equ	052h
periodcountl	equ	053h
periodcounth	equ	054h
refl		equ	055h
refh		equ	056h
periodl		equ	057h
periodh		equ	058h
bpml		equ	059h
bpmh		equ	05ah
		org	0000h
		
		ljmp	start
		org	002bh
		ljmp	int_rout
	
;@====================================================================================@
;@ 										      @
;@ start routine: de eerste routine die uitgevoerd wordt, die initialiseerd alle      @
;@		  timers, displaytekens(barchars), ...				      @
;@ 										      @
;@====================================================================================@	
		
start:		mov	sp,#stack_init			;init van de stack
		mov	pllcon,#0
		mov	r6,#startbuffer			;locatie van de start van de barrel
		mov	r0,#1				;voor lcd init
		mov	dispcount,#10
		clr	bpmflag
		clr	dispflag
		mov	periodcountl,#0
		mov	periodcounth,#0
		mov	refl,#66h
		mov	refh,#06h
		mov	vorige_samplel,#0
		mov	vorige_sampleh,#0
		mov	periodl,#0
		mov	periodh,#0
		mov	bpml,#0
		mov	bpmh,#0
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
		mov	rcap2l,#0b1h			;wacht 5ms
		mov	rcap2h,#0e4h			;wacht 5ms
		mov	t2con,#00000100b	
		
;@====================================================================================@
;@ 										      @
;@ een oneindige lus waarin de BPM wordt berekend, er wordt gekeken of de BAR en de   @
;@ BPM op het scherm getoond moeten woden	      				      @
;@ 										      @
;@====================================================================================@
		
loop:		jnb	dispflag,skiplcd
		clr	dispflag
		lcall	bar				;zet de waardes om naar een barchart
skiplcd:	jnb	bpmflag,skipbpm
		clr	bpmflag
		mov	r0,periodl			;zet in de juiste registers voor mul16
		mov	r1,periodh
		mov	r4,#5
		mov	r5,#0
		lcall	mul16
		mov	bpml,r0				;zet resultaat in bmpl en bpmh
		mov	bpmh,r1
		mov	r0,#060h			;zet in de juiste registers voor div16 --> 60000/bpm
		mov	r1,#0eah
		mov	r4,bpml
		mov	r5,bpmh
		lcall	div16
		mov	r1,#0
		lcall	hexbcd16
		mov	a,#080h
		lcall	outcharlcd
		mov	a,r1
		lcall	outbytelcd
		mov	a,#082h
		lcall	outcharlcd
		mov	a,r0
		lcall	outbytelcd
		mov	dptr,#text
		lcall	outmsgalcd
skipbpm:	sjmp	loop
		
;@====================================================================================@
;@ 										      @
;@ interrupt routine: Deze wordt uitgevoerd om de 5ms via een interrupt van TIMER 2.  @
;@ .78ms										      @
;@====================================================================================@

int_rout:	push	acc
		push	psw
		;setb	p2.0
		clr	rs1	
		clr	tf2
		clr	c	
		lcall	adcbuffer			;adc en buffer toewijzing
		lcall	gemiddelde
		lcall	todac
		mov	r0,periodcountl
		mov	r1,periodcounth
		mov	r4,#1
		mov	r5,#0
		lcall	add16
		mov	periodcountl,r0
		mov	periodcounth,r1
		dec	dispcount
		mov	a,dispcount
		cjne	a,#0,skipdispreset
		mov	dispcount,#10
		setb	dispflag
		
;@====================================================================================@
;@ 										      @
;@ subroutine skipdisreset: slaag de set van de displayflag over en tel het aantal    @
;@		  	    periodes voor er een hartslag is			      @
;@ 										      @
;@====================================================================================@
		
skipdispreset:	mov	r4,refl				;zet in de juiste registers voor cmp16
		mov	r5,refh
		mov	r0,vorige_samplel
		mov	r1,vorige_sampleh
		lcall	cmp16
		jnb	cy,skipref
		mov	r0,ramlsb
		mov	r1,rammsb
		mov	r4,refl
		mov	r5,refh
		lcall	cmp16
		jb	cy,skipref
		mov	periodl,periodcountl
		mov	periodh,periodcounth
		mov	periodcountl,#0
		mov	periodcounth,#0
		setb	bpmflag
skipref:	mov	vorige_samplel,ramlsb
		mov	vorige_sampleh,rammsb
		pop	psw
		pop	acc
		;clr	p2.0
		reti
		
;@====================================================================================@
;@ 										      @
;@ subroutine adcbuffer: Hier wordt het analoge signaal omgezet naar een analoog      @
;@			 signaal een vervolgens in het barrelregister geplaatst	      @
;@ 										      @
;@====================================================================================@
		
adcbuffer:	mov	r0,#00100000b			;initialiseer de nodige waardes voor een 12bit signaal
		lcall	adc_single		
		mov	a,r0				;zet ingelezen waardes in r2 en r3(lsb en msb)
		mov	r2,a
		mov	a,r1
		mov	r3,a
		mov	a,r6
		mov	r0,a
		mov	a,r2
		mov	@r0,a				;zet lsb in barrel
		inc	r0
		mov	a,r3
		mov	@r0,a				;zet msb in barrel
		inc	r0
		mov	a,r0
		anl	a,#08fh				;indien buiten barrelregister zou gaan --> terug naar onder
		mov	r6,a
		ret
		
;@====================================================================================@
;@ 										      @
;@ subroutine todac: Zet het digitale signaal om naar een analoge sinus		      @
;@ 										      @
;@====================================================================================@

todac:		mov	r1,rammsb			;gemiddelde msb in r1
		mov	dac0h,r1			;gemiddelde msb naar DAC
		mov	r0,ramlsb			;gemiddelde lsb in r0
		mov	dac0l,r0			;gemiddelde lsb naar DAC
		ret
		
;@====================================================================================@
;@ 										      @
;@ subroutine bar: Hier worden de ramlsb en rammsb omgezet in een barchar.	      @
;@ 										      @
;@====================================================================================@

bar:		mov	r1,rammsb			;gemiddelde msb in r1
		mov	r0,ramlsb			;gemiddelde lsb in r0
		mov	r5,#0
		mov	r4,#105				;nodig voor div16 (4096/40)
		lcall	div16				;quotient terug in r0
		mov	a,r0
		;lcall	outbytelcd
		mov	r2,a				;zet de waarde om in bars
		mov	r0,#40
		mov	a,#40h
		mov	b,r2
		lcall	barlcd
		ret
		
;@====================================================================================@
;@ 										      @
;@ subroutine gemiddele: Hier wordt het gemiddelde berekend van het circulaire 	      @
;@ register, deze waardes worden opgeslaan in ramlsb en rammsb.			      @
;@ 										      @
;@====================================================================================@
				
gemiddelde:	mov	r7,#startbuffer			;start van de barrel in r7
		mov	teller,#8			;looptiloop init
		mov	r1,#0
		mov	r0,#0
looptiloop:	mov	a,r1
		mov	r3,a
		mov	a,r7
		mov	r1,a
		mov	a,@r1
		mov	r4,a				;lsb in r4
		inc	r1
		mov	a,@r1				;msb in r5
		mov	r5,a
		inc	r1
		mov	a,r1
		mov	r7,a
		mov	a,r3
		mov	r1,a
		lcall	add16				;16 bit opteller
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

;@====================================================================================@
;@ 										      @
;@ database tekst: Deze database bevat de tekst die op het display moet worden gezet. @
;@										      @
;@====================================================================================@
		
text:		db	013h,84h		
		db	' BPM',0

$include (c:/aduc800_mideA.inc)
end