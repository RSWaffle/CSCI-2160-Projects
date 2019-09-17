;******************************************************************************************
;*  Program Name: proj1.asm
;*  Programmer:   Ryan Shupe
;*  Class:        CSCI 2160
;*  Lab:          Proj1
;*  Date:         9/23/2019
;*  Purpose:      give a secription here of what the program DOES
;******************************************************************************************
	.486				;tells assembler to generate 32-bit code
	.model flat			;tells assembler that all addresses are real addresses
	.stack 100h			;EVERY program needs to have a stack allocated
;******************************************************************************************
;  List all necessary prototypes for methods to be called here
	ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD  ;executes "normal" termination
	getstring  PROTO NEAR stdcall, lpStringToHold:dword, maxNumChars:dword
	intasc32 PROTO NEAR32 stdcall, lpStringToHold:dword, dval:dword
	putstring  PROTO NEAR stdcall, lpStringToDisplay:dword   ;will display ;characters until the NULL character is found
	
;******************************************************************************************
	.DATA						;declare all data identifiers after this directive

iResult DWORD  ?			;memory to hold the resulting value of calculation
sVal1 WORD 127					;sets the variable sVal1 to 127 decimal for calculation
sVal2 WORD -25					;sets the variable sVal2 to -25 decimal for calculation
iVal3 DWORD 78253				;sets the variable iVal3 to 78,253 decimal for calculation
bVal4 BYTE 78					;sets the variable of BVal to 78, 200 decimal for calculation

sTemp WORD ?			;sets aside memory for a future value for calculation
iTemp DWORD ?			;sets aside memory for a future value for calculation

strInput byte  11 dup(?)		;holds input string. Allow room for NULL

strResult   byte  12 dup(?)     ;memory to hold the ASCII value of any 4-byte value
crlf byte  10,13,0								;null-terminated string to skip to new line
strResultIs byte  10,13,9,"Result = ",0

;******************************************************************************************
	.CODE
_start:							;entry point for this program (needed for debugger)

	MOV EAX, 0					;aids in debugging and initalizes the program
	
	MOV EBX, 0					;intitialize EBX to 0 to avoid calculation error
	MOV AX ,sVal1				;move the first value of calculation to AX register
	MOV BX, sVal2				;move the second valur of calculation to the BX register
	ADD AX, BX					;add the two regiters and store in AX register	
	MOV sTemp, AX				;store the value in AX into memory for later calculation
	
	MOV EBX, 0					;reset the EBX register to 0 to avoid calculation error
	MOV EAX, iVal3				;move the first value of calculation to the EAX register
	MOV BL,  bVal4				;move the second value of calculation to the EBX register makeing sure to match the byte size
	SUB EAX, EBX				;preform the subtract calculation and store into the EAX register
	MOV iTemp, EAX				;store the result in EAX to memory
	
	MOV ECX, 15					;set the counter to 15 so the loop knows when to terminate
	MOV EAX, 0					;set the EAX register to 0 to avoid any calculation error
	MOV BX, sTemp				;move the variable sTemp into a register so calculation can be done via register to register
	
lpMultiply1:					;loop for first multiplication operation
	ADD AX, BX					;add the two values together and store into AX
	loop lpMultiply1			;decrement the ECX register to eventually stop the loop, and jump to the top
	
	SUB AX, 20					;subtracts 20 from AX and stores back into AX
	MOV sTemp, AX				;moves the result from the loop (stored in AX register) into the sTemp variable
	
	MOV CX, sTemp				;moves into the loop counter register the value of sTemp
	MOV EAX, 0					;sets EAX register to 0 to avoid any calculation error
	MOV EBX, iTemp				;set the value of EBX to iTemp for multiple additions to the same number
	
lpMultiply2:					;loop for the second multiplication operation
	ADD EAX, EBX				;add the two registers together
	loop lpMultiply2			;decrement the ECX register to eventually end the loop
	
	MOV iResult, EAX			;move the multiplication result into memeory as iResult
	
	
	INVOKE putstring, ADDR strResultIs      ;skip to new line, tab, and display "Result = "
	INVOKE intasc32, ADDR strResult, iResult    ;convert the dword IResult to ASCII characters
	INVOKE putstring, ADDR strResult         ;display the numeric string
	INVOKE putstring, ADDR crlf
	
	MOV EAX, 0
	
;************************************* the instruction below calls for "normal termination"	
	INVOKE ExitProcess,0
	PUBLIC _start
	END							;signals assembler that there are no instructions after this stmt