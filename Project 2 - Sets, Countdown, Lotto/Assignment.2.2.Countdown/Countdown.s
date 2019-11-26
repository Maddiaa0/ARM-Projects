	AREA	Countdown, CODE, READONLY
	IMPORT	main
	EXPORT	start

start
	LDR	R1, =cdWord	; Load start address of word
	LDR	R2, =cdLetters	; Load start address of letters
	
	MOV R0, #1 					;assume that the letters can be formed and try to prove otherwise
	;strings are null terminated, so step through each character until the 0 character is found,
	;when a matching character is found, store the $ sign to show the character has been used, if the string
	;isnt compatible store 0 in R0
	
	
	 
	
	
	
loopcdWordStart
	
	;THIS WAS HIGHER UP
	MOV R8, R2 					;keep a copy of the second loop
	
	LDRB R5, [R1] 				;cdWord = Memory.address[cdWords]
	
	CMP R5, #0					;while (cdWord!=0)
	BEQ endLoopcdWord			;{
	
	LDR R7, =0						;LetterFound = 0
	

loopcdLetterStart
	CMP R6, #0						;while (cdLetter != 0 && !LetterFound)
	BEQ endLoopcdLetter				
	CMP R7, #0
	BNE endLoopcdLetter				;{
	
	LDRB R6, [R8]					;cdLetter = Memory.address[cdLetter]
	MOV R7, #0							;set letterFound to false
	CMP R5, R6							;if (letterReadcdWord(cdWordCounter) == letterReadcdLetters(cdLetterCounter))
	BNE noMatch
	LDR R7, =1							;letterFound = true;
	MOV R10, #'$'
	STRB R10, [R8]						;letterReadcdLetters = '$'

noMatch								;}

	ADD R8, R8, #1					;AddrcdLetters++
	B loopcdLetterStart
endLoopcdLetter
	
	;end if the letter wasnt found
	CMP R7, #0				;if (letterFound == 0)
	BNE skipCompare
	MOV R0, #0				;if the letter isnt found then the word cannot be formed and the program should stop
	B stop
	
skipCompare
	ADD R1, R1, #1			;cdWordAddr++
	B loopcdWordStart
endLoopcdWord
	
	

stop	B	stop

 

	AREA	TestData, DATA, READWRITE
	
cdWord
	DCB	"lady",0

cdLetters
	DCB	"daetebzsb",0
	
	END	
