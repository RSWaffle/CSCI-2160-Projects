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
