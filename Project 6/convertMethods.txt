;******************************************************************************************
;*  Program Name: convertMethods.asm
;*  Programmer:   Ryan Shupe
;*  Class:        CSCI 2160-001
;*  Lab:		  Project 6b
;*  Date:         Created 12/07/2019
;*  Purpose:      Methods to convert hex characters to the relative ACII version. Vise versa with a d-word mask maker
;*					and a 32-bit encryption method to encrypt strings.
;******************************************************************************************
	.486						;This tells assembler to generate 32-bit code
	.model flat					;This tells assembler that all addresses are real addresses
	.stack 100h					;EVERY program needs to have a stack allocated
;******************************************************************************************
	ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD			;Executes "normal" termination
	memoryallocBailey PROTO Near32 stdcall, dSize:DWORD			;dynamically allocate bytes in memory
;******************************************************************************************
COMMENT %

******************************************************************************
*Name: getBytes                                                              *
*Purpose:                                                                    *
*	  Intakes an address and counts the number of bytes into a string including*
*     the null char and returns the number.                                  *
*Date Created: 10/24/2019                                                    *
*Date Modified: 10/25/2019                                                   *
*                                                                            *
*@param String1:byte                                                         *
*****************************************************************************%
getBytes MACRO String:REQ
	LOCAL stLoop						;;add a local label so the assembler doesn't yell when this is called more than once
	LOCAL done							;;add a local label so the assembler doesn't yell when this is called more than once
	PUSH EBP							;;preserves base register
	MOV EBP, ESP						;;sets a new stack frame
	PUSH EBX							;;pushes EBX to the stack to store this
	PUSH ESI							;;pushes ESI to the stack to preserve
	MOV EBX, String						;;moves into EBX the first val in the stack that we are going to use
	MOV ESI, 0							;;sets the initial point to 0
		
	stLoop:
		CMP byte ptr [EBX + ESI], 0		;;compares the two positions to determine if this is the end of the string
		JE done							;;if it is jump to finished
		INC ESI							;;if not increment ESI
		JMP stLoop						;;jump to the top of the loop and look at the next char
	done:		
		INC ESI							;;increment ESI to include the null character in the string
		MOV EAX, ESI					;;move the value of ESI into EAX for proper output and return
	
	POP ESI								;;restore original ESI
	POP EBX								;;restore original EBX
	POP EBP								;;restore original EBP
ENDM
;******************************************************************************************
.DATA
	WhiteListChars byte 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 61h, 62h, 63h, 64h, 65h, 66h, 41h, 42h, 43h, 44h, 45h, 46h 		
										;set of white-listed characters, 0 1 2 3 4 5 6 7 8 9 ABCDEF abcdef
	bTemps byte 50 dup(?)				;memory to hold the number that is built in extractDwords
	crlf byte  10,13,0					;Null-terminated string to skip to new line
;******************************************************************************************
.CODE
COMMENT%
******************************************************************************
*Name: hexToCharacter                                                        *
*Purpose:                                                                    *
*	  Intakes a address of hex chars, converts them to ascii, then returns a *
*		new address with ascii characters									 *
*Date Created: 11/28/2019                                                    *
*Date Modified: 11/28/2019                                                   *
*                                                                            *
*@param lpDestination:dword                                                  *
*@param lpSource:dword                                                       *
*@param numBytes:dword                                                       *
*****************************************************************************%
hexToCharacter PROC stdcall uses EBX EDX EDI ESI, lpDestination:dword, lpSource:dword, numBytes:dword
LOCAL tempByte:byte				;sets up our stack frame and declares our local variables.
MOV EBX, numBytes				;move the number of bytes to be copied into EBX

