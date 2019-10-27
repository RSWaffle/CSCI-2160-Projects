;******************************************************************************************
;*  Program Name: proj4procs.asm
;*  Programmer:   Ryan Shupe
;*  Class:        CSCI 2160-001
;*  Lab:          Proj3
;*  Date:         11/02/2019
;*  Purpose:      This handles the manipulation of matrices. 
;******************************************************************************************

	.486						;This tells assembler to generate 32-bit code

	.model flat					;This tells assembler that all addresses are real addresses

	.stack 100h					;EVERY program needs to have a stack allocated

;******************************************************************************************

;  List all necessary prototypes for methods to be called here

	ascint32 PROTO NEAR32 stdcall, lpStringToConvert:dword  				;This converts ASCII characters to the dword value
	intasc32 proto Near32 stdcall, lpStringToHold:dword, dval:dword			;converts ints to ascii
	putstring  PROTO NEAR stdcall, lpStringToDisplay:dword  				;Will display ;characters until the NULL character is found
	sortedArray PROTO Near32 C, lpArrayDwords:dword, numElts:dword			;returns 1 if the array passed in is sorted in ascending order
	smallestValue PROTO Near32 C, lpArrayDwords:dword, rows:dword, cols:dword ;returns the smallest value in an array	
	displayArray PROTO Near32 C, lpArrayDwords:dword, rows:dword, cols:dword, ;converts an array passed in into ascii and formatting for display	
	lpStringtoHold:dword
;******************************************************************************************
COMMENT %

******************************************************************************
*Name: DisplayString                                                         *
*Purpose:                                                                    *
*	The purpose of this macro is to display a set of strings to the console  *
*                                                                            *
*Date Created: 10/02/2019                                                    *
*Date Modified: 10/02/2019                                                   *
*                                                                            *
*                                                                            *
*@param String1:byte                                                         *
*****************************************************************************%
DisplayString MACRO String:REQ

	INVOKE putstring, ADDR String    				;;display The string passed in 

ENDM

COMMENT %

******************************************************************************
*Name: getBytes                                                              *
*Purpose:                                                                    *
*	  Intakes an address and counts the number of bytes into a string including*
*     the null char and returns the number.                                  *
*Date Created: 10/24/2019                                                    *
*Date Modified: 10/25/2019                                                   *
*                                                                            *
*                                                                            *
*@param String1:byte                                                         *
*****************************************************************************%
getBytes MACRO String:REQ
	LOCAL stLoop
	LOCAL done
	PUSH EBP							;preserves base register
	MOV EBP, ESP						;sets a new stack frame
	PUSH EBX							;pushes EBX to the stack to store this
	PUSH ESI							;pushes ESI to the stack to preseve
	MOV EBX, String						;moves into ebx the first val in the stack that we are going to use
	MOV ESI, 0							;sets the initial point to 0
		
	stLoop:
		CMP byte ptr [EBX + ESI], 0		;compares the two positions to determine if this is the end of the string
		JE done							;if it is jump to finished
		INC ESI							;if not increment esi
		JMP stLoop						;jump to the top of the loop and look at the next char
	done:		
		INC ESI							;increment esi to include the null character in the string
		MOV EAX, ESI					;move the value of esi into eax for proper output and return
	
	POP ESI								;restore original esi
	POP EBX								;restore original ebx
	POP EBP								;restore originla ebp
ENDM
;******************************************************************************************
.DATA

	WhiteListChars byte 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 45, 43		;set of whitelisted characters, 0 1 2 3 4 5 6 7 8 9 + - 
	crlf byte  10,13,0														;Null-terminated string to skip to new line
	strSortAlready byte 10,10,13, "!!! The data is already sorted !!!",0
	strSortComplete byte 10,10,13, "Sort Complete!",0
	tempNum dword 0 dup (12)												;memory to hold a temp number that is built
	bNumBytes byte ?														;memory to hold the number of bytes in a string
	iColCount dword 0														;memory to keep track of the col count
	tempSelectionSortASCII dword 100 dup(0), 00								;memory to hold the string generated in ascii
	bTemps byte 0 dup(?)													;memory to hold the number that is built in extractDwords
	


;******************************************************************************************
.CODE

