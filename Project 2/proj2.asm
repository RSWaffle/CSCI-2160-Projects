;******************************************************************************************
;*  Program Name: proj2.asm
;*  Programmer:   Ryan Shupe
;*  Class:        CSCI 2160-001
;*  Lab:          Proj1
;*  Date:         10/04/2019
;*  Purpose:      This program accepts an amount of numbers specified by the user, then calculates the sum, calculates
;*				  The average, calculates the modulo remainder, maximum and minimum value, 
;*                and displays the numbers in reverse order via a stack.
;******************************************************************************************
	.486						;This tells assembler to generate 32-bit code
	.model flat					;This tells assembler that all addresses are real addresses
	.stack 100h					;EVERY program needs to have a stack allocated
;******************************************************************************************
;  List all necessary prototypes for methods to be called here
	ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD  					;Executes "normal" termination
	intasc32 PROTO NEAR32 stdcall, lpStringToHold:dword, dval:dword			;Will convert any D-Word number into ACSII characters
	putstring  PROTO NEAR stdcall, lpStringToDisplay:dword  				;Will display ;characters until the NULL character is found
	getstring 	PROTO stdcall, lpStringToHoldInput:dword, maxNumChars:dword ;Get input from user and convert. 
	ascint32 PROTO NEAR32 stdcall, lpStringToConvert:dword  				;This converts ASCII characters to the dword value
	
;******************************************************************************************
	.DATA							;declare all data identifiers after this directive
	strTest byte ":^)", 0
	strEnterAmtNumbers byte 10,10, "How many values to input: ", 0
	strReverse byte 10,10, "List of numbers in reverse order: ", 0
	strEnterNumbers byte 10,10, "Type each value and press ENTER after each one: ", 0
	strMaxAmount byte "Maximum amount is 10 numbers.", 0
	strMod byte "The Java modulo is: ", 0
	strLess byte "The smallest number is: ", 0
	strGtr byte "The greatest number is: ", 0
	strAverage byte "The Java answer to the whole number average is: ", 0
	strMaxNumber byte "Maximum number you can enter is 4,294,967,295.", 0
	strSum byte "The sum of all the numbers is: ", 0
	strProjInfo byte  10,13,9,
        "Name: Ryan Shupe",10,
"       Class: CSCI 2160-001",10,
"        Date: 10/04/2019",10,
"         Lab: Project 2",0
	strCalcResult byte 10 dup (?)
    crlf byte  10,13,0				;Null-terminated string to skip to new line
	strInput byte 60 dup (?)		;Set aside 60 bytes of memory for strInput
	sNumNumbers word 2				;Maximum number of chars that can be typed in the console for specifying how many numbers. 
	sNum word 10					;Maximum number of chars that can be typed in the console for entering a number.
	bNumOfNums byte ?				;Number of numbers to be input/calculated
	iNumbers dword 10 dup (?)		;Set aside 10 dwords in memory to hold future numbers.
	iMaxNumber dword 4294967295		;Maximum number for a dword for reference later
	iTempNum dword ?				;Temporary variable to be used for comparing later
	iTemp dword ?
	iResult dword ?					;Temporary variable to store results before displaying
	bNumRemainder byte ?
	
	
;******************************************************************************************
	.CODE
	
_start:
	MOV EAX, 0										;Statement to help in debugging
	
main PROC
	
getNumofNums:
	INVOKE putstring, ADDR strProjInfo     			;Skip to new line, tab, and display Project information "Name: Ryan Shupe" etc. 
	INVOKE putstring, ADDR crlf						;Display the characters to skip to a new line
	INVOKE putstring, ADDR strEnterAmtNumbers  	    ;Display the "Enter amount of numbers" message
	INVOKE getstring, ADDR strInput, sNumNumbers	;Take the string input and store it into a variable, max amount of chars typed is sNumChars
	INVOKE ascint32, ADDR strInput					;Convert the ASCII value to its true decimal number
	MOV bNumOfNums, AL								;Move the result of above method stored in EAX into variable so it isnt lost.
	MOVZX ECX, bNumOfNums								;Put the value of bNumOfNums into ECX so we can use it to loop later
	MOV EDI, 0										;Put 0 into EDI so we can start at a 0 offset into iNumbers
		
	CMP bNumOfNums, 0								;Compare bNumOfNums to 0 to see if the user typed null character
	JE maxAmountMessage								;If it is null then jump to maxAmountMessage
	CMP bNumOfNums, 10								;Compare bNumOfNums to 10 to see if the user typed a number greater than 10.
	JG maxAmountMessage								;If greater than, jump to maxAmountMessage
	CMP bNumOfNums, 10								;Compare bNumOfNums to 10 to see if it is less than or equal to 10	
	JLE getNums										;If so, jump to getNums so we can get the numbers for calculation 

