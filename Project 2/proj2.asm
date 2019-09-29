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
	
	strEnterAmtNumbers byte 10,10, "How many values to input: ", 0
	strEnterNumbers byte 10,10, "Type each value and press ENTER after each one: ", 0
	strMaxAmount byte "Maximum amount is 10 numbers.", 0
	strMaxNumber byte "Maximum number you can enter is 4,294,967,295.", 0
	strProjInfo byte  10,13,9,
        "Name: Ryan Shupe",10,
"       Class: CSCI 2160-001",10,
"        Date: 10/04/2019",10,
"         Lab: Project 2",0
    crlf byte  10,13,0				;Null-terminated string to skip to new line
	strInput byte 60 dup (?)		;Set aside 60 bytes of memory for strInput
	sNumNumbers word 2				;Maximum number of chars that can be typed in the console for specifying how many numbers. 
	sNum word 10					;Maximum number of chars that can be typed in the console for entering a number.
	bOffset word 0					;This is going to hold the offset into the numbers variable.
	iNumOfNums dword ?				;Number of numbers to be input/calculated
	iNumbers dword 10 dup (?)		;Set aside 10 dwords in memory to hold future numbers.
	iMaxNumber dword 4294967295		;Maximum number for a dword for reference later
	iTempNum dword ?				;Temporary variable to be used for comparing later
	
	
	
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
	MOV iNumOfNums, EAX								;Move the result of above method stored in EAX into variable so it isnt lost.
	MOV ECX, iNumOfNums								;Put the value of iNumOfNums into ECX so we can use it to loop later
	MOV EDI, 0										;Put 0 into EDI so we can start at a 0 offset into iNumbers
		
	CMP iNumOfNums, 0								;Compare iNumOfNums to 0 to see if the user typed null character
	JE maxAmountMessage								;If it is null then jump to maxAmountMessage
	CMP iNumOfNums, 10								;Compare iNumOfNums to 10 to see if the user typed a number greater than 10.
	JG maxAmountMessage								;If greater than, jump to maxAmountMessage
	CMP iNumOfNums, 10								;Compare iNumOfNums to 10 to see if it is less than or equal to 10	
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
	jmp finished
	
	
;************************************* the instructions below calls for "normal termination"	
finished:
	INVOKE ExitProcess,0						 
	PUBLIC _start
	
main ENDP
	END												;Signals assembler that there are no instructions after this statement
	