.IF EBX == 0					;if it is equal to 0
	MOV EDI, 4					;if the number of bytes is 0, then we are going to treat the 2nd param as a d-word
	
	MOV EBX, lpSource			;load the address of the source into EBX
	MOV EDX, lpDestination		;load the address of the destination into EDX
	MOV ESI, 0					;set the starting point in the destination 

	.WHILE EDI != 0				;while there are still bytes to copy
		DEC EDI					;get 1 less the max
		MOV AL, [EBX + EDI]		;retrieve the byte at position EBX + n
		SHR AL , 4				;shift the bits right to clear out the bits below to get the LO

		.IF AL >= 10			;if the nibble grabbed is greater than or equal to 10
			ADD AL, 87			;we need to add 87 to get the correct hex value
		.ELSE					;if it is not
			ADD AL, 48			;we need to add 48 to get the correct hex value
		.ENDIF					;end if
		
		MOV [EDX + ESI], AL		;move into the destination our hex digit
		INC ESI					;increment to the next output position
		
		MOV AL, [EBX + EDI]		;move the same byte into AL 
		SHL AL , 4				;clear out the bits above so we get the HO of the byte
		SHR AL , 4				;shift it back so we can properly do calculation

		.IF AL >= 10			;if the nibble grabbed is greater than or equal to 10
			ADD AL, 87			;we need to add 87 to get the correct hex value
		.ELSE					;if it is not
			ADD AL, 48			;we need to add 48 to get the correct hex value
		.ENDIF					;end if
		
		MOV [EDX + ESI], AL		;move into the destination our hex digit
		INC ESI					;increment to the next output position
	.ENDW						;end while

	MOV AL, 0					;move null character into AL
	MOV [EDX + ESI], AL			;append null

.ELSE							;if it is not 0
	MOV ECX, EBX				;if it is not 0 then we will put the number of bytes to be converted into EDI
	
	MOV EBX, lpSource			;load the address of the source into EBX
	MOV EDX, lpDestination		;load the address of the destination into EEDX
	MOV ESI, 0					;set the starting point in the destination 
	MOV EDI, 0					;set initial position to place output to 0
	.REPEAT
		DEC ECX					;get n-1 bytes so we don't interfere with the do while
		
		MOV AL, [EBX + ESI]		;retrieve the byte at position EBX + n
		MOV tempByte, AL
		SHR AL , 4				;shift the bits right to clear out the bits below to get the LO

		.IF AL >= 10			;if the nibble grabbed is greater than or equal to 10
			ADD AL, 87			;we need to add 87 to get the correct hex value
		.ELSE					;if it is not
			ADD AL, 48			;we need to add 48 to get the correct hex value
		.ENDIF					;end if
		
		MOV [EDX + EDI], AL		;move into the destination our hex digit
		INC EDI					;increment to next output position
		INC ESI					;increment to the next byte to grab
		
		MOV AL, tempByte		;move the same byte into AL 
		SHL AL , 4				;clear out the bits above so we get the HO of the byte
		SHR AL , 4				;shift it back so we can properly do calculation

		.IF AL >= 10			;if the nibble grabbed is greater than or equal to 10
			ADD AL, 87			;we need to add 87 to get the correct hex value
		.ELSE					;if it is not
			ADD AL, 48			;we need to add 48 to get the correct hex value
		.ENDIF					;end if
		
		MOV [EDX + EDI], AL		;move into the destination our hex digit
		INC EDI					;increment to next output position
		
	.UNTIL ECX == 0				;repeat until there are no more bytes
	
	MOV AL, 0					;move null character into AL
	MOV [EDX + EDI], AL			;append null
.ENDIF							;end if
	
RET 							;return back with 12 bytes used
hexToCharacter ENDP

