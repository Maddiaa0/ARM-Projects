	AREA	Sets, CODE, READONLY
	IMPORT	main
	EXPORT	start

start
;loop through each element in set A and find a match in setB, if a match is found, move on to the next item
;if a match is not found, write the item in setC
;do the same for set B, 
;also check within setC? could causing errors printing out the same thing twice
	
	LDR R4, =0			;loopACounter = 0
	LDR R5, =AElems		;addressA = address of A elements
	LDR R6, =ASize		;TMP = address.Asize
	LDR R6, [R6]		;numberInA = Memory.word(TMP)
	LDR R10, =BSize		;TMP = address.Bsize
	LDR R10, [R10]		;numberInB = Memory.word(TMP)
	LDR R2, =CElems		;addressC (For Adding)
	
whileLoopA
	MOV R3, #0			;matchFoundFlag
	
	CMP R4, R6			;while (loopACounter != numberInA)
	BEQ endWhileLoopA	;{
	ADD R4, R4, #1			;loopACounter++
	LDR R7, [R5]			;elemntA = Memory.word(AddressA)
	ADD R5, R5, #4			;AddressA++	(increment to next address)
	LDR R11, =0				;loopBCounter = 0
	LDR R8, =BElems			;addressB 
	MOV R1, #0				;loopCCounter = 0
	LDR R12, =CElems		;addressCChecking
	LDR R0, =CSize			;getSizeofC
	LDR R0, [R0]			
	
whileLoopB
	CMP R11, R10			;while (loopBCounter != numberInB)
	BEQ endWhileLoopB		;{
	LDR R9, [R8]				;elementB = Memory.word(AddressB)
	ADD R8, R8, #4				;AddressB++ (incremenet to next word address)
	ADD R11, R11, #1			;loopBcounter++
	CMP R7, R9					;if (elementA == elementB)
	BNE notEqual				;{
	MOV R3, #1						;matchFoundFlag = true
	B endWhileLoopB				;}
notEqual
	B whileLoopB			;}
endWhileLoopB

whileLoopC	;check the value is not already found within the set
	CMP R1, R0				;while (loopCCounter != numberInC)
	BEQ endWhileLoopC		;{
	LDR R9, [R12]				;elementC = Memory.word(AddressC)
	ADD R12, R12, #4				;AddressC++ (incremenet to next word address)
	ADD R1, R1, #1			;loopCcounter++
	CMP R7, R9					;if (elementA == elementC)
	BNE notEqual2				;{
	MOV R3, #1						;matchFoundFlag = true
	B endWhileLoopC				;}
notEqual2
	B whileLoopC
endWhileLoopC

	CMP R3, #1				;if (matchFound != true)
	BEQ dontPutInC			;{
	LDR R0, =CSize 				;numberInCAdress 
	LDR R1, [R0]				;numberInC = Memory.Word(numberInCAddress)
	ADD R1, R1, #1				;numberInC++
	STR R1, [R0]				;Memory.load(numberInCAddress, numberInC)	
	STR R7, [R2]				;Memory.load(addressC, element A)
	ADD R2, R2, #4				;addressC++ (move to next word)
dontPutInC					;}
	B whileLoopA		;}
endWhileLoopA

;program does the exact same for next
;now do the same for setB
	LDR R4, =0			;loopBCounter = 0
	LDR R5, =BElems		;addressA = address of A elements
	LDR R6, =BSize		;TMP = address.Asize
	LDR R6, [R6]		;numberInB = Memory.word(TMP)
	LDR R10, =ASize		;TMP = address.Bsize
	LDR R10, [R10]		;numberInA = Memory.word(TMP)
	
whileLoopB2
	MOV R3, #0			;matchFoundFlag
	CMP R4, R6			;while (loopACounter != numberInA)
	BEQ endWhileLoopB2	;{
	ADD R4, R4, #1			;loopACounter++
	LDR R7, [R5]			;elemntA = Memory.word(AddressA)
	ADD R5, R5, #4			;AddressA++	(increment to next address)
	LDR R11, =0				;loopBCounter = 0
	LDR R8, =AElems			;addressB 
	MOV R1, #0				;loopCCounter = 0
	LDR R12, =CElems		;addressCChecking
	LDR R0, =CSize			;getSizeofC
	LDR R0, [R0]			
	
whileLoopA2
	CMP R11, R10			;while (loopBCounter != numberInB)
	BEQ endWhileLoopA2		;{
	LDR R9, [R8]				;elementB = Memory.word(AddressB)
	ADD R8, R8, #4				;AddressB++ (incremenet to next word address)
	ADD R11, R11, #1			;loopBcounter++
	CMP R7, R9					;if (elementA == elementB)
	BNE notEqual3				;{
	MOV R3, #1						;matchFoundFlag = true
	B endWhileLoopA2			;}
notEqual3
	B whileLoopA2			;}
endWhileLoopA2

whileLoopC2	;check the value is not already found within the set
	CMP R1, R0				;while (loopCCounter != numberInC)
	BEQ endWhileLoopC2		;{
	LDR R9, [R12]				;elementC = Memory.word(AddressC)
	ADD R12, R12, #4				;AddressC++ (incremenet to next word address)
	ADD R1, R1, #1			;loopCcounter++
	CMP R7, R9					;if (elementA == elementC)
	BNE notEqual4				;{
	MOV R3, #1						;matchFoundFlag = true
	B endWhileLoopC2				;}
notEqual4
	B whileLoopC2
endWhileLoopC2

	CMP R3, #1				;if (matchFound != true)
	BEQ dontPutInC2			;{
	LDR R0, =CSize 				;numberInCAdress 
	LDR R1, [R0]				;numberInC = Memory.Word(numberInCAddress)
	ADD R1, R1, #1				;numberInC++
	STR R1, [R0]				;Memory.load(numberInCAddress, numberInC)	
	STR R7, [R2]				;Memory.load(addressC, element A)
	ADD R2, R2, #4				;addressC++ (move to next word)
dontPutInC2					;}
	B whileLoopB2		;}
endWhileLoopB2

stop	B	stop

	AREA	TestData, DATA, READWRITE
	
ASize	DCD	8			; Number of elements in A
AElems	DCD	4,6,2,13,19,7,1,3	; Elements of A

BSize	DCD	6			; Number of elements in B
BElems	DCD	13,9,1,9,5,8		; Elements of B

CSize	DCD	0			; Number of elements in C
CElems	SPACE	56			; Elements of C

	END	