COMMENT %
********************************************************************************
*Name: extractDwords                                                           *
*Purpose:                                                                      *
*	     This method takes in two addresses, one with ascii characters and one *
*        where the converted numbers will go. It translates the ascii character*
*		 to the dword value and stores into the output location    			   *
*Date Created: 10/23/2019                                                      *
*Date Modified: 10/23/2019                                                     *
*                                                                              *
*                                                                              *
*@param StringofChars:dword                                                    *
*@param ArrayDwords:dword												 	   *
*******************************************************************************%
extractDwords PROC Near32 C uses EBX ECX EDX EDI , StringofChars:dword, ArrayDwords:dword
	LOCAL addOut:dword, addASCII:dword			;sets up our stack frame and declares our local variables. 
	
	MOV EAX, ArrayDwords						;moves into EAX the address of the output array
	MOV addOut, EAX								;moves the address into our local variable for clarity.
	MOV EAX, StringofChars						;moves into EAX the address of the array with ascii values.
	MOV addASCII, EAX							;moves the address into our local variable for clarity.
	
	MOV EBX, 0									;set EBX to 0 to avoid calculation error
	MOV EDI, 0									;sets our initial point in bTemps to the first place
	
	lpConvertandMove:	
		MOV EAX, addASCII						;moves the address of the ascii values into eax so we can reference it
		MOV BL, byte ptr [EAX]					;moves into BL the byte at the address position
		CMP BL, 00								;compares this byte to 00 to test if we are at the end of the array
		JE finished								;if it is equal to 00, then jump to the finished label. 
		
		MOV ECX, lengthof WhiteListChars		;sets up our loop with the number of elements in the whitelisted characters array
		MOV ESI, 0								;sets our initial position in the whitelisted characters array to 0
		
		lpCompareWhitelist:
			CMP BL, WhiteListChars[ESI]			;compares bl to see if it is one of the whitelisted characters
			JE ValidChar						;if it is a valid char, jump to the valid section
			INC ESI								;increment esi to the next position in the whitelisted characters array
		loop lpCompareWhitelist					;decrement ecx and loop back up
												;if it is not a valid char this executes:
		INC addASCII							;increment addASCII so we get the next byte
		JMP lpConvertandMove					;jump back up to the top to start the loop over again
		
		ValidChar:
			MOV bTemps[EDI], BL					;Moves into btemps at position edi the byte in bl to hold that byte of the number that is building
			INC addASCII						;increment to the next position of addascii so we can see if the next char is valid
			MOV EAX, addASCII					;moves into eax the new address of the next byte 
			MOV BL, byte ptr [EAX]				;moves the byte into Bl 
			DEC addASCII						;change it back to the previous character
			
			MOV ECX, lengthof WhiteListChars	;adds the number of elements in whitelisted characters array into ecx for the loop
			MOV ESI, 0							;sets our initial position in the whitelisted characters array to 0
		
			lpCompareNext:
				CMP BL, WhiteListChars[ESI]		;This compares the next byte to see if it is whitelisted too
				JE ValidNextChar				;if it is a valid character, jump to the valid next char section
				INC ESI							;increment esi if it is not valid to get to the next position in whitelisted characters
			loop lpCompareNext					;decrement ECX and go to the top of the current loop
			
			INVOKE ascint32, ADDR bTemps		;if it is not a valid character, then we know the number is complete and we can execute asc to int conversion
			MOV EDX, addOut						;moves the address of the output array into edx so we can reference it
			MOV [EDX], EAX						;moves the resulting EAX value into the output array at the correct position
			MOV ECX, 4							;imputs 4 into ECX so we can clear our bTemps variable to prevent curruption
			lpClearBTemp:
				MOV [bTemps + ECX], 0			;moves 0 into the slot ECX of bTemps
			loop  lpClearBTemp					;jump back to the top of the current loop
			ADD addOut, 4						;adds 4 to the output address so we can get the next dword starting point
			MOV EDI, 0							;resets edi to 0 so we get a clean bTemps variable
			INC addASCII						;increments addASCII so we get the next byte in memory
			JMP lpConvertandMove				;jump back up to the very top of the loop 
			
		ValidNextChar:
			INC EDI								;increment edi so we can input in the next position in bTemps
			INC addASCII						;increment addASCII so we get the next byte in memory
			JMP lpConvertandMove				;jump back up to the very top of the loop
			
			
	finished:
		RET										;return back to where i was called 
extractDwords ENDP 

