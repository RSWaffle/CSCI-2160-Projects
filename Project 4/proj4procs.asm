;******************************************************************************************
;*  Program Name: proj4procs.asm
;*  Programmer:   Ryan Shupe
;*  Class:        CSCI 2160-001
;*  Lab:          Proj3
;*  Date:         11/02/2019
;*  Purpose:      This handles the manipulation of matrices. 
;******************************************************************************************

	.486						;This tells assembler to generate 32-bit code

	.model flat					;This tells assembler that all addresses are real addresses

	.stack 100h					;EVERY program needs to have a stack allocated

;******************************************************************************************

;  List all necessary prototypes for methods to be called here

	ascint32 PROTO NEAR32 stdcall, lpStringToConvert:dword  				;This converts ASCII characters to the dword value
;******************************************************************************************
.DATA
	WhiteListChars byte 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 45, 43		;set of whitelisted characters, 0 1 2 3 4 5 6 7 8 9 + - 
		
	bTemps byte ?															;memory to hold the number that is built in extractDwords

;******************************************************************************************
.CODE

	COMMENT %
********************************************************************************
*Name: extractDwords                                                           *
*Purpose:                                                                      *
*	     This method takes in two addresses, one with ascii characters and one *
*        where the converted numbers will go. It translates the ascii character*
*		 to the dword value and stores into the output location    			   *
*Date Created: 10/23/2019                                                      *
*Date Modified: 10/23/2019                                                     *
*                                                                              *
*                                                                              *
*@param StringofChars:dword                                                    *
*@param ArrayDwords:dword												 	   *
*******************************************************************************%
extractDwords PROC Near32 C uses EBX ECX EDX EDI , StringofChars:dword, ArrayDwords:dword
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
			ADD addOut, 4						;adds 4 to the output address so we can get the next dword starting point
			MOV EDI, 0							;resets edi to 0 so we get a clean bTemps variable
			INC addASCII						;increments addASCII so we get the next byte in memory
			JMP lpConvertandMove				;jump back up to the very top of the loop 
			
		ValidNextChar:
			INC EDI								;increment edi so we can input in the next position in bTemps
			INC addASCII						;increment addASCII so we get the next byte in memory
			JMP lpConvertandMove				;jump back up to the very top of the loop
			
			
	finished:
		RET										;return back to where i was called 
extractDwords ENDP 

END