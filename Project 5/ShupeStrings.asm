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
memoryallocBailey PROTO Near32 stdcall, dSize:DWORD 							;Creates memory on the heap (of dSize words) and returns the address of the
getBytes PROTO Near32 stdcall, string:dword
ascint32 PROTO NEAR32 stdcall, lpStringToConvert:dword  				;This converts ASCII characters to the dword value

COMMENT%
******************************************************************************
*Name: getBytes                                                              *
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
	WhiteListChars byte 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 45, 43		;set of whitelisted characters, 0 1 2 3 4 5 6 7 8 9 + -
	bTemps byte 0 dup(?)													;memory to hold the number that is built in extractDwords

;******************************************************************************************
.code


COMMENT %
********************************************************************************
*Name: extractWords                                                            *
*Purpose:                                                                      *
*	     This method takes in two addresses, one with ascii characters and one *
*        where the converted numbers will go. It translates the ascii character*
*		 to the word value and stores into the output location    			   *
*Date Created: 11/20/2019                                                      *
*Date Modified: 11/20/2019                                                     *
*                                                                              *
*                                                                              *
*@param StringofChars:dword                                                    *
*@param ArrayDwords:dword												 	   *
*******************************************************************************%
extractWords PROC Near32 stdcall uses EBX ECX EDX EDI , StringofChars:dword, ArrayDwords:dword
	LOCAL addOut:dword, addASCII:dword			;sets up our stack frame and declares our local variables. 
	
	MOV EAX, ArrayDwords						;moves into EAX the address of the output array
	MOV addOut, EAX								;moves the address into our local variable for clarity.
	MOV EAX, StringofChars						;moves into EAX the address of the array with ascii values.
	MOV addASCII, EAX							;moves the address into our local variable for clarity.
	
	MOV EBX, 0									;set EBX to 0 to avoid calculation error
	MOV EDI, 0									;sets our initial point in bTemps to the first place
	
	lpConvertandMove:	
		MOV EAX, addASCII						;moves the address of the ascii values into eax so we can reference it
		MOV BL, byte ptr [EAX]					;moves into BL the byte at the address position
		CMP BL, 00								;compares this byte to 00 to test if we are at the end of the array
		JE finished								;if it is equal to 00, then jump to the finished label. 
		
		MOV ECX, lengthof WhiteListChars		;sets up our loop with the number of elements in the whitelisted characters array
		MOV ESI, 0								;sets our initial position in the whitelisted characters array to 0
		
		lpCompareWhitelist:
			CMP BL, WhiteListChars[ESI]			;compares bl to see if it is one of the whitelisted characters
			JE ValidChar						;if it is a valid char, jump to the valid section
			INC ESI								;increment esi to the next position in the whitelisted characters array
		loop lpCompareWhitelist					;decrement ecx and loop back up
												;if it is not a valid char this executes:
		INC addASCII							;increment addASCII so we get the next byte
		JMP lpConvertandMove					;jump back up to the top to start the loop over again
		
		ValidChar:
			MOV bTemps[EDI], BL					;Moves into btemps at position edi the byte in bl to hold that byte of the number that is building
			INC addASCII						;increment to the next position of addascii so we can see if the next char is valid
			MOV EAX, addASCII					;moves into eax the new address of the next byte 
			MOV BL, byte ptr [EAX]				;moves the byte into Bl 
			DEC addASCII						;change it back to the previous character
			
			MOV ECX, lengthof WhiteListChars	;adds the number of elements in whitelisted characters array into ecx for the loop
			MOV ESI, 0							;sets our initial position in the whitelisted characters array to 0
		
			lpCompareNext:
				CMP BL, WhiteListChars[ESI]		;This compares the next byte to see if it is whitelisted too
				JE ValidNextChar				;if it is a valid character, jump to the valid next char section
				INC ESI							;increment esi if it is not valid to get to the next position in whitelisted characters
			loop lpCompareNext					;decrement ECX and go to the top of the current loop
			
			INVOKE ascint32, ADDR bTemps		;if it is not a valid character, then we know the number is complete and we can execute asc to int conversion
			MOV EDX, addOut						;moves the address of the output array into edx so we can reference it
			MOV [EDX], EAX						;moves the resulting EAX value into the output array at the correct position
			MOV ECX, 4							;imputs 4 into ECX so we can clear our bTemps variable to prevent curruption
			lpClearBTemp:
				MOV [bTemps + ECX], 0			;moves 0 into the slot ECX of bTemps
			loop  lpClearBTemp					;jump back to the top of the current loop
			ADD addOut, 2						;adds 4 to the output address so we can get the next dword starting point
			MOV EDI, 0							;resets edi to 0 so we get a clean bTemps variable
			INC addASCII						;increments addASCII so we get the next byte in memory
			JMP lpConvertandMove				;jump back up to the very top of the loop 
			
		ValidNextChar:
			INC EDI								;increment edi so we can input in the next position in bTemps
			INC addASCII						;increment addASCII so we get the next byte in memory
			JMP lpConvertandMove				;jump back up to the very top of the loop
				
	finished:
		RET	8									;return back to where i was called 
extractWords ENDP 

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
	RET 4
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
	RET	8							;return back to where I was called from. 
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

	INVOKE 	memoryallocBailey, numBytes ;allocate space on the heap with the number of bytes we need. 
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