COMMENT%
******************************************************************************
*Name: charTo4HexDigits                                                      *
*Purpose:                                                                    *
*	  Accepts a null terminated strings and returns a dword mask    		 *
*Date Created: 11/28/2019                                                    *
*Date Modified: 11/29/2019                                                   *
*                                                                            *
*@param lpSourceString:dword                                                 *
*@returns dMask:dword                                                        *
*****************************************************************************%
charTo4HexDigits PROC stdcall uses EBX ECX EDX EDI ESI, lpSourceString:dword
LOCAL outVal:dword, inASCII:dword, numBytes:Byte;sets up our stack frame and declares our local variables.
	MOV EAX, lpSourceString						;moves into EAX the address of the array with ASCII values.
	MOV inASCII, EAX							;moves the address into our local variable for clarity.

	getBytes EAX								;get the number of bytes to see if it is bigger than 4 bytes
	MOV numBytes, AL							;store the number of bytes for later calculation
	.IF AL > 9 || AL < 9						;if they're more or less than 4 bytes then 
		MOV EAX, -1								;move -1 into the output
		JMP finished							;jump to return 
	.ENDIF										;end if
	
	MOV EBX, 0									;set EBX to 0 to avoid calculation error
	MOV EDI, 0									;sets our initial point in bTemps to the first place
	
	lpConvertandMove:	
		MOV EAX, inASCII						;moves the address of the ASCII values into EAX so we can reference it
		MOV BL, byte ptr [EAX]					;moves into BL the byte at the address position
		CMP BL, 00								;compares this byte to 00 to test if we are at the end of the array
		JE Packnfinish							;if it is equal to 00, then jump to the finished label. 
		
		MOV ECX, lengthof WhiteListChars		;sets up our loop with the number of elements in the white-listed characters array
		MOV ESI, 0								;set initial offset in the white-list to 0
		
		lpCompareWhitelist:
			CMP BL, WhiteListChars[ESI]			;compares bl to see if it is one of the white-listed characters
			JE ValidChar						;if it is a valid char, jump to the valid section
			INC ESI								;increment ESI to the next position in the white-listed characters array
		loop lpCompareWhitelist					;decrement ECX and loop back up
												;if it is not a valid char this executes
		
		INC inASCII								;increment inASCII so we get the next byte
		JMP lpConvertandMove					;jump back up to the top to start the loop over again
		
		ValidChar:
			MOV bTemps[EDI], BL					;Moves into btemps at position EDI the byte in bl to hold that byte of the number that is building
			INC inASCII							;increment to the next position of inASCII so we can see if the next char is valid
			MOV EAX, inASCII					;moves into EAX the new address of the next byte 
			MOV BL, byte ptr [EAX]				;moves the byte into Bl 
			DEC inASCII							;change it back to the previous character
			
			MOV ECX, lengthof WhiteListChars	;adds the number of elements in white-listed characters array into ECX for the loop
			MOV ESI, 0							;sets our initial position in the white-listed characters array to 0
		
			lpCompareNext:
				CMP BL, WhiteListChars[ESI]		;This compares the next byte to see if it is white-listed too
				JE ValidNextChar				;if it is a valid character, jump to the valid next char section
				INC ESI							;increment ESI if it is not valid to get to the next position in white-listed characters
			loop lpCompareNext					;decrement ECX and go to the top of the current loop
			
			INC inASCII							;increments inASCII so we get the next byte in memory
			JMP lpConvertandMove				;jump back up to the very top of the loop 
			
		ValidNextChar:
			INC EDI								;increment EDI so we can input in the next position in bTemps
			INC inASCII							;increment inASCII so we get the next byte in memory
			JMP lpConvertandMove				;jump back up to the very top of the loop
						
	Packnfinish:
		MOV ESI, 0								;sets our initial position in the bvals array to 0	
		MOVSX AX, numBytes						;moves the number of bytes into ax
		MOV BL, 2								;we need to divide by two so the loop doesn't execute more than it needs to
		iDIV BL									;divide by 2
		MOV CL, AL								;move the resulting number into cl for looping
		MOV EAX, 0								;clear out EAX so we don't get any calculation errors
		
		.WHILE ECX != 0							;while cl is not equal to 0, execute the loop
			MOV BL, bTemps[ESI]					;move the current byte into bl
			.IF BL < 30h && BL < 41h || BL > 46h && BL < 61h || BL > 66h
												;the above statement checks to see if the current character is invalid
				MOV EAX, -1						;move -1 into the output
				JMP finished					;jump to return 
			.ENDIF								;end if
			
			.IF BL >= 65						;if the nibble grabbed is greater than or equal to 10
				SUB BL, 55						;we need to sub 55 to get the correct hex value
			.ELSE								;if it is not
				SUB BL, 48						;we need to sub 48 to get the correct hex value
			.ENDIF								;end if
			
			SHL BX, 8							;shift bx over to get it out of bl so we don't override it
			INC ESI								;increment ESI if it is not valid to get to the next position in white-listed characters
			
			MOV BL, bTemps[ESI]					;move the current byte into bl
			.IF BL < 30h && BL < 41h || BL > 46h && BL < 61h || BL > 66h
												;the above statement checks to see if the current character is invalid
				MOV EAX, -1						;move -1 into the output
				JMP finished					;jump to return 
			.ENDIF
			
			.IF BL >= 65						;if the nibble grabbed is greater than or equal to 10
				SUB BL, 55						;we need to sub 55 to get the correct hex value
			.ELSE								;if it is not
				SUB BL, 48						;we need to sub 48 to get the correct hex value
			.ENDIF								;end if
			
			SHL BL, 4							;shift bl over by 4 bytes so it lines up with the previously pushed nibble
			SHR BX, 4							;shift bx back to get the value into bl
			MOV AL, BL							;move the result into AL
			
			.IF ECX != 1						;if we are not in the last iteration of the loop
				SHL EAX, 8						;shift EAX left to make room for a new value
			.ENDIF								;end if

			INC ESI								;increment ESI if it is not valid to get to the next position in white-listed characters
			DEC ECX								;decrement ECX to eventually terminate the loop
		.ENDW									;go to the top of the current loop

	finished:
		RET										;return back to where i was called 
