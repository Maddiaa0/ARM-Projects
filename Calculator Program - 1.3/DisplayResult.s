	AREA	DisplayResult, CODE, READONLY
	IMPORT	main
	IMPORT	getkey
	IMPORT	sendchar
	EXPORT	start
	PRESERVE8

start

	MOV R2, #0
	MOV R3, #0
	MOV R4, #0 		;initialise the values in R4, R6
	MOV R6, #0
	MOV R5, #0		;where the result is stored
	MOV R7, #0 		;negative flag
	MOV R8, #0		;Store the sign used - 1=+, 2=*, 3=-
	LDR R9, =10		;Store the multipling factor
	
read
	BL	getkey		; read key from console

	CMP	R0, #0x0D  	; while (key != CR)     
	BEQ storeNumber; {	
	BL	sendchar	;   echo key back to console
	
	;check for a sign
	CMP R0, #'+'		;check for the + sign
	BNE checkSignMUL		;if not check for the next sign
	MOV R8, #1			;set the + flag
	B storeNumber		;store the number before the sign
	
checkSignMUL
	CMP R0, #'*'		
	BNE checkSignSUB
	MOV R8, #2
	B storeNumber

checkSignSUB
	CMP R0, #'-'
	BNE inputHandling	;if no sign is input, a number must have been input
	;set a negative flag to store a negative number
	CMP R4, #0			;check if a number has been input, if not then number should be stored negative
	BNE subtraction		;if so its a subtraction
	CMP R7, #1			
	BEQ unsetNegativeFlag		;look for double negatives
	MOV R7, #1			;store negative flag
continueNegativeHandling
	B read
unsetNegativeFlag	
	MOV R7, #0			;unset for double negatives
	B continueNegativeHandling

subtraction 			;set the operator flag to subtraction
	MOV R8, #3
	B storeNumber
	
inputHandling	
	MUL R4, R9, R4	;Multiply the previous value stored in R4 by ten, thus performing a left shift
	SUB R0, R0, #0x30 ;convert the value stored in R0 to a numeric value from ASCII code
	ADD R4, R4, R0	;add the units column onto the result
	
	B	read		





storeNumber
	CMP R7, #1		;check value of the negative flag
	BNE skipNegativeHandler
	RSB R4, R4, #0	;store the negative number
	MOV R7, #0		;reset the negative flag

skipNegativeHandler
	;store number!
	;check the value in register 1 is 0
	CMP R2, #0
	BNE checkReg2
	MOV R2, R4
	MOV R4, #0		;reset the value in R4 once it is stored
	B read
checkReg2
	CMP R3, #0
	MOV R3, R4
	MOV R4, #0		;reset the value in R4 once it is stored
	B endRead
	
endRead
	;check the sign register
	;addition
	CMP R8, #1
	BNE comp2
	ADD R5, R2, R3
	B displayResult
comp2
	;multiplication
	CMP R8, #2
	BNE comp3
	MUL R5, R2, R3
	B displayResult
comp3
	;subtraction
	CMP R8, #3
	SUB R5, R2, R3
	B displayResult


displayResult	
	;show a = sign to the console
	MOV R0, #'='		
	BL sendchar
	
	;check value to output is a negative value
	CMP R5, #0			;if (R5 < 0)
	BGT outputHandler	;{
	RSB R5, R5, #0		;	make positive 
	MOV R0, #'-'		;	output "-"
	BL sendchar			;}
	
outputHandler
	;convert the value stored in R5 to decimal
	MOV R10, R5
convertToDecimal
	
	MOV R0, #0  	;Clear the value of R0
	MOV R6, #0		;used to note when the most significant bit has been passed
	MOV R8, #1		;a counter to hold the power of 10
	MOV R9, #0		;hold the power of ten being divided by
	MOV R12, #10	;the power of ten multiplier
mul10
	CMP R10, R8		;if (R8< R10)
	BLT divStart	;{
	MUL R8, R12, R8	;	R8 = R8 * 10
	ADD R9, R9, #1	;	counter = counter + 1
	B mul10			;}
	

divStart
	MOV R1, #1			;initialise variables to generate the dividing factor
	MOV R2, R1
	MOV R12, #10
findExponent
	CMP R1, R9			;if (current < highest exponent)
	BGT continue		;{
	MUL R2, R12, R2		;	LargestValue = R2 * 10, left shift in base 10
	ADD R1, R1, #1		;	R1 += 1
	B findExponent		;}
	
continue
	BL div					;preform the division to get the current digit for that base
	BL printAndConvert		;print the number to the console
	SUB R9, R9, #1			;decrease the power for the division next time round
	CMP R9, #0				;
	BEQ endPrint			;go to the end
	B divStart				;
			
div
	MOV R11, LR			;store the branch return address in R11
divAc
	CMP R10, R2			;Compare the calculation value with the highest power of 10, ensure it does not overdivide
	BLT divLT			
	SUB R10, R10, R2	;subtract until its less than the multiplier ^^
	ADD R0, R0, #1		;increase the value of the output digit, R0 = R10 / base^n (value of the tens, hundereds etc column)
	B divAc
divLT
	BX R11
	
printAndConvert
	CMP R0, #0			;check if a zero
	BEQ checkMSB
MSBcontinue
	MOV R6, #1			;set the MSB flag
	ADD R0, R0, #0x30	;convert to ascii
	MOV R12, LR
	BL sendchar			;print to console		
	MOV R0, #0			;reset R0
	BX R12
skipPrint
	BX LR
checkMSB
	CMP R6, #0			;check if the MSB has been passed
	BEQ skipPrint		;if not, dont print a digit
	B MSBcontinue		;if so print
	
endPrint 
	MOV R0, R10
	ADD R0, R0, #0x30
	BL sendchar
	
stop	B	stop

	END	