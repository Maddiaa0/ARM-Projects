	AREA	Lotto, CODE, READONLY
	IMPORT	main
	EXPORT	start

	;loop through each one of the tickets to tickets count
	;then match the tickets with the draw, if it is match4, set to true, then match5, set to true and set 4 to 
	;false etc with 6
	;then alter the match things
	;if match < 6
		;if match < 5
			;if match < 4

start
	LDR	R1, =TICKETS

	MOV R2, #0				;ticketCountCounter = 0
	LDR R3, =COUNT			;ticketCount = Memory.word(ticketCount)
	LDR R3, [R3] 		
	
	
ticketCounterLoop
	MOV R4, #0					;numberOfMatches = 0
	CMP R2, R3					;while (ticketCounter <= ticketCount)
	BGE endTicketCounterLoop	;{
	
;there are 6 numbers within the draw	
	LDR R5, =DRAW					;load the draw numbers into the loop
	MOV R7, #0						;ticket2Counter
	
drawLoop
	CMP R7, #6						;while (ticketCounter <= 6)
	BEQ endDrawLoop					;{
	
	MOV R8, #0							;ticketMatch = false
	LDRB R10, [R1]						;drawItem = Memory.Word(drawItem)
	MOV R11, #0							;nextDrawStepper
	
ticketLoop
	CMP R11, #6							;while (drawCounter <=6 && ticketMatch == false)
	BEQ endTicketLoop			
	CMP R8, #1
	BEQ endTicketLoop					;{

	
	LDRB R12, [R5]							;drawItem = Memory.word(drawItem)
	
	CMP R12, R10							;if (ticketItem = drawItem)
	BNE skipIf								;{

	ADD R4, R4, #1								;increase match counter (matchCounter++)
						
skipIf										;}
	
	ADD R5, R5, #1							;get next lottoNumber
	ADD R11, R11, #1						;drawCounter++
	B ticketLoop
	
endTicketLoop							;}

	LDR R5, =DRAW						;reset the draw counter back
	ADD R7, R7, #1						;ticketCounter++
	ADD R1, R1, #1						;get next drawNumber
	B drawLoop 					
	
endDrawLoop							;}

;put in a load of code here to sort the 4-6 etc.
	CMP R4, #6
	BLT compare5
	LDR R7, =MATCH6				;add one to the match 6 counter
	B store
	
compare5
	CMP R4, #5
	BLT compare4
	LDR R7, =MATCH5				;add one to the match 5 counter
	B store
	
compare4
	CMP R4, #4
	BLT skipStore
	LDR R7, =MATCH4				;add one to the match 4 counter
	
store	
	MOV R8, #0					;clear R8
	LDR R8, [R7]
	ADD R8, R8, #1
	STR R8, [R7]

skipStore
	ADD R2, R2, #1				;increase Ticket Counter
	
	B ticketCounterLoop				;repeat for next tickets
	
endTicketCounterLoop



stop	B	stop 



	AREA	TestData, DATA, READWRITE
	
COUNT	DCD	9			; Number of Tickets
TICKETS	DCB	3, 8, 11, 21, 22, 31	; Tickets
		DCB	7, 23, 25, 28, 29, 32
		DCB	10, 11, 12, 22, 26, 30
		DCB	10, 11, 12, 22, 26, 30
		DCB	10, 11, 12, 22, 26, 30
		DCB	10, 11, 18, 22, 26, 30
		DCB	10, 11, 12, 22, 1, 30
		DCB	10, 9, 4, 3, 26, 30
		DCB	10, 2, 1, 22, 26, 30
		
		
		; line 2 DCB	7, 23, 25, 28, 29, 32
	

DRAW	DCB	10, 11, 12, 22, 26, 30	; Lottery Draw

MATCH4	DCD	0
MATCH5	DCD	0
MATCH6	DCD	0

	END	