COMMENT %
********************************************************************************
*Name: displayArray                                                            *
*Purpose:                                                                      *
*	      Intakes beginning address of dwords and converts it into the appropriate*
*        matrix display for output and returns the address to the string 	   *
*		 generated.															   *
*		     			   													   *
*Date Created: 10/24/2019                                                      *
*Date Modified: 10/25/2019                                                     *
*                                                                              *
*                                                                              *
*@param lpArrayDwords:dword                                                    *
*@param rows:dword												 	           *
*@param cols:dword												 	           *
*@param lpStringtoHold:dword									 	           *
*******************************************************************************%
displayArray PROC Near32 C uses EBX EDX EDI, lpArrayDwords:dword, rows:dword, cols:dword, lpStringtoHold:dword
	LOCAL startAddr:dword, outAddr:dword, tempNumRow:dword, tempNumCol:dword
	MOV EAX, rows								;moves the number of rows into eax so we can check if it is a 1xM later
	MOV tempNumRow, EAX							;moves the row number into a temp variable for later
	MOV EAX, cols								;moves the number of cols into eax so we can check if it is a 1xM later
	MOV tempNumCol, EAX							;store the col number into a temp variable
	MOV EAX, lpArrayDwords						;moves into EAX the address of the output array
	MOV startAddr, EAX							;moves the address into our local variable for clarity.
	MOV EAX, lpStringtoHold						;moves into EAX the address of the array with ascii values.
	MOV outAddr, EAX							;moves the address into our local variable for clarity.

	
	MOV EDI, 0									;set the initial point into the original address to 0
	MOV ESI, 0									;set the initial point into the new address to 0
	MOV ECX, 1									;set ecx to 1 because we start with 1 col
	MOV EDX, outAddr							;moves the address of out address to edx so we can derefrence the address
	MOV EBX, startAddr							;moves the address of out address to edx so we can derefrence the address
	
	MOV tempNum, 09								;set the temp number to the tab character
	MOV EBX, EDX								;moves the address of out address into ebx so we can use it to put the character
	PUSH EBX									;store ebx so we can have the unaffected value later
	ADD EBX, ESI								;adds into ebx the offset of ebx esi, so we get the correct byte to place a character
	PUSH EAX									;preserve EAX so we can restore it later
	MOV EAX, tempNum							;move into eax the temp number which is tab
	MOV [EBX], EAX								;moves into the location ebx points to the temp number 
	POP EBX										;restore our unaffected EBX
	getBytes EDX								;call the get bytes macro where we count the number of bytes used in the output address
	MOV ESI, EAX								;moves into ESI the offset that the previous macro returns
	DEC ESI										;decrement ESI to take into acount the null character the macro counts for.
	
	PUSH EAX									;preserve EAX so we can restore it later
	MOV EAX, rows								;moves into eax the number of rows we have
	ADD EAX, cols								;adds the number of cols into eax so we can test if we have a 1x1 matrix
	CMP EAX, 2									;compares eax to 2 to check if it is a 1x1  (1 + 1 = 2)
	JE oneByone									;if it detects a 1x1 matrix, then jump to the proper section.
	POP EAX										;otherwise, restore EAX so we can use the original value.
	
	lpConvertToASCII:
		CMP rows, 0								;check to see if we have used up the allowed number of rows
		JE finished								;if it is equal to 0, jump to the finished section
		MOV EBX, startAddr						;moves the address of out address to edx so we can derefrence the address
		MOV EAX, [EBX + EDI]					;moves into eax the address of ebx + edi so we can get the correct number to convert
		MOV tempNum, EAX						;stores the number obtained in EAX into tempNum so we can use it in invoke, cant use eax
		MOV EBX, EDX							;moves into ebx, the adress of the outaddress
		PUSH EBX								;stores our ebx variable so we can get it back later
		ADD EBX, ESI							;adds into ebx the offset of ebx esi, so we get the correct byte to place a character
		INVOKE intasc32, EBX, tempNum			;calls intasc32 to convert the number into ascii characters and place into the address ebx points to
		POP EBX									;restore our original ebx that is unaffected by the addition earlier.
		ADD EDI, 4								;add 4 to edi so we get the next dword in the numbers to pull from.
		
		PUSH EAX								;store our EAX so we can get it back 
		getBytes EDX							;call the get bytes macro where we count the number of bytes used in the output address
		MOV ESI, EAX							;moves into ESI the offset that the previous macro returns
		DEC ESI									;decrement ESI to take into acount the null character the macro counts for.
		POP EAX									;restore our original eax
		
		CMP ECX, cols							;compare ecx to the number of cols to check if we are at the end of the row
		JE NoComma								;if there is no more numbers to the row, the jump to the no comma section 
		
		MOV tempNum, 44							;moves the comma ascii value into temp num
		MOV EBX, EDX							;moves into ebx, the adress of the outaddress
		PUSH EBX								;stores our ebx variable so we can get it back later
		ADD EBX, ESI							;adds into ebx the offset of ebx esi, so we get the correct byte to place a character
		PUSH EAX								;store our EAX so we can get it back 
		MOV EAX, tempNum						;moves into EAX the value temp num so we can but it into place without calling mem to mem
		MOV [EBX], EAX							;moves into the location ebx points to the value of eax, which is temp num
		POP EBX									;restore our original ebx that is unaffected by the addition earlier.
		getBytes EDX							;call the get bytes macro where we count the number of bytes used in the output address
		MOV ESI, EAX							;moves into ESI the offset that the previous macro returns
		DEC ESI									;decrement ESI to take into acount the null character the macro counts for.
		MOV tempNum, 32							;moves the space ascii value into temp num
		MOV EBX, EDX							;moves the address in edx into ebx so we can use it 
		PUSH EBX								;stores our ebx variable so we can get it back later
		ADD EBX, ESI							;adds into ebx the offset of ebx esi, so we get the correct byte to place a character
		MOV EAX, tempNum						;moves into EAX the value temp num so we can but it into place without calling mem to mem
		MOV [EBX], EAX							;moves into the location ebx points to the value of eax, which is temp num
		POP EBX									;restore our original ebx that is unaffected by the addition earlier.
		getBytes EDX							;call the get bytes macro where we count the number of bytes used in the output address
		MOV ESI, EAX							;moves into ESI the offset that the previous macro returns
		DEC ESI									;decrement ESI to take into acount the null character the macro counts for.
		POP EAX									;restore our original eax
		
		INC ECX									;increments we we know we are on the next col
		JMP lpConvertToASCII					;jumps back to the top
		
	NoComma:
		MOV ECX, 1								;reset the col value back to 1
		DEC rows								;decrement the number of rows so we can terminate this loop eventually
		MOV tempNum, 10							;moves the new line character into tempNum
		PUSH EBX								;pushes ebx to the stack so we can have the unaffected value later
		ADD EBX, ESI							;add the offset esi into ebx so we point to the right byte to place
		PUSH EAX								;push eax to store it
		MOV EAX, tempNum						;moves the new line char into eax (avoid mem to mem)
		MOV [EBX], EAX							;moves into the location ebx points to the value eax which is new line
		getBytes EDX							;call the get bytes macro where we count the number of bytes used in the output address
		MOV ESI, EAX							;moves into ESI the offset that the previous macro returns
		DEC ESI									;decrement ESI to take into acount the null character the macro counts for.
		POP EAX									;restore original eax
		POP EBX									;restore original ebx
		MOV tempNum, 09							;moves the tab character into tempNum
		PUSH EBX								;pushes ebx to the stack so we can have the unaffected value later
		ADD EBX, ESI							;add the offset esi into ebx so we point to the right byte to place
		PUSH EAX								;push eax to store it
		MOV EAX, tempNum						;moves the new line char into eax (avoid mem to mem)
		MOV [EBX], EAX							;moves into the location ebx points to the value eax which is new line
		getBytes EDX							;call the get bytes macro where we count the number of bytes used in the output address
		MOV ESI, EAX							;moves into ESI the offset that the previous macro returns
		DEC ESI									;decrement ESI to take into acount the null character the macro counts for.
		POP EAX									;restore original eax
		POP EBX									;restore original ebx
		JMP lpConvertToASCII					;jump back to the top of the loop
		
	finished:
		RET										;return back to where i was called
		
	oneByone:
		MOV EBX, startAddr						;moves the starting address into ebx
		MOV EAX, [EBX]							;moves the value ebx points to into eax
		MOV tempNum, EAX						;moves eax into the temp num variable
		MOV EBX, EDX							;moves the eaddress of edx into ebx so we can modify it
		PUSH EBX								;pushes ebx to store it
		ADD EBX, ESI							;adds the offset esi into ebx so we point to the right place
		INVOKE intasc32, EBX, tempNum			;convert the number into the ascii format and put into where ebx points
		POP EBX									;restore ebx
		JMP finished							;jump to the finished section

