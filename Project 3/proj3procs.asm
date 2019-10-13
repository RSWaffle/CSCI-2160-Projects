;******************************************************************************************
;*  Program Name: proj3procs.asm
;*  Programmer:   Ryan Shupe
;*  Class:        CSCI 2160-001
;*  Lab:          Proj3
;*  Date:         10/19/2019
;*  Purpose:      
;******************************************************************************************
	.486						;This tells assembler to generate 32-bit code
	.model flat					;This tells assembler that all addresses are real addresses
	.stack 100h					;EVERY program needs to have a stack allocated
;******************************************************************************************
heapAllocHarrison PROTO Near32 stdcall, dSize:DWORD 							;Creates memory on the heap (of dSize words) and returns the address of the 
;******************************************************************************************
.data
	
	strSize dword ?
	iLength dword ?
	iWidth dword ?
	iTemp dword ? 
	strStartAddr dword ?
	
;******************************************************************************************
.code

COMMENT %
******************************************************************************
*Name: createRectangle                                                       *
*Purpose:                                                                    *
*	     this procedure intakes a width and a height and generates a rectangle*
*        returning the address of where it is located on the heap.           *
*Date Created: 10/12/2019                                                    *
*Date Modified: 10/12/2019                                                   *
*                                                                            *
*                                                                            *
*@param iLength:dword                                                        *
*@param iWidth:dword													 	 *
*****************************************************************************%
createRectangle  PROC Near32
	PUSH EBP							;preserves base register
	MOV EBP, ESP						;sets a new stack frame
	MOV EAX, [EBP + 8]
	MOV iLength, EAX
	MOV EBX, [EBP + 12]
	MOV iWidth, EBX
	MUL EBX
	MOV strSize, EAX

	MOV iTemp, 0

	INVOKE heapAllocHarrison, strSize
	MOV strStartAddr, EAX
	MOV EDI, 0
	MOV [strStartAddr + EDI], 10
	INC EDI	
	MOV ECX, iLength
	
	lpCreateRectangle:
		MOV [strStartAddr + EDI], 09
		INC EDI
		MOV [strStartAddr + EDI], 32
		INC EDI
		MOV EBX, ECX
		MOV ECX, iWidth
		lpCreateStars:
			MOV [strStartAddr + EDI], 42
			INC EDI
			MOV [strStartAddr + EDI], 32
			INC EDI
		loop lpCreateStars
		MOV ECX, EBX
		MOV [strStartAddr + EDI], 10
		INC EDI
		MOV [strStartAddr + EDI], 32
		INC EDI
	loop lpCreateRectangle
	MOV [strStartAddr + EDI], 00
	MOV EAX, OFFSET strStartAddr
	POP EBP
	RET									;return
createRectangle ENDP


COMMENT %
******************************************************************************
*Name: createTriangle                                                        *
*Purpose:                                                                    *
*	     *
*                                                                            *
*Date Created: 10/12/2019                                                    *
*Date Modified: 10/12/2019                                                   *
*                                                                            *
*                                                                            *
*@param iHeight:dword                                                        *
*****************************************************************************%
createTriangle  PROC Near32
createTriangle ENDP

END