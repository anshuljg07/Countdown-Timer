;
; es_s23_lab02.asm
;
; Created: 2/7/2023 11:30:42 AM
; Author : Rafael and Anshul 
;

sbi DDRB,0 ; SRClk
sbi DDRB,1 ; RClk
sbi DDRB,2 ; SER
cbi DDRD,7 ; input button A
cbi DDRD, 6; input button B

.equ zero=0x3f
.equ one=0x06
.equ two=0x5b
.equ three=0x4f
.equ four=0x66
.equ five=0x6d
.equ six=0x7d
.equ seven=0x07
.equ eight=0x7f
.equ nine=0x6f

.equ count = 0 ;initialize count to zero
;clr r21
;di r21, count ; r21 ~ count value

;clr R0
;clr R1
;clr R20
;ldi R0, zero ;load SER hex value in r0
;ldi R1, one ;same ^


; Calculate tens and ones in assembly of decimal value

; Replace with your application code
;set initial values to 0
ldi R16,zero ; set second digit
ldi R18,zero
ldi R19, 0 ; counter
ldi R24, 0 ;sample counter for button A

rcall display ; 



start:
	
	;rcall sampleDelay ;start sample loop (10 ms)
	rcall checkButtonStatus ;check the status of both Pushbutton A and Pushbutton B
	rjmp start

	//then enter function that checks the status of button one and two

	/*
	waitButtonRisingEdge:
	
		sbis PIND,7
		rjmp waitButtonRisingEdge:
		rcall sample; if button loop is exited, then a rising edge is detected so enter a wait for falling edge loop
		
		
			



		rcall buttonPressed ;this function is being called multiple times as fast as possible when the button is pressed.
		;cbi PIND, 7
		;rcall display

		jmp start
	*/

		
		
		 
				 

	; put code here to configure I/O lines ; as output & connected to SN74HC595... 
	; start main program...
	; display a digit 
	;ldi R16,five ; load pattern to display
	;rcall display ; call display subroutine... 
	;rjmp start

/* rafa stupid code
buttonPressed:	
	inc R19;
	rcall changeValue ; rafa's stupid code
	ret
*/

; Subroutine Display displays the set number to the seven segment display
display: 
	push R16
	push R18 ;added rafa
	push R17
	in R17, SREG
	push R17
	ldi R17, 8 ; loop --> test all 8 bits
loop:
	rol R16 ; rotate left trough Carry
	BRCS set_ser_in_1 ; branch if Carry is set; put code here to set SER to 0
	cbi PORTB,2
	rjmp end
set_ser_in_1:
	; set SER to 1
	sbi PORTB,2
end:
	;generate SRCLK pulse
	sbi PORTB,0
	cbi PORTB,0
	dec R17
	brne loop
	; generate RCLK pulse...
	sbi PORTB,1
	cbi PORTB,1
	
	; added rafa ----------------------------------------------------------------------------------
	; do the same for the second digit
	ldi R17, 8 ; loop --> test all 8 bits added rafa
loop1:
	rol R18 ; rotate left trough Carry
	BRCS set_ser_in_2 ; branch if Carry is set; put code here to set SER to 0
	cbi PORTB,2
	rjmp end2
set_ser_in_2:
	; set SER to 1
	sbi PORTB,2

	; added rafa-----------------------------------------------------------------------------

	; restore registers from stack
end2:
	;generate SRCLK pulse
	sbi PORTB,0
	cbi PORTB,0
	dec R17
	brne loop1
	; generate RCLK pulse...
	sbi PORTB,1
	cbi PORTB,1
	
	pop R17
	out SREG, R17
	pop R17
	pop R16
	pop R18 ; addd by rafa
	
	ret 



	;----------------------------------------------------------------------------
;added by rafa count up 

;Added by Anshul to sample the button status every 10 ms ~ 16,000 cycles
;__________________________________________________________________________________
sampleDelay:
	.equ countDelay = 0x0320
	nop
	ldi r30, low(countDelay)	  	; r31:r30  <-- load a 16-bit value into counter register for outer loop 1cc
	ldi r31, high(countDelay); 1cc
d1:
	ldi   r29, 0x20	    	; r29 <-- load a 8-bit value into counter register for inner loop 1cc
d2:
												; no operation 1cc
	dec   r29            		; r29 <-- r29 - 1 1cc
	brne  d2								; branch to d2 if result is not "0" 1cc, else 2cc
	sbiw r31:r30, 1					; r31:r30 <-- r31:r30 - 1 2cc
	brne d1
	inc R24									; branch to d1 if result is not "0" 1cc, else 2cc
	ret				
	

;__________________________________________________________________________________