displayArray ENDP

COMMENT %
********************************************************************************
*Name: sortedArray                                                             *
*Purpose:                                                                      *
*	           This method accepts the address of a dword array and the number *
*		of dwords in that array. It returns TRUE (1 in AL register) if the array*
*		is in ascending sorted order, and 0 otherwise. 						   *
*																			   *
*Date Created: 10/26/2019                                                      *
*Date Modified: 10/26/2019                                                     *
*                                                                              *
*                                                                              *
*@param lpArrayDwords:dword                                                    *
*@param numElts:dword												 	       *
*@return Boolean:Byte												 	       *
*******************************************************************************%
sortedArray PROC Near32 C uses EBX ECX EDX EDI, lpArrayDwords:dword, numElts:dword
	LOCAL bool:byte
	
	MOV ECX, numElts							;Moves the number of elements into othe ecx register so we can track our loop
	DEC ECX										;decrements the number of elements so dont grab outside of your area
	MOV EDI, 0									;sets initial offset to 0
	MOV EAX, lpArrayDwords						;move the address into EAX so we can reference it
	
	lpCheckAscending:
		MOV EBX, [EAX + EDI]					;Move the value located at eax + edi into ebx
		ADD EDI, 4								;increment our offset by 4 to get the next dword
		MOV EDX, [EAX + EDI]					;Move the value located at eax + edi into edx
		CMP EBX, EDX							;compare the two registers to see if ebx is less than or equal to edx
		JLE LessThan							;if it is jump to appropriate section
		MOV bool, 0								;if it is not, we can move 0 into our bool byte and assume it is not in sorted ascending order
		JMP done								;jump to done
		
	done:
		MOV AL, bool							;moves into AL the result of the loop above
		RET										;returns back to where this method was called from
		
	LessThan:
		MOV bool, 1								;move a 1 into our byte 
		DEC ECX									;decrement our number of elements we have left
		CMP ECX, 0								;compare to 0 to see if we are at the end of our loop 
		JE done									;if it equals 0, then jump to done
		JMP lpCheckAscending					;if not, then jump back to the top of the loop

