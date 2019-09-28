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
	ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD  					;executes "normal" termination
	intasc32 PROTO NEAR32 stdcall, lpStringToHold:dword, dval:dword			;will convert any D-Word number into ACSII characters
	putstring  PROTO NEAR stdcall, lpStringToDisplay:dword  				;will display ;characters until the NULL character is found
	getstring 	PROTO stdcall, lpStringToHoldInput:dword, maxNumChars:dword ;get input from user and convert. 
	ascint32 PROTO NEAR32 stdcall, lpStringToConvert:dword  
	
;******************************************************************************************
	.DATA						;declare all data identifiers after this directive
	
	strEnterAmtNumbers byte 10,10, "How many values to input: ", 0
	strMaxAmount byte "Maximum amount is 10 numbers.", 0
	strProjInfo byte  10,13,9,
        "Name: Ryan Shupe",10,
"       Class: CSCI 2160-001",10,
"        Date: 10/04/2019",10,
"         Lab: Project 2",0
    crlf byte  10,13,0				;null-terminated string to skip to new line
	strInput byte 30 dup (?)		;set aside 30 bytes of memory for strInput
	sNumNumbers word 2				;Maximum number of chars that can be typed in the console. 
	
	iNumOfNums dword ?				;number of numbers to be input/calculated
	iNumbers dword 10 dup (?)		;set aside 10 dwords in memory to hold future numbers. 
	
	
;******************************************************************************************
	.CODE
	
_start:
	MOV EAX, 0									;statement to help in debugging
	
main PROC

getNumofNums:
	INVOKE putstring, ADDR strProjInfo     		;skip to new line, tab, and display Project information "Name: Ryan Shupe" etc. 
	INVOKE putstring, ADDR crlf					;display the characters to skip to a new line
	INVOKE putstring, ADDR strEnterAmtNumbers   ;display the "Enter amount of numbers" message
	INVOKE getstring, ADDR strInput, sNumNumbers;Take the string input and store it into a variable, max amount of chars typed is sNumChars
	INVOKE ascint32, ADDR strInput				;Convert the ASCII value to its true decimal number
	MOV iNumOfNums, EAX							;Move the result of above method stored in EAX into variable so it isnt lost.
	
	CMP iNumOfNums, 0							;Compare iNumOfNums to 0 to see if the user typed null character
	JE maxAmountMessage							;If it is null then jump to maxAmountMessage
	CMP iNumOfNums, 10							;Compare iNumOfNums to 10 to see if the user typed a number greater than 10.
	JG maxAmountMessage							;If greater than, jump to maxAmountMessage
	CMP iNumOfNums, 10							;Compare iNumOfNums to 10 to see if it is less than or equal to 10	
	JLE getNums									;If so, jump to getNums so we can get the numbers for calculation 

getNums:
	jmp finished
	
maxAmountMessage:
	MOV ECX, 100								;set ECX to 100 to let the loop know when to terminate and how many lines to skip
	lpClearSc:									;loop to simulate a clear screen
		INVOKE putstring, ADDR crlf				;display the characters to skip to a new line
		loop lpClearSc							;decrement ECX so the loop knows when to terminate
	INVOKE putstring, ADDR strMaxAmount			;display a message letting the user know that the maximum amount of numbers to enter is 10
	JMP getNumofNums							;jump back up to the getNumofNums section and it will repeat until the user enters a value less than or equal to 10
	
	
;************************************* the instruction below calls for "normal termination"	
finished:
	INVOKE ExitProcess,0						 
	PUBLIC _start
	
main ENDP
	END											;signals assembler that there are no instructions after this statement
	
