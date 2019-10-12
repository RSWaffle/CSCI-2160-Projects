;******************************************************************************************
;*  Program Name: strings.asm
;*  Programmer:   Ryan Shupe
;*  Class:        CSCI 2160-001
;*  Lab:          Proj3
;*  Date:         10/19/2019
;*  Purpose:      A couple string classes that can intake a string and count bytes, and 
;*				  also intake a string and copy it.
;******************************************************************************************
	.486						;This tells assembler to generate 32-bit code
	.model flat					;This tells assembler that all addresses are real addresses
	.stack 100h					;EVERY program needs to have a stack allocated
;******************************************************************************************
.code

COMMENT %
******************************************************************************
*Name: sizeOfString                                                          *
*Purpose:                                                                    *
*	counts the number of bytes in a string and returns the number in eax     *
*                                                                            *
*Date Created: 10/12/2019                                                    *
*Date Modified: 10/12/2019                                                   *
*                                                                            *
*                                                                            *
*@param String1:dword                                                        *
*@returns numOfBytes:dword													 *
*****************************************************************************%
sizeOfString PROC Near32
	PUSH EBP							;preserves base register
	MOV EBP, ESP						;sets a new stack frame
	PUSH EBX							;pushes EBX to the stack to store this
	PUSH ESI							;pushes ESI to the stack to preseve
	MOV EBX, [EBP + 8]					;moves into ebx the first val in the stack that we are going to use
	MOV ESI, 0							;sets the initial point to 0
		
	stLoop:
		CMP byte ptr [EBX + ESI], 0		;compares the two positions to determine if this is the end of the string
		JE finished						;if it is jump to finished
		INC ESI							;if not increment esi
		JMP stLoop						;jump to the top of the loop and look at the next char
	finished:		
		INC ESI							;increment esi to include the null character in the string
		MOV EAX, ESI					;move the value of esi into eax for proper output and return
	
	POP ESI								;restore original esi
	POP EBX								;restore original ebx
	RET									;return
sizeOfString ENDP

END