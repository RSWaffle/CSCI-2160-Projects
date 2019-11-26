
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
x dword 5
;******************************************************************************************
.CODE

_start:

	MOV EAX, 0
main PROC

	PUSH x
	call fun
	ADD esp, 4
main ENDP



COMMENT%

******************************************************************************
*Name: fun	                                                                 *
*Purpose:                                                                    *
*	  A recursive equation for fun(n-1) + 2*fun(n-2)+3*fun(n-3), for n>2     *
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
	
	@n EQU DWORD PTR [EBP + 8]			;point @n to ebp + 8 so we don't have to reference it all the time
	PUSH @n								;preserve the value @n points to
	
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
	
	MOV EBX, @n							;moves the n value into ebx
	DEC EBX								;decrement it to get n-1
	PUSH EBX							;push to the stack for calling
	CALL fun							;call the function again
	ADD ESP, 4							;add back the number of bytes we used
	
	MOV EDX, EAX
	
	MOV EBX, @n							;moves the n value into ebx
	DEC EBX								;decrement it to get n-1
	DEC EBX								;decrement it to get n-2
	PUSH EBX							;push to the stack for calling
	CALL fun							;call the function again
	ADD ESP, 4							;add back the number of bytes we used
	ADD EAX, EAX
	ADD EDX, EAX
	
	MOV EBX, @n							;moves the n value into ebx
	DEC EBX								;decrement it to get n-1
	DEC EBX								;decrement it to get n-2
	DEC EBX								;decrement it to get n-3
	PUSH EBX							;push to the stack for calling
CALL fun							;call the function again
	ADD ESP, 4							;add back the number of bytes we used
	MOV ECX, EAX
	ADD EAX, EAX
	ADD EAX, ECX
	ADD EDX, EAX
	
	
	Done:
	POP EBX
	POP EBP								;restore the original EBP
	RET 								;return 
fun ENDP
	
;************************************* the instructions below calls for "normal termination"	
INVOKE ExitProcess,0						 
PUBLIC _start
END