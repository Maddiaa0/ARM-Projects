	AREA	Sudoku, CODE, READONLY
	EXPORT	start

start

	LDR	R3, =gridOne

	;
	; write tests for getSquare subroutine
	;get the value of an item stored at (7,2) on the grid
	MOV R1, #6
	MOV R2, #1
	BL getSquare
	;subroutine tested to be working
	
	;
	; write tests for setSquare subroutine
	
	;NOTE SHOULD THIS SUBROUTINE ONLY MAKE CHANGES TO EMPTY SQUARES?
	;Set the value of a blank square(3,3) to 6
	MOV R0, #2
	MOV R1, #3
	MOV R2, #3
	BL setSquare
	;tested and works as expected!
	

	;
	; write tests for isValid subroutine
	;

	;
	; write tests for sudoku subroutine
	;


stop	B	stop



; getSquare subroutine
;
;A subroutine to get the value of a digit within a specific column and row in the grid
;Parameters:
;	- R1 : Column number
;	- R2 : Row number
;	- R3 : gridOne Array
;
;Return Value:
;	- R0 : the digit value within the square
getSquare	

	STMFD sp!, {R5-R6,lr} 			;//store the variable values on the stack
	
	MOV R6, #9					;rowSize = 9
	MUL R5, R2, R6				;columnPosition = columnNumber * rowSize (find the position of the first item in the array at the defined column
	ADD R5, R5, R3
	LDRB R0, [R5, R1]			;return gridOne[rowNumber, columnNumber] 			

	LDMFD sp!, {R5-R6,pc}
	



; setSquare subroutine
;
;A subroutine to set the value of a square within the suduko grid
;parmeters :
;	R0 : value to be set
;	R1 : column to set
;	R2 : row to set
;	R3 : gridOne Array Location
;
;return Value - void
setSquare
	STMFD sp!, {R5-R6,lr} 	;save variables to the stack
	
	;get the value to set in the array
	MOV R6, #9					;rowSize = 9
	MUL R5, R2, R6				;columnPosition = columnNumber * rowSize (find the position of the first item in the array at the defined column
	ADD R5, R5, R3				;address = gridOne + indexPosition
	STRB R0, [R5, R1]			;gridOneArray[colNumber][rowNumber] = changeValue;

	LDMFD sp!, {R5-R6,pc}	;save methods to the stack
	

; isValid subroutine
;Description
;	-return whether a current configuration of the board is valid
;
;Parameters
;	-
;
;Variables
;	-
isValid
	










;isValidInColumn subroutine
;Description:
;	the idea of this method is to find if there are 
;	duplicate values found within the column of the grid
;
;Parameters:
;	R1 = columnNumber (integer)
;	R2 - rowNumber 	(integer)
;	R3 = gridOne	(array pointer)
;
;Returns:
;	R0 = isValid (boolean)
isValidInColumn				;boolean isValidInColumn(int rowNumber, int columnNumber)
							;{
	STMFD sp!, {R4-R10,lr}
	
	;variable temp values
	MOV R9, R2					;R9 = rowNumber
	
	BL getSquare 				;digitToCompare = gridOneArray[colNumber][rowNumber]
	MOV R5, R0					;R5 = valueToCheck
	
	MOV R6, #9					;rowSize = 9
	ADD R7, R3, R2				;valueToCheckAgainst = memory.address(gridOne) + rowColumn

	MOV R8, #0 					;for (int rowTracker = 0; (rowTracker < 9); rowTracker++)
isValidColumnFor				;{
	CMP R8, #9
	BGT eisValidColumnFor
	CMP R8, R9						;if (rowTracker != rowNumber)
	BEQ eIfRowTracker				;{
	
	ADD R2, R8						
	BL getSquare						;R0 = getSquare(int columber(R1), int rowNumber(R2), int[] gridOneArray(R3))
	MOV R10, R0							;R10 = the currentDigitToCompare, (R0 is the return value from the getSquare function)
	
	CMP R10, R5							;if (digitToCompare == getSquare(rowTracker, columnNumber)
	BNE	eTrueStatement					;{
	
	MOV R0, #0							;return false
	B returnFalse
	
eTrueStatement							;}
eIfRowTracker						;}
	
	ADD R9, R9, #1					;rowTracker++ (from the for statemenr
	B for
eisValidColumnFor				;}
	
	MOV r0, #1						;return true
returnFalse
	LDMFD sp!, {R4-R10,pc}		;}

	

;isValidInRow method
;Description:
;	-the idea of this subroutine like the isValidInColumn subroutine is to return whether the suduko grid has a 
;	valid solution on the screen
;	-called by the isValid subroutine as a way of validating if the board is correct
;	-finds duplicate values within the row of the grid
;
;Parameters:
;	R1 = columnNumber (integer)
;	R2 - rowNumber (integer)
;	R3 = gridOne (array pointer)
;
;Return Value:
;	R0 = isValid (boolean)
;
;Variables
;	R5 - the digit being tracked
;	R9 - column number
;	R10 - the counter to count how many times it has been through the loop
;	R11 - the current digit being compared 
isValidInRow			;boolean isValidInRow(int rowNumber, int colNumber, int[] gridOneArray)
						;{
	STMFD sp!, {R4-R11 ,lr}
	
	;move tmp variables
	MOV R9, R1 				;R9(tmpStore) = columnNumber 
 
	;get the value of the number to check for 
	BL getSquare 				;digitToCompare = gridOneArray[colNumber][rowNumber]
	MOV R5, R0					;R5 = valueToCheck
	
	MOV R6, #9					;rowSize = 9
	MUL R7, R2, R9				;firstRowPosition = R7, (rowNumber x9
	ADD R3, R3, R7				;R3 = Memory.address(firstRowPosition)

forIsValidInRow
	MOV R10, #0					;for(int colTracker =0; (colTracker < 9); colTracker++){
	CMP R10, #9					;{
	BGE eIsValidInRowFor
	
	CMP R9, R10						;if (colTracker!= colNumber){
	BEQ eIsValidInRowIf				;{
	
										;if (digitToCompare == getSquare(rowTracker, columnNumber)){
	MOV R1, R3							;(getSquare(
	BL getSquare
	MOV R11, R0
	CMP R11, R5
	BNE eIsValidInRow
	MOV R0, #0
	B isValidRowFalse
	
	B forIsValidInRow
	
eIsValidInRowIf2
eIsValidInRowIf
eIsValidInRowFor

	MOV R0, #1
isValidRowFalse	
	LDMFD sp!, {,pc}			;restore values
	
	
;isValidSquare 
;Description:
;	-check if a number is unique within its 3x3 square
;	-work out which sqaure a digit is in
;
;Parameters:
;	R1 - Row Number
;	R2 - Column Number
;	R3 - Grid
;
;Return Value:
;	returns true or false
;Variables
;	R4 - startRow (where to start in the 3x3 scan
;	R5 - startCol	(where to start in the 3x3 scan)
;	R6 - the value to be checked
;	R7 -
;	R8 -
;	R9 -
;	R10 -
;	R11 -
; 	R12 -
isValidSquare
	
	STMFD SP!, {R4-R12 ,LR}
	
	MOV R11, R1					;store variables row and column
	MOV R12, R2
	
	MOV R4, #0					;startRow = 0
	MOV R5, #0					;startCol = 0
	
	B getSquare					;getSquare(rowNumber, colNumber, gridOneArray)
	MOV R6, R0			
	
	
	CMP R11, #3					;if (rowNumber < 3){
	BGT elseIfRowNumber6			
	
	MOV R4, #0						;startRow = 0
	B endElseIfRowNumber		;}
elseIfRowNumber6				
	
	CMP R11, #6					;else if (rowNumber < 6){
	BGT elseIfRowNumber9		
	
	MOV R4, #3						;startRow = 3
	B endElseIfRowNumber		;}
elseIfRowNumber9

	CMP R11, #9					;else if (rowNumber < 9){
	BGT endElseIfRowNumber
	
	MOV R4, #6						;startRow = 6
endElseIfRowNumber				;}



	CMP R12, #3					;if (colNumber < 3){
	BGT elseIfColNumber6
		
	MOV R5, #0						;startCol = 0
	B endElseIfColNumber		;}
elseIfRowNumber6
	
	CMP R12, #6					;else if (colNumber < 6){
	BGT elseIfColNumber9	
	
	MOV R5, #3						;startCol = 3
	B endElseIfColNumber		;}
elseIfRowNumber9
	
	CMP R12, #9					;else if (colNumber < 9){
	BGT endElseIfColNumber		
	
	MOV R5, #6						;startCol = 6
endElseIfColNumber				;}


	MOV R7, #0		
	MOV R8, #0
	
	CMP R7, #3					;for ( int boxCounX = 0; boxCount < 3; boxCountX++)
	BGE eForIsValidSquare		;{
	CMP R8, #3						;for (int boxCountY = 0; boxCountY < 3; boxCountY++)
	BGE eForIsValidSquare			;{
	
	ADD R1, R4, R7						
	CMP R1, R11							;if(rowNumber != boxCountX + startRow)
	BEQ eIfForIsValidSquare				;{
	
	ADD R2, R5, R8							
	CMP R2, R12 							;if(colNumber != boxCountY + startCol)
	BEQ eIfIfForIsValidSquare				;{
	
	B getSquare
	CMP R0, R6									;if (getSquare(newRow, newCol, Board) = checkSquare)
	BNE eIfIfIfForIsValidSquare					;{
	
	MOV R0, #0										;return false
	LDMFD sp!, {R4-R12 ,pc}
	
	
eIfIfIfForIsValidSquare							;}
eIfIfForIsValidSquare						;}
eIfForIsValidSquare						;}

	ADD R7, R7, #1
eForForIsValidSquare				;}
	
	ADD R8, R8, #1
eForIsValidSquare				:}
	
	MOV R0, #1					;return true
	LDMFD sp!, {R4-R12 ,pc}	;}
	
	

; sudoku subroutine (boolean sudoku(address grid, word row, word col)
;
;Parameters:
;	R1 - word row
;	R2 - word col
; 	R3 - address grid
;
;Return value:
;	R0:
;
;Variables:
;	R5 - boolean, result of the function
;	R6 - nxtRow
;	R7 - nxtColumn
;	R8 - result for if statments 
;   
;	R11 - row
;	R12 - column

sudoku
	STMFD sp!, {,lr}
	
	MOV R11, R1
	MOV R12, R2

	MOV R5, #0			;boolean result = false
	
						//Precompute the next row and col
	ADD R7, R1, #1		;nxtCol = col + 1	
	MOV R6, R1			;nxtRow = row	
	
	CMP R7, #8			;if (nxtCol > 8)
	BGE eIfnxtColGr8	;{
	MOV R7, #0				;nxtCol = 0
	ADD R6, R6, #1			;nxtRow++
						;}
	
	//save the current arguement variables				
	STMFD sp!, {R0}		;if (getSquare(grid,row,col) != 0) {
	getSquare 			
	//store the result of the AND statement in R8
	MOV R8, R0
	//restore the return value
	LDMFD sp!, {R0}
	CMP R8, #0
	BEQ sudokuElseBranch1
	
	
	CMP R11, #8				;if (row == 8
	BNE sudokuIfBranch1Else1;	&& col == 8) {		

	CMP R12, #8				
	BNE sudokuIfBranch1Else1
	
	//has gotten to the last square
	B returnSudokuTrue			;return true
	
sudokuIfBranch1Else1		;} else {
	//nothing to do here, ust move on to the next square
	
	MOV R1, R6			
	MOV R2, R7
	B sudoku		
	MOV R5, R0 			;result = sudoku(grid, nxtrow, nxtcol)
					;}
					
sudokuElseBranch1 ;else {
	
	MOV R8, #1			//a blank square - try filling it with 1-9
forSudokuElseBranch1	
	CMP R8, #9			; for (byte try = 1; try <= 9 && !result;try++)
	BGE eForSudokuElseBranch1
	CMP R5, #1
	BEQ eForSudokuElseBranch1
	
	//set the pass in variables of the recursive subroutine
	MOV R0, R8		
	MOV R1, R11	
	MOV R2, R12			
	B setSquare				;setSquare(try, row, col, grid)
	
	MOV R1, R11 
	MOV R2, R12
	B isValid
	MOV R9, R0				;if (isValid(row, column, grid)
	CMP R9, #1
	BNE eIfForSudokuElseBranch1
							;{
	CMP R11, #8						;if (row == 8
	BNE eIfIfForSudokuElseBranch1		
	CMP R12, #8							;&& col ==8)
	BNE eIfIfForSudokuElseBranch1	;{
			
	MOV R5, #1							;result = true;
	
eIfIfForSudokuElseBranch1			;} else {
										//move on to the next square
	MOV R1, R6			
	MOV R2, R7
	B sudoku		
	MOV R5, R0 							;result = sudoku(grid, nxtrow, nxtcol)
									;}
eIfForSudokuElseBranch1			;}
	ADD R8, R8, #1
	B forSudokuElseBranch1
	
	CMP R5, #0				;if (!result){
	BNE eIfSudokuElseBranch1	//made an earlier mistake - backtrack 
								//by setting the current square back to 0
	
	MOV R0, #0
	MOV R1, R11
	MOV R2, R12
	B setSquare					;setSquare(grid, row,col,0)
	
eIfSudokuElseBranch1		;}	
eForSudokuElseBranch1	;}
	B returnResult

returnSudokuTrue
	MOV R0, #1
returnResult

	LDMFD sp!, {, pc}


	AREA	Grids, DATA, READWRITE

gridOne
	DCB	7,9,0,0,0,0,3,0,0
   	DCB	0,0,0,0,0,6,9,0,0
   	DCB	8,0,0,0,3,0,0,7,6
  	DCB	0,0,0,0,0,5,0,0,2
   	DCB	0,0,5,4,1,8,7,0,0
	DCB	4,0,0,7,0,0,0,0,0
	DCB	6,1,0,0,9,0,0,0,8
	DCB	0,0,2,3,0,0,0,0,0
    DCB	0,0,9,0,0,0,0,5,4

	END
