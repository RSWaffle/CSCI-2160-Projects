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
	
	ExitProcess PROTO Near32 stdcall, dwExitCode:DWORD  ;executes "normal" termination
	
;******************************************************************************************
	.DATA				;declare all data identifiers after this directive

iResult DWORD  0 dup(?)			;memory to hold the resulting value of calculation
sVal1 WORD 127			;sets the variable sVal1 to 127 decimal for calculation
sVal2 WORD -25			;sets the variable sVal2 to -25 decimal for calculation
iVal3 DWORD 78253		;sets the variable iVal3 to 78,253 decimal for calculation
bVal BYTE 78		;sets the variable of BVal to 78, 200 decimal for calculation

;******************************************************************************************
	.CODE
_start:					;entry point for this program (needed for debugger)

	MOV EAX, 0			;aids in debugging and initalizes the program
	
;************************************* the instruction below calls for "normal termination"	
	INVOKE ExitProcess,0
	PUBLIC _start
	END					;signals assembler that there are no instructions after this stmt