sortedArray ENDP

COMMENT %
********************************************************************************
*Name: sumUpArray                                                              *
*Purpose:                                                                      *
*	       Adds up all the values in the matrix, and return the answer		   *
*																			   *
*Date Created: 10/26/2019                                                      *
*Date Modified: 10/26/2019                                                     *
*                                                                              *
*                                                                              *
*@param lpArrayDwords:dword                                                    *
*@param rows:dword													 	       *
*@param cols:dword 													 	       *
*@return sum:dword															   *
*******************************************************************************%
sumUpArray PROC Near32 C uses EBX ECX EDI, lpArrayDwords:dword, rows:dword, cols:dword
	LOCAL sum:dword
	
	MOV EAX, rows								;moves the number of rows into eax so we can multiply it to get numElements
	MUL cols									;Multiplies EAX by the number of cols
	MOV ECX, EAX								;stores the number of elements 
	MOV EAX, lpArrayDwords						;move the address into EAX so we can reference it
	MOV EDI, 0									;set the intital offset to 0
	MOV sum, 0									;set the intital sum to 0
	
	lpSumArray:
		MOV EBX, [EAX + EDI]					;moves into ebx, the value located at eax offset edi
		ADD sum, EBX							;add the value into the sum
		ADD EDI, 4								;add 4 to edi so we get the next number in the sequence
	loop lpSumArray								;decrement ecx and jump back to the top
	
	MOV EAX, sum								;move our sum into eax for return
	RET											;return
	
sumUpArray ENDP

