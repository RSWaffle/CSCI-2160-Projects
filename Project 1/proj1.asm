;******************************************************************************************
;*  Program Name: proj1.asm
;*  Programmer:   Ryan Shupe
;*  Class:        CSCI 2160-001
;*  Lab:          Proj1
;*  Date:         9/23/2019
;*  Purpose:      This program computes the following equation: iResult = 15 * (sVal1 = sVal2) * (iVal3 - bVal4), 
;*				  with all arithmetic being completed in registers and loops for multiplication operations.  
;*				  The program then displays the project information on the screen properly formatted, 
;*				  also displaying the result of the computed equation.
;******************************************************************************************
	.486				;This tells assembler to generate 32-bit code
	.model flat			;This tells assembler that all addresses are real addresses
	.stack 100h			;EVERY program needs to have a stack allocated
;******************************************************************************************
;  List all necessary prototypes for methods to be called here
	ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD  					;executes "normal" termination
	intasc32 PROTO NEAR32 stdcall, lpStringToHold:dword, dval:dword			;will convert any D-Word number into ACSII characters
	putstring  PROTO NEAR stdcall, lpStringToDisplay:dword  				;will display ;characters until the NULL character is found
	
;******************************************************************************************
	.DATA						;declare all data identifiers after this directive

iResult DWORD  ?				;memory to hold the resulting value of calculation
sVal1 WORD 127					;sets the variable sVal1 to 127 decimal for calculation
sVal2 WORD -25					;sets the variable sVal2 to -25 decimal for calculation
iVal3 DWORD 78253				;sets the variable iVal3 to 78,253 decimal for calculation
bVal4 BYTE 78					;sets the variable of BVal to 78 decimal for calculation

sTemp WORD ?					;sets aside memory for a future value for calculation
iTemp DWORD ?					;sets aside memory for a future value for calculation

strInput byte  11 dup(?)						;holds input string. Allow room for NULL
strResult   byte  12 dup(?)     				;memory to hold the ASCII value of any 4-byte value
crlf byte  10,13,0								;null-terminated string to skip to new line
strResultIs byte  10,13,9,"Result = ",0
					
strInfoIs byte  10,13,9,
 "Name: Ryan Shupe",10,20,20,20,20,20,20,20,
"Class: CSCI 2160-001",10,20,20,20,20,20,20,20,20,
 "Date: 9/23/2019",10,20,20,20,20,20,20,20,20,20
   "Lab: Project1",0

;******************************************************************************************
	.CODE
_start:							;This is the entry point for this program (needed for debugger)

	MOV EAX, 0					;This aids in debugging and initializes the program, EAX = 00000000
	
	MOV EBX, 0					;initialize EBX to 0 to avoid calculation error, EBX = 00000000
	MOV AX , sVal1				;move the first value of calculation to AX register, EAX = 0000007F
	MOV BX, sVal2				;move the second value of calculation to the BX register, EBX = 0000FFE7
	ADD AX, BX					;add the two registers and store in AX register, EAX = 00000066
	MOV sTemp, AX				;store the value in AX into memory for later calculation, sTemp = 0066 stored as 6600
	
	MOV EBX, 0					;reset the EBX register to 0 to avoid calculation error, EBX = 00000000
	MOV EAX, iVal3				;move the first value of calculation to the EAX register, EAX = 000131AD
	MOV BL,  bVal4				;move the second value of calculation to the EBX register making sure to match the byte size, BL = 4E
	SUB EAX, EBX				;perform the subtract calculation and store into the EAX register, EAX = 0001315F
	MOV iTemp, EAX				;store the result in EAX to memory as iTemp, iTemp = 0001315F stored as 5F310100
	
	MOV ECX, 15					;set the loop counter to 15 so the loop knows when to terminate, ECX = 0000000F
	MOV EAX, 0					;set the EAX register to 0 to avoid any calculation error, EAX = 00000000
	MOV BX, sTemp				;move the variable sTemp into a register so calculation can be done via register to register, BL = 66
	
lpMultiply1:					;loop header for first multiplication operation
	ADD AX, BX					;add the two values together and store into AX, looping this simulates multiplication
	loop lpMultiply1			;decrement the ECX register to eventually stop the loop, and jump to the top
	
	SUB AX, 20					;subtracts 20 from AX and stores back into AX, EAX = 000005E6
	MOV sTemp, AX				;moves the result from the loop (stored in AX register) into the sTemp variable
	
	MOV CX, sTemp				;moves the value of sTemp into the loop counter register  so the upcoming loop knows when to terminate, ECX = 000005E6
	MOV EAX, 0					;sets EAX register to 0 to avoid any calculation error, EAX = 00000000
	MOV EBX, iTemp				;set the value of EBX to iTemp for multiple additions to the same number, EBX = 0001315F
	
lpMultiply2:					;loop header for the second multiplication operation
	ADD EAX, EBX				;add the two registers together in the loop simulating multiplication
	loop lpMultiply2			;decrement the ECX register to eventually end the loop
	
	MOV iResult, EAX			;move the multiplication result into memory as iResult, iResult = 0709365A, stored as 5A360907
	
	
	INVOKE putstring, ADDR strInfoIs      		;skip to new line, tab, and display Project information "Name: Ryan Shupe" etc. 
	INVOKE putstring, ADDR crlf					;display the characters to skip to a new line	
	
	INVOKE putstring, ADDR strResultIs      	;skip to new line, tab, and display "Result = "
	INVOKE intasc32, ADDR strResult, iResult    ;convert the D-WORD IResult to ASCII characters
	INVOKE putstring, ADDR strResult         	;display the numeric string
	INVOKE putstring, ADDR crlf					;display the characters to skip to a new line
	
	
;************************************* the instruction below calls for "normal termination"	
	INVOKE ExitProcess,0
	PUBLIC _start
	END							;signals assembler that there are no instructions after this statement