getNums:
	INVOKE putstring, ADDR strEnterNumbers   		;Display the "Type each value and press ENTER after each one:" message
	lpGetNums:
		MOV EAX, 0									;Reset EAX to 0 to prevent errors
		INVOKE putstring, ADDR crlf					;Display the characters to skip to a new line
 
		INVOKE getstring, ADDR strInput, sNum		;Take the string input and store it into a variable, max amount of chars typed is sNumChars
		INVOKE ascint32, ADDR strInput				;Convert the ASCII value to its true decimal number
		MOV iTempNum, EAX							;Move the EAX value into a variable so it isnt lost. 
		MOV EDX, iMaxNumber							;Moves into EBX the max dword value to compare 
	
		CMP iTempNum, 0								;Compare EAX to 0 to see if the user typed null character
		JE invalidNum							    ;If it is null then jump to maxAmountMessage
		CMP EDX, iTempNum							;Compare EDX to maximum dWord value
		JG invalidNum								;If it is greater than, jump to invalidNum section
		CMP EDX, iTempNum							;Compare EDX to maximum dWord value
		JLE validNum								;If the number complies, jump to the validNum section

		invalidNum:
			INVOKE putstring, ADDR crlf				;Display the characters to skip to a new line
			INVOKE putstring, ADDR strMaxNumber		;Display the max possible dword value string
			JMP getNums								;Jump to the top and repeat until complied
	
		validNum:
			MOV iNumbers[EDI], EAX					;Move EBX into iNumbers to be saved for later
			ADD EDI, 4								;Add 4 to EDI to put the number into the correct place in iNumbers
			MOV iTemp, EDI							;
			
	loop lpgetNums									;Keep looping this until all of the numbers to be entered are filled.
	
JMP calculation										;Jump to the calculation section to preform the required calculation
	
maxAmountMessage:
	MOV ECX, 100									;Set ECX to 100 to let the loop know when to terminate and how many lines to skip
	lpClearSc:										;Loop to simulate a clear screen
		INVOKE putstring, ADDR crlf					;Display the characters to skip to a new line
		loop lpClearSc								;Decrement ECX so the loop knows when to terminate
	INVOKE putstring, ADDR strMaxAmount				;Display a message letting the user know that the maximum amount of numbers to enter is 10
	JMP getNumofNums								;Jump back up to the getNumofNums section and it will repeat until the user enters a value less than or equal to 10
	
calculation:
	MOV EDX, 0										;Move 0 into EAX to prevent calculation errors
	SUB EDI, 4										;Subtract 4 from EDI so it doesnt point to the end of the iNumbers array
	MOVZX ECX, bNumOfNums							;Put the amount of numbers in ECX so the loop runs that amount of times.
	lpSum:
		MOV EAX, iNumbers[EDI]						;Moves the value offset EDI in iNumbers into EAX
		ADD EDX, EAX								;Add the two registers to eventually get the sum in EAX
		SUB EDI, 4									;Subtract 4 from EDI so we get the next number in the array
	loop lpSum										;Decrement ECX to eventually terminate the loop
	
	MOV iResult, EDX								;Moves the result into a variable so it can be set up for display
	INVOKE putstring, ADDR crlf						;Skips to a new line
	INVOKE putstring, ADDR strSum					;display the string "The sum of the values is:"
	INVOKE intasc32, ADDR strCalcResult, iResult    ;convert the D-WORD IResult to ASCII characters
	INVOKE putstring, ADDR strCalcResult            ;display the numeric string
	
	MOV EAX, iResult								;Moves the current sum of all the numbers into EAX for subtraction
	MOVZX EDX, bNumOfNums							;moves the value of bNumOfNums into EDX for calculation
	MOV EBX, 1										;set EBX to 1 because it has to go through atleast once

wlpDivide:
		SUB EAX, EDX								;Subtract the two registers to sumulate division
		CMP EAX, EDX								;Compare the numbers to see if the number is too small to keep subtracting
		JL resultNums								;If the number is less than, jump to resultNums
		CMP EAX, EDX								;Compare the numbers to see if the number is too small to keep subtracting
		JGE nextNum									;If it is greater than or equal to, jump to the next num section
		
nextNum:
		INC EBX										;Increments the number to eventually get our average
		JMP wlpDivide								;jump back up to the while loop
			
