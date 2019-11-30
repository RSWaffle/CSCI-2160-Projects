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
	charTo4HexDigits PROTO stdcall, lpSourceString:dword
	encrypt32Bit PROTO stdcall, lpSourceString:dword, dMask:dword , numBytes:dword
;******************************************************************************************
.DATA
strChar	byte "ABCdeF05" ,0
strString byte "This is a sentence!!",0
hexNums dword 1234ABCDh
strHexChars byte 80 dup(?)	;holds converted string of characters
crlf byte  10,13,0								;Null-terminated string to skip to new line
hexKey DWORD ?


;******************************************************************************************
.CODE
	XOR EAX, EAX
_start:


INVOKE charTo4HexDigits, addr strChar
MOV hexKey, EAX
INVOKE putstring, addr crlf
INVOKE hexToCharacter, addr strHexChars, addr strString, 20
INVOKE putString, addr strHexChars

INVOKE encrypt32Bit, addr strString, hexKey, 20
MOV EBX, EAX
INVOKE putstring, addr crlf
INVOKE hexToCharacter, addr strHexChars, EAX, 20
INVOKE putString, addr strHexChars


INVOKE encrypt32Bit, EBX, hexKey, 20
INVOKE putstring, addr crlf
INVOKE hexToCharacter, addr strHexChars, EAX, 20
INVOKE putString, addr strHexChars

MOV EAX, 0

;************************************* the instructions below calls for "normal termination"	
INVOKE ExitProcess,0						 
PUBLIC _start
END