COMMENT %
********************************************************************************
*Name: smallestValue                                                           *
*Purpose:                                                                      *
*	       Determine the smallest Value in the array and return the answer     *
*																			   *
*Date Created: 10/26/2019                                                      *
*Date Modified: 10/26/2019                                                     *
*                                                                              *
*                                                                              *
*@param lpArrayDwords:dword                                                    *
*@param rows:dword													 	       *
*@param cols:dword 													 	       *
*@return smallestVal:dword													   *
*******************************************************************************%
smallestValue PROC Near32 C uses EBX ECX EDI, lpArrayDwords:dword, rows:dword, cols:dword
	LOCAL smallestVal:dword
		
	MOV EDI, 0									;set the intital offset to 0
	MOV EAX, rows								;moves the number of rows into eax so we can multiply it to get numElements
	MUL cols									;Multiplies EAX by the number of cols
	MOV ECX, EAX								;stores the number of elements 
	MOV EAX, lpArrayDwords						;move the address into EAX so we can reference it
	CMP ECX, 1									;compare ecx to one to see if the user entered 1x1
	JE oneByone									;if it is then jump to the one by one section
	;DEC ECX									;decrement ECX so we work with n-1 elements
	
	MOV EBX, [EAX + EDI]						;moves into ebx the first value
	MOV smallestVal, EBX						;stores the first value as the smallest one
	
	lpGetSmallest:
		ADD EDI, 4								;increments the offset by 4 so we get the next dword
		MOV EBX, [EAX + EDI]					;moves into ebx the value located at that location
		CMP EBX, smallestVal					;compare that value to the current smallest number
		JL newSmallest							;if the register is less than the current smallest value jump to new smallest
		DEC ECX									;decrement ecx so we can terminate the loop eventually 
		CMP ECX, 0								;compares ecx to 0, so we check to see if the loop is done
		JE DoneLoop								;if it is 0 then jump to done loop
		JMP lpGetSmallest						;if it is not then jump back to the top
		
	newSmallest:
		MOV smallestVal, EBX					;moves the value currently in ebx into our smallest value variable
		DEC ECX									;decrement ecx so we can terminate the loop eventually 
		CMP ECX, 0								;compares ecx to 0, so we check to see if the loop is done
		JE DoneLoop								;if it is 0 then jump to done loop
		JMP lpGetSmallest						;if it is not then jump back to the top
		
	DoneLoop:
		MOV EAX, smallestVal					;moves into eax the value in smallest value so we can return it
		RET										;return
		
	oneByone:
		MOV EBX, [EAX + EDI]					;moves into ebx the first value
		MOV smallestVal, EBX					;stores the first value as the smallest one
		JMP DoneLoop							;jump to end of loop
			

smallestValue ENDP

