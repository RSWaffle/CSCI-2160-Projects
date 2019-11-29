;******************************************************************************************
;*  Program Name: Proj6a.asm
;*  Programmer:   Ryan Shupe
;*  Class:        CSCI 2160-001
;*  Lab:		  Project 6a
;*  Date:         Created 12/07/2019
;*  Purpose:      Driver to test the methods written in convertMethods
;******************************************************************************************
	.486						;This tells assembler to generate 32-bit code
	.model flat					;This tells assembler that all addresses are real addresses
	.stack 100h					;EVERY program needs to have a stack allocated
;******************************************************************************************
	ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD  						;Executes "normal" termination
	putstring  PROTO NEAR stdcall, lpStringToDisplay:dword
	hexToCharacter PROTO stdcall, lpDestination:dword, lpSource:dword, numBytes:dword
;******************************************************************************************
.DATA
strChar	byte "ABCDEFG" ,0
hexNums dword 1234ABCDh
strHexChars byte 80 dup(?)	;holds converted string of characters


;******************************************************************************************
.CODE
	XOR EAX, EAX
_start:

INVOKE hexToCharacter, addr strHexChars, addr strChar, 8
INVOKE putstring, addr strHexChars

MOV EAX, 0

;************************************* the instructions below calls for "normal termination"	
INVOKE ExitProcess,0						 
PUBLIC _start
END