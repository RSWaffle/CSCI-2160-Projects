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
dVal dword ?
;******************************************************************************************

.CODE
_start:
	XOR EAX, EAX						;set EAX to 0 to initialize
	XOR EDX, EDX						;set EDX to 0 to initialize
	XOR ECX, ECX						;set ECX to 0 to initialize
	
main PROC
	PUSH x								;push the number we want to sent into the function to the stack
	CALL fun							;call our recursive function
	ADD esp, 4							;add back the number of bytes we pushed on to the stack 
	JMP finish							;jump to the finish label so we don't execute the below code and mess everything up
main ENDP

COMMENT%
******************************************************************************
*Name: fun	                                                                 *
*Purpose:                                                                    *
*	  A recursive equation for fun(n-1) + 2(fun(n-2))+ 3(fun(n-3)), for n > 2*
*		 						     		 								 *
*Date Created: 11/26/2019                                                    *
*Date Modified: 12/03/2019                                                   *
*                                                                            *
*                                                                            *
*@param inVal:dword                                                          *
*@returns result:dword                                                       *
*****************************************************************************%
fun PROC stdcall
	PUSH EBP 							;preserve the old stack frame
	MOV EBP, ESP						;set a new stack frame

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

	MOV EBX, @n							;moves the value passed in into EBX so we can prepare it to pass 
	DEC EBX								;decrement to get n-1
	PUSH EBX							;push n-1 onto the stack so we can push it through the function again
	INC ECX								;increment ECX so we can track how many times we need to return later
	CALL fun							;call our function again
	ADD ESP, 4							;eventually return back to this point and add back the number of bytes that we pushed onto the stack

	.WHILE	ECX != 1					;while ECX is not equal to 1
		DEC ECX							;decrement so the loop eventually stops
		JMP Done						;jump to done so we can return the required number of times to restore ebp from the base call
	.ENDW								;end while

	ADD dVal, EAX						;add to the temp variable dVal the number that was returned from the first function call

	XOR ECX, ECX						;reset ECX
	MOV EBX, @n							;moves the value passed in into EBX so we can prepare it to pass 
	DEC EBX								;decrement to get n-1
	DEC EBX								;decrement to get n-2
	PUSH EBX							;push n-2 onto the stack so we can push it to the next call
	CALL fun							;call our function again
	ADD ESP, 4							;eventually return back to this point, add back the number of bytes that we used 
	ADD EAX, EAX						;add EAX to EAX to simulate 2 * f(n-2)
	ADD dVal, EAX						;add to our temp dVal variable, the resulting value in EAX

	XOR ECX, ECX						;reset ECX
	MOV EBX, @n							;moves the value passed in into EBX so we can prepare it to pass 
	DEC EBX								;decrement to get n-1
	DEC EBX								;decrement to get n-2
	DEC EBX								;decrement to get n-3
	PUSH EBX							;push n-3 onto the stack so we can push it to the next call
	CALL fun							;call our function again
	ADD ESP, 4							;eventually return back to this point, add back the number of bytes that we used 
	
	MOV EDX, EAX						;moves into EDX EAX so we can store it for a bit
	ADD EAX, EAX						;Add the two EAX registers together to get 2 * f(n-3)
	ADD EAX, EDX						;add into EAX, EDX which will get us 3 * f(n-3)
	ADD dVal, EAX						;add the resulting EAX value into dVal
	MOV EAX, dVal						;move the final dVal value into EAX for output

Done:
	POP EBP								;restore EBP
	RET									;return to where I was called. 
fun ENDP

;************************************* the instructions below calls for "normal termination"
finish:	
INVOKE ExitProcess,0						 
PUBLIC _start
END