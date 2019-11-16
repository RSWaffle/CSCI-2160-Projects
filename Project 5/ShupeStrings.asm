;******************************************************************************************
;*  Program Name: ShupeStrings.asm
;*  Programmer:   Ryan Shupe
;*  Class:        CSCI 2160-001
;*  Date:         Created 10/19/2019
;*  Purpose:      A couple string methods that can manipulate a string and gather attributes
;******************************************************************************************
	.486						;This tells assembler to generate 32-bit code
	.model flat					;This tells assembler that all addresses are real addresses
	.stack 100h					;EVERY program needs to have a stack allocated
;******************************************************************************************
heapAllocHarrison PROTO Near32 stdcall, dSize:DWORD 							;Creates memory on the heap (of dSize words) and returns the address of the
getBytes PROTO Near32 stdcall, string:dword

COMMENT%
******************************************************************************
*Name: getBytes M                                                             *
*Purpose:                                                                    *
*	  Intakes an address and counts the number of bytes into a string including*
*     the null char and returns the number.                                  *
*Date Created: 10/24/2019                                                    *
*Date Modified: 10/25/2019                                                   *
*                                                                            *
*                                                                            *
*@param String1:byte                                                         *
*****************************************************************************%
getBytesM MACRO String:REQ
	LOCAL stLoop						;;add a local label so the assembler doesnt yell when this is called more than once
	LOCAL done							;;add a local label so the assembler doesnt yell when this is called more than once
	PUSH EBP							;;preserves base register
	MOV EBP, ESP						;;sets a new stack frame
	PUSH EBX							;;pushes EBX to the stack to store this
	PUSH ESI							;;pushes ESI to the stack to preseve
	MOV EBX, String						;;moves into ebx the first val in the stack that we are going to use
	MOV ESI, 0							;;sets the initial point to 0
		
	stLoop:
		CMP byte ptr [EBX + ESI], 0		;;compares the two positions to determine if this is the end of the string
		JE done							;;if it is jump to finished
		INC ESI							;;if not increment esi
		JMP stLoop						;;jump to the top of the loop and look at the next char
	done:		
		INC ESI							;;increment esi to include the null character in the string
		MOV EAX, ESI					;;move the value of esi into eax for proper output and return
	
	POP ESI								;;restore original esi
	POP EBX								;;restore original ebx
	POP EBP								;;restore originla ebp
ENDM
;******************************************************************************************
.data
	numBytes dword ?			;memory to hold the number of bytes in a string
	bChar byte ?				;memory to hold a char to put into memory 
	originalAddr dword ?		;original address of a string
	cpAddr dword ?				;new address of a string after copying

;******************************************************************************************
.code



COMMENT %
******************************************************************************
*Name: getBytes                                                              *
*Purpose:                                                                    *
*	counts the number of bytes in a string and returns the number in eax     *
*                                                                            *
*Date Created: 10/12/2019                                                    *
*Date Modified: 11/15/2019                                                   *
*                                                                            *
*                                                                            *
*@param String1:dword                                                        *
*@returns numOfBytes:dword													 *
*****************************************************************************%
getBytes PROC stdcall uses EDX ESI, String1:dword
	PUSH EBP							;;preserves base register
	MOV EBP, ESP						;;sets a new stack frame
	MOV EDX, String1					;;moves into ebx the first val in the stack that we are going to use
	MOV ESI, 0							;;sets the initial point to 0
		
	stLoop:
		CMP byte ptr [EDX + ESI], 0		;;compares the two positions to determine if this is the end of the string
		JE done							;;if it is jump to finished
		INC ESI							;;if not increment esi
		JMP stLoop						;;jump to the top of the loop and look at the next char
	done:		
		INC ESI							;;increment esi to include the null character in the string
		MOV EAX, ESI					;;move the value of esi into eax for proper output and return
	
	POP EBP								;;restore originla ebp
	RET 
getBytes ENDP

