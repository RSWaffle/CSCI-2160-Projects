
;******************************************************************************************
;*  Program Name: Proj6a.asm
;*  Programmer:   Ryan Shupe
;*  Class:        CSCI 2160-001
;*  Lab:		  Project 6a
;*  Date:         Created 12/07/2019
;*  Purpose:      Calculates though a recursion problem outlined in the project specs
;******************************************************************************************
	.486						;This tells assembler to generate 32-bit code
	.model flat					;This tells assembler that all addresses are real addresses
	.stack 100h					;EVERY program needs to have a stack allocated
;******************************************************************************************
	ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD  						;Executes "normal" termination
;******************************************************************************************
.DATA
x dword 4
dVal dword ?
temp dword ?
;******************************************************************************************
.CODE

_start:

	MOV EAX, 0
	MOV EDX, 0
	XOR ECX, ECX
main PROC

	PUSH x
	MOV temp, ESP
	call fun
	ADD esp, 4
	JMP finish
main ENDP



COMMENT%

******************************************************************************
*Name: fun	                                                                 *
*Purpose:                                                                    *
*	  A recursive equation for fun(n-1) + 2(fun(n-2))+ 3(fun(n-3)), for n>2     *
*		 					possible array to track the results	     		 *
*Date Created: 11/26/2019                                                    *
*Date Modified: 11/26/2019                                                   *
*                                                                            *
*                                                                            *
*@param inVal:dword                                                          *
*****************************************************************************%
fun PROC stdcall
	PUSH EBP 							;preserve the old stack frame
	MOV EBP, ESP						;set a new stack frame
	MOV temp, EBP
	
	@n EQU DWORD PTR [EBP + 8]			;point @n to ebp + 8 so we don't have to reference it all the time

	
	.IF @n == 1							;if @n is equal to 1
		MOV EAX, 2						;move 2 into the output

		JMP Done						;jump to done section
	.ELSEIF @n == 0						;if @n is equal to 0
		MOV EAX, 1						;move 1 into the output

		JMP Done						;jump to done
	.ELSEIF @n == 2						;if @n is equal to 2
		MOV EAX, 7						;move 7 into the output	

		JMP Done						;jump to the done section
	.ENDIF								;end if

	MOV EBX, @n
	DEC EBX
	PUSH EBX
	INC ECX
	CALL fun
	ADD ESP, 4
	
	.WHILE	ECX != 1
		DEC ECX
		JMP Done
		
	.ENDW
	
	.IF ECX == 1 && EDX == 1
	
		ADD EAX, EAX
		JMP Done
		
	.ENDIF
	
	.IF ECX == 1 && EDX == 2
	
		MOV EDX, EAX
		ADD EAX, EAX
		ADD EAX, EDX
		
		JMP Done
		
	.ENDIF
	
	ADD dVal, EAX
	
	MOV ECX, 0
	MOV EDX, 1
	MOV EBX, @n
	DEC EBX
	DEC EBX
	PUSH EBX
	CALL fun
	ADD ESP, 4

	ADD dVal, EAX
	
	MOV ECX, 0

	MOV EBX, @n
	DEC EBX
	DEC EBX
	DEC EBX
	PUSH EBX
	CALL fun
	ADD ESP, 4
	
	MOV EDX, EAX
	ADD EAX, EAX
	ADD EAX, EDX
	
	ADD dVal, EAX
	
Done:
	
	POP EBP
	RET
fun ENDP
	
finish:
;************************************* the instructions below calls for "normal termination"	
INVOKE ExitProcess,0						 
PUBLIC _start
END