;Added by Anshul to sample the button status every 10 ms ~ 16,000 cycles
;__________________________________________________________________________________
checkButtonStatus:
	;in r23, PIND ;loads a binary number corresponding to (PD7 (most significant) --> PD0) into the register, PD7 ~ button A, PD6 ~ button B
	;sbrc r23, 7;do sbrc (skip if button not pressed) for PD7 ~ button A
	sbic PIND, 7
	rcall buttonAPressed

	sbic PIND, 6 ;do sbrc (skip if logic  for PD6 ~ button B
	rcall buttonBPressed
	ret
;__________________________________________________________________________________



;Added by Anshul to deal with push button A being pressed
;__________________________________________________________________________________
buttonAPressed:
	rcall numberSamples
	
	cpi r24, 20 ;replace X with a immediate value (number of 10 ms samples in 1 second
	brsh reset;
	inc R19
	rcall changeValue; count this in the sample counter,
	
	ret





;__________________________________________________________________________________


;Added by Anshul to deal with push button B being pressed
;__________________________________________________________________________________
buttonBPressed:
	rcall numberSamples
	ldi r20, 25
	cp r19, r20
	breq startTimer
	jmp start
	

;__________________________________________________________________________________


;Added by Rafa start decrementing timer
;_________________________________________________________________________________
startTimer:
	ldi R16, eight
	ldi R18, eight
	rcall display

;_________________________________________________________________________________
;Added by Anshul to reset the display + counters when pusbutton
;__________________________________________________________________________________

numberSamples:
	rcall sampleDelay ;assuming this waits 10 ms
	;sbrs r23, 7 ;skip if the button A is still pressed
	sbis PIND, 7
	ret
	rjmp numberSamples
;__________________________________________________________________________________

;Added by Anshul to reset the display (currently shows nine nine) and returns to start
;__________________________________________________________________________________
reset:
	ldi R24,0
	ldi R16, nine
	ldi R18, nine
	ldi R19, 0
	rcall display
	jmp start
;__________________________________________________________________________________

changeValue:
	ldi R24,0
	check0: 
		ldi R20, 1
		cp R19, R20
		brne check1

	digit0:
		ldi R16, one
		ldi R18, zero
		;ldi R19, 1  ;replaced with inc R19, then return
		rcall display
		ret

	check1:
		ldi R20, 2
		cp R19, R20
		brne check2

	digit1:
		ldi R16, two
		ldi R18, zero
		;ldi R19, 2 replaced with inc R19, then return
		rcall display
		ret
	
	check2:
		ldi R20, 3
		cp R19, R20
		brne check3

	digit2:
		ldi R16, three
		ldi R18, zero
		;ldi R19, 3 ;replaced with inc R19, then return
		rcall display
		ret

	check3:
		ldi R20, 4
		cp R19, R20
		brne check4

	digit3:
		ldi R16, four
		ldi R18, zero
		;ldi R19, 4 ;replaced with inc R19, then return
		rcall display
		ret

	check4:
		ldi R20, 5
		cp R19, R20
		ret ;should be repalced with brne check5

	digit4:
		ldi R16, five
		ldi R18, five
		;ldi R19, 5 ;replaced with inc R19, then return
		rcall display
		ret

/* rafa old code: start modify 2/12 back from burge
	check0: 
		ldi R20, 0
		cp R19, R20
		breq digit0
		rjmp check1

	digit0:
		ldi R16, one
		ldi R18, zero
		;ldi R19, 1  ;replaced with inc R19, then return
		rcall display
		ret

	check1:
		ldi R20, 1
		cp R19, R20
		breq digit1
		rjmp check2

	digit1:
		ldi R16, two
		ldi R18, zero
		;ldi R19, 2 replaced with inc R19, then return
		rcall display
		ret

	check2:
		ldi R20, 2
		cp R19, R20
		breq digit2
		rjmp check3

	digit2:
		ldi R16, three
		ldi R18, zero
		;ldi R19, 3 ;replaced with inc R19, then return
		rcall display
		ret

	check3:
		ldi R20, 3
		cp R19, R20
		breq digit3
		rjmp check4

	digit3:
		ldi R16, four
		ldi R18, zero
		;ldi R19, 4 ;replaced with inc R19, then return
		rcall display
		ret

	check4:
		ldi R20, 4
		cp R19, R20
		breq digit4
		ret;rjmp check5

	digit4:
		ldi R16, nine
		ldi R18, nine
		;ldi R19, 5 ;replaced with inc R19, then return
		rcall display

*/ ;rafa old before burge
;-----------------------------------------------------------------------------------------------------



/*
digit5:
	ldi R16, six
	ldi R18, zero
	ldi R19, 6
	jmp display

digit6:
	ldi R16, seven
	ldi R18, zero
	ldi R19, 7
	jmp display

digit7:
	ldi R16, eight
	ldi R18, zero
	ldi R19, 8
	jmp display

digit8:
	ldi R16, nine
	ldi R18, zero
	ldi R19, 9
	jmp display

digit9:
	ldi R16, zero
	ldi R18, one
	ldi R19, 10
	jmp display

digit10:
	ldi R16, one
	ldi R18, one
	ldi R19, 11
	jmp display

digit11:
	ldi R16, two
	ldi R18, one
	ldi R19, 12
	jmp display

digit12:
	ldi R16, three
	ldi R18, one
	ldi R19, 13
	jmp display

digit13:
	ldi R16, four
	ldi R18, one
	ldi R19, 14
	jmp display

digit14:
	ldi R16, five
	ldi R18, one
	ldi R19, 15
	jmp display

digit15:
	ldi R16, six
	ldi R18, one
	ldi R19, 16
	jmp display

digit16:
	ldi R16, seven
	ldi R18, one
	ldi R19, 17
	jmp display

digit17:
	ldi R16, eight
	ldi R18, one
	ldi R19, 18
	jmp display

digit18:
	ldi R16, nine
	ldi R18, one
	ldi R19, 19
	jmp display

digit19:
	ldi R16, zero
	ldi R18, two
	ldi R19, 20
	jmp display

digit20:
	ldi R16, one
	ldi R18, two
	ldi R19, 21
	jmp display

digit21:
	ldi R16, two
	ldi R18, two
	ldi R19, 22
	jmp display

digit22:
	ldi R16, three
	ldi R18, two
	ldi R19, 23
	jmp display

digit23:
	ldi R16, four
	ldi R18, two
	ldi R19, 24
	jmp display

digit24:
	ldi R16, five
	ldi R18, two
	ldi R19, 25
	jmp display

	 
;added by rafa
*/

.exit