charTo4HexDigits ENDP

COMMENT%
******************************************************************************
*Name: encrypt32Bit                                                          *
*Purpose:                                                                    *
*	  Intakes a source string, a mask and the number of bytes, encryptes them*
*		and returns a new address with the encripted values                  *
*Date Created: 11/28/2019                                                    *
*Date Modified: 11/30/2019                                                   *
*                                                                            *
*@param lpSourceString:dword                                                 *
*@param dMask:dword                                                          *
*@param numBytes:dword                                                       *
*@returns encryptedAddr:dword                                                *
*****************************************************************************%
encrypt32Bit PROC stdcall uses EBX ECX EDX ESI, lpSourceString:dword, dMask:dword , numBytes:dword
LOCAL outAddr:dword, remainder:byte 		;set up stack frame and declare local variables

	INVOKE memoryallocBailey, numBytes		;allocate enough memory on the heap to store the output 
	MOV outAddr, EAX						;stores the output address inside a local variable

	MOV EAX, numBytes						;move the number of bytes into EAX so we can calculate if string is appropriate size
	MOV EBX, 4								;move into EBX 4 so we can divide
	XOR EDX, EDX							;set EDX to 0
	DIV EBX									;divide by 4 to get remainder 
	MOV remainder, DL						;store the remainder
	MOVSX ECX, AX							;move the number of times 4 goes into the number of bytes into ECX

	MOV EAX, dMask							;move the mask passed in into EAX
	XOR ESI, ESI							;set ESI to 0
	XOR EBX, EBX							;set EBX to 0

	.WHILE ECX !=0							;while ECX is not 0
		MOV EDX, lpSourceString				;move the source string into EDX
		MOV EBX, [EDX + ESI]				;move the 4 bytes in location EDX + ESI into EBX
		XOR EBX, EAX						;XOR the two registers together for encryption
		MOV EDX, outAddr					;moves the out address into EDX
		MOV [EDX + ESI], EBX				;moves the encrypted 4 bytes into the output address location
		
		ADD ESI, 4							;add 4 to ESI to get the next 4 bytes
		DEC ECX								;decrement ECX so we can terminate the loop
	.ENDW

	MOVSX EBX, remainder					;move the remainder into EBX
	.IF remainder == 0						;if the remainder is 0, we are done
		JMP Done							;jump to done
	.ELSEIF remainder == 1					;if the remainder is 1
		MOV CL, 24							;move the number of bits we need to shift
	.ELSEIF remainder ==2 					;if the remainder is 2
		MOV CL, 16							;move into CL the number of bits we need to shift
	.ELSE 									;if the remainder is 3
		MOV CL, 8							;move into CL the number of bits we need to shift
	.ENDIF									;end if

	MOV EAX, dMask							;move the mask into EAX for encryption of the remaining bits
	SHR EAX, CL								;shift the mask CL number of bits to appropriately encrypt
	XOR EBX, EBX							;set EBX to 0
		
	MOV EDX, lpSourceString					;move the source string into EDX
	MOV EBX, [EDX + ESI]					;move the 4 bytes in location EDX + ESI into EBX
	XOR EBX, EAX							;XOR the two registers together for encryption
	MOV EDX, outAddr						;moves the out address into EDX
	MOV [EDX + ESI], EBX					;moves the encrypted 4 bytes into the output address location

	Done:
		MOV EAX, outAddr					;move the encrypted output address into EAX
		RET									;return to where I was called from
encrypt32Bit ENDP
;************************************* the instructions below calls for "normal termination"	

END