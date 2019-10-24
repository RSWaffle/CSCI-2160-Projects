
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
	WhiteListChars byte 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 45, 43
		
	bTemps byte ?

;******************************************************************************************
.CODE

	COMMENT %
******************************************************************************
*Name: extractDwords                                                         *
*Purpose:                                                                    *
*	     *
*                   *
*Date Created: 10/23/2019                                                    *
*Date Modified: 10/23/2019                                                   *
*                                                                            *
*                                                                            *
*@param StringofChars:dword                                                  *
*@param ArrayDwords:dword												 	 *
*****************************************************************************%
extractDwords PROC Near32 C uses EDI ESI EBX ECX, StringofChars:dword, ArrayDwords:dword
	LOCAL addOut:dword, addASCII:dword
	
	MOV EAX, ArrayDwords
	MOV addOut, EAX
	MOV EAX, StringofChars
	MOV addASCII, EAX
	
	MOV EBX, 0
	MOV EDI, 0
	
	lpConvertandMove:
		
		MOV EAX, addASCII
		MOV BL, byte ptr [EAX]
		CMP BL, 00
		JE finished
		
		MOV ECX, lengthof WhiteListChars
		MOV ESI, 0
		
		lpCompareWhitelist:
			CMP BL, WhiteListChars[ESI]
			JE ValidChar
			INC ESI
		loop lpCompareWhitelist
		
		INC addASCII
		JMP lpConvertandMove
		
		ValidChar:
			MOV bTemps[EDI], BL
			INC addASCII
			MOV EAX, addASCII
			MOV BL, byte ptr [EAX]
			DEC addASCII
			
			MOV ECX, lengthof WhiteListChars
			MOV ESI, 0
		
			lpCompareNext:
				CMP BL, WhiteListChars[ESI]
				JE ValidNextChar
				INC ESI
			loop lpCompareNext
			
			INVOKE ascint32, ADDR bTemps
			MOV EDX, addOut
			MOV [EDX], EAX
			MOV bTemps, 0
			MOV [bTemps + 1], 0
			MOV [bTemps + 2], 0
			MOV [bTemps + 3], 0
			ADD addOut, 4
			MOV EDI, 0
			INC addASCII
			JMP lpConvertandMove
			
		ValidNextChar:
			INC EDI
			INC addASCII
			JMP lpConvertandMove
			
	finished:
extractDwords ENDP 

END