COMMENT %
********************************************************************************
*Name: selectionSort                                                           *
*Purpose:                                                                      *
*	      Takes in an array, and sorts it displaying each pass 				   *
*																			   *
*Date Created: 10/26/2019                                                      *
*Date Modified: 10/27/2019                                                     *
*                                                                              *
*                                                                              *
*@param lpArrayDwords:dword                                                    *
*@param iLegth:dword													 	   *
*******************************************************************************%
selectionSort PROC Near32 C uses EBX EDX EDI, lpArrayDwords:dword, iLength:dword
	LOCAL smallestVal:dword, startAddr:dword, offsetAddr:Dword, storedNum:Dword, counter:dword
	
	MOV EAX, lpArrayDwords						;moves the address into eax						
	MOV startAddr, EAX							;stores this address into a different variable for clarity
	MOV ECX, 0									;sets ecx to 0 to set our initial counter
	MOV EDI, 0									;sets the initial offset to 0
	MOV EAX, iLength							;moves ilength to eax so we dont do mem to mem
	MOV counter, EAX 							;stores this as a seperate counter variable seperete from ecx
	
	MOV EAX, startAddr							;moves the starting address into eax
	MOV offsetAddr, EAX							;moves the intital offset address into eax
	MOV EBX, [EAX]								;moves into ebx the valuew located at what eax points to
	MOV storedNum, EBX							;moves ebx into a variable as this is the first number we are storing
	
	INVOKE sortedArray, lpArrayDwords, iLength	;invoke the sorted array method to check if the array is already sorted
	CMP AL, 1									;compares the result al to 1
	JE alreadySorted							;if it equals 1 then the data is already sorted and we can jump to the appropriate section
	
	lpSelectionSort:
		INVOKE sortedArray, lpArrayDwords, iLength		;check if the array is sorted.
		CMP AL, 1								;compare al to 1 to see if the data is sorted
		JE SortComplete							;if it equals 1 then we jump to sort complete
		DisplayString crlf						;display the characters to skip to a new line
		PUSH EDI								;preserve our edi so it doesnt get trashed when we invoke these methods
		PUSH EBX								;preserve our ebx so it doesnt get trashed when we invoke these methods
		INVOKE displayArray, startAddr, 1, 		;display the array with 1 row and ilength cols
		iLength, addr tempSelectionSortASCII
		DisplayString tempSelectionSortASCII	;display the address that gets returns previously
		;INVOKE sortedArray, lpArrayDwords, 		;check if the array is sorted.

		POP EBX									;return our original ebx
		POP EDI									;return our orginal edi
		INC ECX									;increment ecx so we know how what pass we are on
		;CMP AL, 1								;compare al to 1 to see if the data is sorted
		;JE SortComplete							;if it equals 1 then we jump to sort complete
		DEC counter								;decrement our counter so we know how many swaps we have left to do
		CMP counter, 0							;if it equals 0, then the sort is complete
		JE SortComplete							;jump to sort complete
		CMP counter, 1							;if it equals 1
		JE swap									;jump to the section to swap the last two numbers. 
		INVOKE smallestValue, offsetAddr, 1, 	;get the smallest value starting at the offset address (the values before offset address should already be sorted so we can ignore them)
		counter
		MOV smallestVal, EAX					;moves the returning eax value into smallestVal
		PUSH EDI								;store our edi so it doesnt get trashed (we could lose our offset)
		MOV EDI, 0								;move intial offset to 0 (going to get offset of the smallest number found)
		
		lpGetPosofSmallest:
			MOV EBX, offsetAddr					;moves the offset address into ebx so we can reference it
			MOV EAX, [EBX + EDI]				;moves the value that ebx + edi points to into eax
			CMP EAX, smallestVal				;compares this number to the smallest value to check if we found it 
			JE foundOffset						;if we have we have our offset in edi
			ADD EDI, 4							;if not we can add 4 to edi to get the next number
			JMP lpGetPosofSmallest				;jump to the top of the loop
			
			foundOffset:
			CMP counter, 1						;compare the counter to 1 to see if we only need to swap the last two 
			JE swap								;if it equals 1 then we jump to the swap section
			MOV EAX, [EBX + EDI]				;if not, we move ointo eax the number found
			MOV EDX, storedNum					;move into edx the stored number
			MOV [EBX + EDI], EDX				;moves the stored number into the position where the smallest was found
			MOV [EBX], EAX						;then we move the smallest number into the first position
			POP EDI								;restore our original edi

		MOV EAX, offsetAddr						;moves the offset address into eax			
		ADD EAX, 4								;adds 4 into eax to get the next number
		ADD EDI, 4								;add 4 to edi so we keep track of the offset from the original address
		MOV offsetAddr, EAX						;moves into offset address our new addres
		MOV EBX, [EAX]							;moves into oebx the first value that eax points to
		MOV storedNum, EBX						;this is our new stored number
	JMP lpSelectionSort							;jump back to the top of the loop
			
	swap:
		MOV EBX, offsetAddr						;moves into ebx the offset address
		MOV EAX, [EBX + 4]						;moves into eax the next number in offset address
		MOV EDX, storedNum						;moves into edx our stored number
		MOV [EBX + 4], EDX						;moves the stored number into offset 4
		MOV [EBX], EAX							;moves eax into the first value ebx points to
		JMP SortComplete						;the sort is complete and we can jump to the section
		
	alreadySorted:
		DisplayString crlf								;display the characters that skip to a new line
		INVOKE displayArray, startAddr, 1, iLength, 	;call display array method to get the string
		addr tempSelectionSortASCII
		DisplayString tempSelectionSortASCII			;display the string that was given back to us
		DisplayString strSortAlready					;display the string telling the user that the data is already in sorted order
		DisplayString crlf								;display the characters that skip to a new line						
		RET												;return
	
	SortComplete:	
		DisplayString crlf								;display the characters that skip to a new line
		INVOKE displayArray, lpArrayDwords, 1, iLength, ;call display array method to get the string
		addr tempSelectionSortASCII
		DisplayString tempSelectionSortASCII			;display the string that was given back to us
		DisplayString strSortComplete					;display the string telling the user that the data is sorted
		DisplayString crlf								;display the characters that skip to a new line	
		RET
selectionSort ENDP
END