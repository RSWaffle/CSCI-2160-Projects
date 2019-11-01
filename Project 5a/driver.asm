;******************************************************************************************
;*  Program Name: proj4.asm
;*  Programmer:   Ryan Shupe
;*  Class:        CSCI 2160-001 
;*  Lab:          Proj5a
;*  Date:         11/02/2019
;*  Purpose:      
;******************************************************************************************
	.486						;This tells assembler to generate 32-bit code
	.model flat					;This tells assembler that all addresses are real addresses
	.stack 100h					;EVERY program needs to have a stack allocated
;*****************************************************************************************
;  List all necessary prototypes for methods to be called here

	ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD 
		getTime				PROTO Near32 stdcall

;*****************************************************************************************
.DATA
;*****************************************************************************************
.CODE
_start:

	MOV EAX, 0
	
	INVOKE getTime
	
	MOV EAX, -1
	
INVOKE ExitProcess, 0
PUBLIC _start
END