resultNums:					
		MOV BnumRemainder, AL						;moves the value in AL into the bnumremainder variable, this is our remainder. 
		MOV iResult, EBX							;moves the value of EBX into iResult, this is the average number.
		
	INVOKE putstring, ADDR crlf						 	 			;Skips to a new line
	INVOKE putstring, ADDR strAverage					 			;display the string "The average of the values is:"
	INVOKE intasc32, ADDR strCalcResult, iResult    	 			;convert the D-WORD IResult to ASCII characters
	INVOKE putstring, ADDR strCalcResult            	 			;display the numeric string
	INVOKE putstring, ADDR crlf							 			;Skips to a new line
	INVOKE putstring, ADDR strMod						 			;display the string "The remainder:"
	INVOKE intasc32, ADDR strCalcResult, dWord ptr BnumRemainder    ;convert the D-WORD IResult to ASCII characters
	INVOKE putstring, ADDR strCalcResult            	 			;display the numeric string
	
compare:	
	
	MOV EDI, iTemp
	SUB EDI, 4
	MOVZX ECX, bNumOfNums
	MOV EDX, 0
	MOV EBX, iNumbers[EDI]
	
	lpGetLess:
		MOV EAX, iNumbers[EDI]
		CMP EBX, EAX
		JGE gtrThan
		
		CMP EBX, EAX
		JL lessThan
	
	gtrThan:	
		MOV EBX, EAX
		SUB EDI, 4
		JMP loopFinish
		
	lessThan:
		SUB EDI, 4
		JMP loopFinish
		
	loopFinish:
		loop lpGetLess
		
	
	MOV iResult, EBX
	INVOKE putstring, ADDR crlf						 	 			;Skips to a new line
	INVOKE putstring, ADDR strLess					 				;display the string "The smallest value is:"
	INVOKE intasc32, ADDR strCalcResult, iResult    	 			;convert the D-WORD IResult to ASCII characters
	INVOKE putstring, ADDR strCalcResult            	 			;display the numeric string
	
	MOV iResult, EDX
	INVOKE putstring, ADDR crlf						 	 			;Skips to a new line
	INVOKE putstring, ADDR strGtr					 				;display the string "The greatest value is:"
	INVOKE intasc32, ADDR strCalcResult, iResult    	 			;convert the D-WORD IResult to ASCII characters
	INVOKE putstring, ADDR strCalcResult            	 			;display the numeric string
	
	JMP reverse														;Jump to the reverse section of our code. 
	
	
	
reverse:
	SUB iTemp, 4													;Subtract 4 from iTemp so we dont start outside the iNumbers zone. 
	MOV EDI, iTemp													;Move into EDI the value of iTemp which should be the amount of numbers * 4 - 4.
	
	PUSH EBP														;Preserve our current base pointer
	MOV EBP, ESP													;Move our stack pointer into the base pointer
	MOVZX ECX, bNumOfNums											;Move the number of numbers into ECX so the loop knows when to terminate
	lpLoadStack:
		PUSH iNumbers[EDI]											;Push onto the stack the value iNumbers offset EDI
		SUB EDI, 4													;Subtract 4 from EDI so we get the next number in iNumbers
	loop lpLoadStack		
	
	MOVZX ECX, bNumOfNums											;Move the number of numbers into ECX so the loop knows when to terminate
	MOV EDI, 0														;Move 0 into EDI so we have a starting point
	lpUnloadStack:			
		POP iNumbers[EDI]											;Pop out of the stack into iNumbers offset EDI (should be in reverse)	
		ADD EDI, 4													;Add 4 to EDI to get the next number in INumbers.
	loop lpUnloadStack
	
	POP EBP															;Pop EBP out of the stack so we are  fully cleared
	ADD ESP, iTemp												    ;Add to ESP iTemp so we get the bytes we used back

	MOV EDI, iTemp													;Move into EDi ITemp, which should be the amount of numbers * 4 - 4.
	MOVZX ECX, bNumOfNums										    ;Move the amount of numbers into ECX so the loop knows when to terminate
	INVOKE putstring, ADDR strReverse					 			;display the string "The greatest value is:"
	lpDisplayNumbers:
		MOV EAX, iNumbers[EDI]										;Move the value at iNumbers[EDI] into EAX to be put in another variable, cant do mem to mem 
		MOV iResult, EAX											;Move into iResult the value of EAX for displaying
		SUB EDI, 4													;Subtract 4 from EDI so we get the next number in iNumbers
		INVOKE putstring, ADDR crlf						 	 		;Skips to a new line
		INVOKE intasc32, ADDR strCalcResult, iResult    	 		;convert the D-WORD IResult to ASCII characters
		INVOKE putstring, ADDR strCalcResult            	 		;display the numeric string
	loop lpDisplayNumbers
	
	
	INVOKE putstring, ADDR crlf						 	 			;Skips to a new line
	INVOKE putstring, ADDR strTest					 				;test string"
	
	

	
;************************************* the instructions below calls for "normal termination"	
finished:
	INVOKE ExitProcess,0						 
	PUBLIC _start
	
main ENDP
	END												;Signals assembler that there are no instructions after this statement
	
