;******************************************************************************************
;*  Program Name: convertMethods.asm
;*  Programmer:   Ryan Shupe
;*  Class:        CSCI 2160-001
;*  Lab:		  Project 6b
;*  Date:         Created 12/07/2019
;*  Purpose:      Methods to convert ascii characters to hex characters and vise versa, with encryption
;******************************************************************************************
	.486						;This tells assembler to generate 32-bit code
	.model flat					;This tells assembler that all addresses are real addresses
	.stack 100h					;EVERY program needs to have a stack allocated
;******************************************************************************************
	ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD  						;Executes "normal" termination
	memoryallocBailey PROTO Near32 stdcall, dSize:DWORD							;dynamically allocate bytes in memory
;******************************************************************************************
.DATA
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
LOCAL tempByte:byte
MOV EBX, numBytes				;move the number of bytes to be copied into ebx

.IF EBX == 0					;if it is equal to 0
	MOV EDI, 4					;if the number of bytes is 0, then we are going to treat the 2nd param as a dword
	
	MOV EBX, lpSource			;load the address of the source into ebx
	MOV EDX, lpDestination		;load the address of the destination into edx
	MOV ESI, 0					;set the starting point in the destination 

	.WHILE EDI != 0				;while there are still bytes to copy
		DEC EDI					;get 1 less the max
		MOV AL, [EBX + EDI]		;retreive the byte at position ebx + n
		SHR AL , 4				;shift the bits right to clear out the bits below to get the LO

		.IF AL >= 10			;if the nibble grabbed is greater than or equal to 10
			ADD AL, 87			;we need to add 87 to get the correct hex value
		.ELSE					;if it is not
			ADD AL, 48			;we need to add 48 to get the correct hex value
		.ENDIF					;endif
		
		MOV [EDX + ESI], AL		;move into the destination our hex digit
		INC ESI					;increment to the next output position
		
		MOV AL, [EBX + EDI]		;move the same byte into al 
		SHL AL , 4				;clear out the bits above so we get the HO of the byte
		SHR AL , 4				;shift it back so we can properly do calculation

		.IF AL >= 10			;if the nibble grabbed is greater than or equal to 10
			ADD AL, 87			;we need to add 87 to get the correct hex value
		.ELSE					;if it is not
			ADD AL, 48			;we need to add 48 to get the correct hex value
		.ENDIF					;endif
		
		MOV [EDX + ESI], AL		;move into the destination our hex digit
		INC ESI					;increment to the next output position
	.ENDW						;end while

	MOV AL, 0					;move null character into AL
	MOV [EDX + ESI], AL			;append null

.ELSE							;if it is not 0
	MOV ECX, EBX				;if it is not 0 then we will put the number of bytes to be converted into edi
	
	MOV EBX, lpSource			;load the address of the source into ebx
	MOV EDX, lpDestination		;load the address of the destination into edx
	MOV ESI, 0					;set the starting point in the destination 
	MOV EDI, 0					;set initial position to place output to 0
	.REPEAT
		DEC ECX					;get n-1 bytes so we dont interfere with the do while
		
		MOV AL, [EBX + ESI]		;retreive the byte at position ebx + n
		MOV tempByte, AL
		SHR AL , 4				;shift the bits right to clear out the bits below to get the LO

		.IF AL >= 10			;if the nibble grabbed is greater than or equal to 10
			ADD AL, 87			;we need to add 87 to get the correct hex value
		.ELSE					;if it is not
			ADD AL, 48			;we need to add 48 to get the correct hex value
		.ENDIF					;endif
		
		MOV [EDX + EDI], AL		;move into the destination our hex digit
		INC EDI					;increment to next output position
		INC ESI					;increment to the next byte to grab
		
		MOV AL, tempByte		;move the same byte into al 
		SHL AL , 4				;clear out the bits above so we get the HO of the byte
		SHR AL , 4				;shift it back so we can properly do calculation

		.IF AL >= 10			;if the nibble grabbed is greater than or equal to 10
			ADD AL, 87			;we need to add 87 to get the correct hex value
		.ELSE					;if it is not
			ADD AL, 48			;we need to add 48 to get the correct hex value
		.ENDIF					;endif
		
		MOV [EDX + EDI], AL		;move into the destination our hex digit
		INC EDI					;increment to next output position
		
	.UNTIL ECX == 0				;repeat until there are no more bytes
	
	MOV AL, 0					;move null character into AL
	MOV [EDX + EDI], AL			;append null
.ENDIF							;endif
	
RET 							;return back with 12 bytes used
hexToCharacter ENDP

COMMENT%
******************************************************************************
*Name: charTo4HexDigits                                                      *
*Purpose:                                                                    *
*	  Accepts a null terminated strings and returns a dword mask    		 *
*Date Created: 11/28/2019                                                    *
*Date Modified: 11/28/2019                                                   *
*                                                                            *
*@param lpSourceString:dword                                                 *
*@returns dMask:dword                                                        *
*****************************************************************************%
charTo4HexDigits PROC stdcall, lpSourceString:dword
charTo4HexDigits ENDP

COMMENT%
******************************************************************************
*Name: encrypt32Bit                                                          *
*Purpose:                                                                    *
*	  Intakes a address of hex chars, converts them to ascii, then returns a *
*		new address with ascii characters									 *
*Date Created: 11/28/2019                                                    *
*Date Modified: 11/28/2019                                                   *
*                                                                            *
*@param lpSourceString:dword                                                 *
*@param dMask:dword                                                          *
*@param numBytes:dword                                                       *
*****************************************************************************%
encrypt32Bit PROC stdcall, lpSourceString:dword, dMask:dword , numBytes:dword
encrypt32Bit ENDP
;************************************* the instructions below calls for "normal termination"	

END