COMMENT%
******************************************************************************
*Name: appendString                                                          *
*Purpose:                                                                    *
*	  This method copies the null-terminated string starting at the address  *
*  indicated by the source parameter into the string starting at the address *
*  indicated by the destination. The destination string will be null-terminated*
*  after appending.                                                          *
*Date Created: 10/31/2019                                                    *
*Date Modified: 11/02/2019                                                   *
*                                                                            *
*                                                                            *
*@param lpDestination:dword                                                  *
*@param lpDSource:dword	                                                     *
*****************************************************************************%
appendString PROC Near32 stdcall uses EDX ECX EDI EBX, lpDestination:dword, lpSource:dword
	LOCAL numBytesToCopy:dword
	
	MOV EDX, lpSource				;moves the source address into EDX so we can get the number of current bytes
	getBytesM EDX					;call the getbytes macro so we get the current number of bytes. 
	MOV numBytesToCopy, EAX			;stores this into a local variable
	MOV EAX, lpDestination			;moves into EAX, the destination address
	getBytesM EAX					;call the getbytes macro so we get the current number of bytes. 
	MOV EDI, EAX					;stores the number of bytes in the output into EDI
	DEC EDI							;decrements edi so we ignore the null character the getBytes counts for
	MOV EBX, lpDestination			;moves the address of the output into ebx
	MOV ECX, numBytesToCopy			;moves the number of bytes to copy into ecx so we can loop
	ADD EBX, EDI 					;adds EDI to the initial address so we get the starting address were going to paste to
	
	lpCopyString:
		MOV EAX, [EDX]				;moves the current value at address edx into eax
		MOV [EBX], AL				;moves into the current address of ebx the value in AL
		INC EBX						;increments to the next position in the destination
		INC EDX						;increments to the next position in the source
	loop lpCopyString				;decrement ecx, and jump back to the top
	RET								;return back to where I was called from. 
appendString endp 

COMMENT %
******************************************************************************
*Name: createStringCopy                                                      *
*Purpose:                                                                    *
*	accepts an address, makes a copy, sends back new addr in EAX		     *
*                                                                            *
*Date Created: 10/12/2019                                                    *
*Date Modified: 11/15/2019                                                   *
*                                                                            *
*                                                                            *
*@param Addr1:dword                                                          *
*@returns Addr2:dword														 *
*****************************************************************************%
createStringCopy PROC stdcall uses EBX EDI EDX ESI, Addr1:dword
	PUSH EBP							;preserves base register
	MOV EBP, ESP						;sets a new stack frame

	MOV EBX, Addr1						;moves into ebx the address to the beginning of the original string.
	MOV originalAddr, EBX				;move the address in ebx into a variable
	MOV ESI, 0							;sets the initial point to 0
	MOV EDI, 0							;sets the initial offset to 0
	INVOKE getBytes, EBX
	MOV numBytes, EBX					;move the number of bytes in the string into its own variable
	MOV EBX, 0							;clear the ebx register so we can use it later. 

	INVOKE 	heapAllocHarrison, numBytes ;allocate space on the heap with the number of bytes we need. 
	MOV EDX, EAX						;move the address it gives us into its own variable 	
	MOV EAX, 0							;clear out eax to avoid issues
	MOV ESI, [originalAddr]				;move into EDI the derefrenced original address of the string
	topOfLoop:
		MOV BL, [ESI]					;move into BL the value at adress esi
		MOV bChar, BL					;move this into its variable 
		CMP bChar, 00					;compare it to 00 to see if we reached the end of the string
		JE finished						;if it is equal to 0, then jump to finished
		MOV AL, bChar					;moves the char into al so we can insert it at the new point
		MOV [EDX + EDI], EAX			;moves the value in eax into the new address offset edi
		INC EDI							;increment edi to get the next position in the new address
		INC ESI							;increment esi to get the next position in the original address
		JMP topOfLoop					;jump to the top of the loop with our incremented numbers. 
	finished:
		MOVSX EBX, bChar				;move into ebx the null character
		MOV [EDX + EDI], EBX			;moves the null character into the position in the new address
	MOV EAX, OFFSET cpAddr				;moves the address of the copyed address into EAX for return
	
	POP EBP								;restore original ebp
	RET	4								;return
createStringCopy ENDP
END