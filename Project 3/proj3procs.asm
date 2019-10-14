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
	
	strSize dword ?						;Temp memory to hold the size of words we need to allocate
	iLength dword ?						;memory to hold the length of a rectangle
	iWidth dword ?						;memory to hold the width of a rectangle
	iWidthHollow dword ?				;Memory to hold the width -2 of the rectangle
	iHeightHollow dword ?				;memory to hold the height -2 of the triangle
	iHeight dword ?						;memory to hold the height of a triangle
	iTemp dword ? 						;temp memory to use during calculation
	strStartAddr dword ?				;dword to hold the 4 byte address of the beginning of heap memory
	
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
	MOV EAX, [EBP + 8]					;moves the variable passed in into eax
	MOV iLength, EAX					;moves the variable into iLength
	MOV EBX, [EBP + 12]					;moves the variable passed in into ebx
	MOV iWidth, EBX						;moves the variable into iWidth
	MUL EBX								;Multiplies both registers and stores value into eax
	MOV strSize, EAX					;moves the value into eax into strSize, this should be enough memory to hold what we need.

	INVOKE heapAllocHarrison, strSize	;calls the allocation method to allocate strSize words in memory that we can use to hold our string
	MOV strStartAddr, EAX				;moves the address of the first byte in our allocated memory into a variable
	
	MOV EDI, 0							;sets our initial offset to 0, we will inc this when we go through the loops
	MOV [strStartAddr + EDI], 10		;this should set the first byte to the new line character.
	INC EDI								;increment to the next position
	MOV ECX, iLength					;moves into ecx the length of the rectangle so we get the proper dims and the loop knows when to terminate
	
	lpCreateRectangle:
		MOV [strStartAddr + EDI], 09	;put the character tab at the addr offset edi
		INC EDI							;increment to the next position
		MOV [strStartAddr + EDI], 32	;put the character space at the addr offset edi
		INC EDI							;increment to the next position
		MOV EBX, ECX					;stores the current value of ECX into EBX
		MOV ECX, iWidth					;sets the new value of ECX to the width of the rectangle.
		lpCreateStars:
			MOV [strStartAddr + EDI], 42;put the character * at the addr offset edi
			INC EDI						;increment to the next position
			MOV [strStartAddr + EDI], 32;put the character space at the addr offset edi
			INC EDI						;increment to the next position
		loop lpCreateStars				;decrement ECX and go to the top of the loop
		MOV ECX, EBX					;restores our old ECX value
		MOV [strStartAddr + EDI], 10	;put the new line at the addr offset edi
		INC EDI							;increment to the next position
		MOV [strStartAddr + EDI], 32	;put the character space at the addr offset edi
		INC EDI							;increment to the next position
	loop lpCreateRectangle				;decrement ECX and go to the top of the loop
	MOV [strStartAddr + EDI], 00		;put the null character at the end to signal that this is the end of the loop
	MOV EAX, OFFSET strStartAddr		;moves the offset of the strStartAddr into EAX for return address
	POP EBP								;restore original EBP
	RET									;return
createRectangle ENDP

COMMENT %
******************************************************************************
*Name: hollowRectangle                                                       *
*Purpose:                                                                    *
*	     this takes in a position  of a copied string, modifies it and returns
*		the edited string													 *
*Date Created: 10/14/2019                                                    *
*Date Modified: 10/14/2019                                                   *
*                                                                            *
*                                                                            *
*@param iLength:dword                                                        *
*@param iWidth:dword													 	 *
*@param ADDR:dword													 	     *
*@returns addr:dword														 *
*****************************************************************************%
hollowRectangle  PROC Near32
	PUSH EBP							;preserves base register
	MOV EBP, ESP						;sets a new stack frame
	MOV EAX, [EBP + 12]					;moves the variable passed in into eax
	SUB EAX, 2							;subtract the length by two so we can properly igmore the first and last lines. 
	MOV iLength, EAX					;moves the variable into iLength
	MOV EBX, [EBP + 16]					;moves the variable passed in into ebx
	MOV iWidth, EBX						;moves the variable into iWidth
	SUB EBX, 2							;get the value in between the two end points.
	MOV iWidthHollow, EBX				;store this value into a variable so it can control our loop
	MOV EDX, [EBP + 8]					;move the address of where to write into EDX register
	MOV strStartAddr, EDX				;moves the address of the first byte in our allocated memory into a variable
	
	MOV EDI, 0							;sets our initial offset to 0, we will inc this when we go through the loops
	MOV [strStartAddr + EDI], 10		;this should set the first byte to the new line character.
	INC EDI								;increment to the next position
	MOV ECX, 1							;move 1 into ECX so this loop executes 1 time. (doesnt work without this being in a loop for some odd reason)
	
	lpDisplayFirstLine:
		MOV [strStartAddr + EDI], 09	;put the character tab at the addr offset edi
		INC EDI							;increment to the next position
		MOV [strStartAddr + EDI], 32	;put the character space at the addr offset edi
		INC EDI							;increment to the next position
		MOV EBX, ECX					;stores the current value of ECX into EBX
		MOV ECX, iWidth					;sets the new value of ECX to the width of the rectangle.
		lpCreateStars:
			MOV [strStartAddr + EDI], 42;put the character * at the addr offset edi
			INC EDI						;increment to the next position
			MOV [strStartAddr + EDI], 32;put the character space at the addr offset edi
			INC EDI						;increment to the next position
		loop lpCreateStars				;decrement ECX and go to the top of the loop
		MOV ECX, EBX					;restores our old ECX value
		MOV [strStartAddr + EDI], 10	;put the new line at the addr offset edi
		INC EDI							;increment to the next position
		MOV [strStartAddr + EDI], 32	;put the character space at the addr offset edi
		INC EDI							;increment to the next position
	loop lpDisplayFirstLine
	
	MOV ECX, iLength					;moves into ecx the length -2 of the rectangle so we get the proper inside dims and the loop knows when to terminate
		
	lpCreateHollowRectangle:
		MOV [strStartAddr + EDI], 09	;put the character tab at the addr offset edi
		INC EDI							;increment to the next position
		MOV [strStartAddr + EDI], 32	;put the character space at the addr offset edi
		INC EDI							;increment to the next position
		MOV [strStartAddr + EDI], 42	;put the character * at the addr offset edi
		INC EDI							;increment to the next position
		MOV [strStartAddr + EDI], 32	;put the character space at the addr offset edi
		INC EDI							;increment to the next position
		MOV EBX, ECX					;stores the current value of ECX into EBX
		MOV ECX, iWidthHollow			;sets the new value of ECX to the width of the rectangle.
		lpCreateSpaces:
			MOV [strStartAddr + EDI], 32;put the character * at the addr offset edi
			INC EDI						;increment to the next position
			MOV [strStartAddr + EDI], 32;put the character space at the addr offset edi
			INC EDI						;increment to the next position
		loop lpCreateSpaces				;decrement ECX and go to the top of the loop
		MOV ECX, EBX					;restores our old ECX value
		MOV [strStartAddr + EDI], 42	;put the character * at the addr offset edi
		INC EDI							;increment to the next position
		MOV [strStartAddr + EDI], 32	;put the character space at the addr offset edi
		INC EDI							;increment to the next position
		MOV [strStartAddr + EDI], 10	;put the new line at the addr offset edi
		INC EDI							;increment to the next position
		MOV [strStartAddr + EDI], 32	;put the character space at the addr offset edi
		INC EDI							;increment to the next position
		
	loop lpCreateHollowRectangle		;decrement ECX and go to the top of the loop
	
	MOV ECX, 1							;move 1 into ECX so this loop executes 1 time. (doesnt work without this being in a loop for some odd reason)
	
	lpDisplayLastLine:
		MOV [strStartAddr + EDI], 09	;put the character tab at the addr offset edi
		INC EDI							;increment to the next position
		MOV [strStartAddr + EDI], 32	;put the character space at the addr offset edi
		INC EDI							;increment to the next position
		MOV EBX, ECX					;stores the current value of ECX into EBX
		MOV ECX, iWidth					;sets the new value of ECX to the width of the rectangle.
		lpCreateLastStars:
			MOV [strStartAddr + EDI], 42;put the character * at the addr offset edi
			INC EDI						;increment to the next position
			MOV [strStartAddr + EDI], 32;put the character space at the addr offset edi
			INC EDI						;increment to the next position
		loop lpCreateLastStars			;decrement ECX and go to the top of the loop
		MOV ECX, EBX					;restores our old ECX value
		MOV [strStartAddr + EDI], 10	;put the new line at the addr offset edi
		INC EDI							;increment to the next position
		MOV [strStartAddr + EDI], 32	;put the character space at the addr offset edi
		INC EDI							;increment to the next position
	loop lpDisplayLastLine
	
	MOV [strStartAddr + EDI], 00		;put the null character at the end to signal that this is the end of the loop
	MOV EAX, OFFSET strStartAddr		;moves the offset of the strStartAddr into EAX for return address
	POP EBP								;restore original EBP
	RET									;return
hollowRectangle ENDP

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
*@returns addr:dword														 *
*****************************************************************************%
createTriangle  PROC Near32
	PUSH EBP							;preserves base register
	MOV EBP, ESP						;sets a new stack frame
	MOV EAX, 0							;clear out EAX to avoid error
	MOV EAX, [EBP + 8]					;moves the variable passed in into eax
	MOV iHeight, EAX					;moves the variable into iHeight
	MOV strSize, EAX					;moves the value into eax into strSize, this should be enough memory to hold what we need.				
	
	MOV EDI, 0							;set EDI to 0 to reference the beginning of the string
	MOV [strStartAddr + EDI], 10		;put the new line at the addr offset edi
	INC EDI								;increment to the next position
	MOV [strStartAddr + EDI], 10		;put the new line at the addr offset edi
	INC EDI								;increment to the next position
	MOV ECX, 0							;clear out ECX just in case
	MOV CL, byte ptr iHeight			;moves the height of the triangle to CL so the loop knows when to terminate
	MOV iTemp, 1						;set the initial value of iTemp to 1 because there will always be atleast 1 star
	
	lpDrawTriangle:
		MOV [strStartAddr + EDI], 09	;put the character tab at the addr offset edi
		INC EDI							;increment to the next position
		MOV [strStartAddr + EDI], 32	;put the character space at the addr offset edi
		INC EDI							;increment to the next position
		MOV EBX, ECX					;stores the current value of ECX into EBX
		MOV ECX, iTemp					;moves into ECX iTemp, so the loop knows how many stars to insert
			lpPutStars:					
				MOV [strStartAddr + EDI], 42	;put the character * at the addr offset edi
				INC EDI							;increment to the next position
				MOV [strStartAddr + EDI], 32	;put the character space at the addr offset edi
				INC EDI							;increment to the next position
			loop lpPutStars						;decrement ECX and go to the top of the loop
		MOV [strStartAddr + EDI], 10			;put the new line at the addr offset edi
		INC EDI									;increment to the next position
		INC iTemp						;increment our Temp variable to we add another star for the next line.
		MOV ECX, EBX					;restores our old ECX value
	loop lpDrawTriangle					;decrement ECX and go to the top of the loop
	MOV [strStartAddr + EDI], 00		;put the null character at the end to signal that this is the end of the loop
	MOV EAX, OFFSET strStartAddr		;moves the offset of the strStartAddr into EAX for return address
	POP EBP								;restore original EBP
	RET									;return
createTriangle ENDP

COMMENT %
******************************************************************************
*Name: hollowTriangle                                                        *
*Purpose:                                                                    *
*	     this takes in a position  of a copied string, modifies it and returns
*		the edited string													 *
*Date Created: 10/14/2019                                                    *
*Date Modified: 10/14/2019                                                   *
*                                                                            *
*                                                                            *
*@param ADDR:dword                                                           *
*@param ADDR:dword													 	     *
*****************************************************************************%
hollowTriangle  PROC Near32
	PUSH EBP							;preserves base register
	MOV EBP, ESP						;sets a new stack frame
	MOV EAX, 0							;clear out EAX to avoid error
	MOV AL, [EBP + 12]					;moves the variable passed in into eax
	MOV iHeight, EAX					;moves the variable into iHeight

	MOV EAX, [EBP + 8]					;moves the address of the first byte in our allocated memory into a variable
	MOV strStartAddr, EAX
	
	MOV EDI, 0							;set EDI to 0 to reference the beginning of the string
	MOV [strStartAddr + EDI], 10		;put the new line at the addr offset edi
	INC EDI								;increment to the next position
	MOV ECX, 0							;clear out ECX just in case
	
	MOV iTemp, 1						;set the initial value of iTemp to 1 because there will always be atleast 1 star
	
	Compare:
		MOV CL, 1			
		CMP iTemp, 1
		JE lpDrawFirstLineTriangle
		CMP iTemp, 2
		JE lpDrawFirstLineTriangle
		MOV EAX, iTemp
		CMP EAX, iHeight
		JE lpDrawLastLineTriangle
		JMP lpDrawHollowTriangle
		
	lpDrawFirstLineTriangle:
		MOV [strStartAddr + EDI], 09			;put the character tab at the addr offset edi
		INC EDI									;increment to the next position
		MOV [strStartAddr + EDI], 32			;put the character space at the addr offset edi
		INC EDI									;increment to the next position
		MOV EBX, ECX							;stores the current value of ECX into EBX
		MOV ECX, iTemp							;moves into ECX iTemp, so the loop knows how many stars to insert
			lpPutStars1:					
				MOV [strStartAddr + EDI], 42	;put the character * at the addr offset edi
				INC EDI							;increment to the next position
				MOV [strStartAddr + EDI], 32	;put the character space at the addr offset edi
				INC EDI							;increment to the next position
			loop lpPutStars1						;decrement ECX and go to the top of the loop
		MOV [strStartAddr + EDI], 10			;put the new line at the addr offset edi
		INC EDI									;increment to the next position
		INC iTemp								;increment our Temp variable to we add another star for the next line.
		MOV ECX, EBX							;restores our old ECX value
	loop lpDrawFirstLineTriangle				;decrement ECX and go to the top of the loop
	JMP Compare
	
	lpDrawLastLineTriangle:
		MOV [strStartAddr + EDI], 09			;put the character tab at the addr offset edi
		INC EDI									;increment to the next position
		MOV [strStartAddr + EDI], 32			;put the character space at the addr offset edi
		INC EDI									;increment to the next position
		MOV EBX, ECX							;stores the current value of ECX into EBX
		MOV ECX, iTemp							;moves into ECX iTemp, so the loop knows how many stars to insert
			lpPutStars2:					
				MOV [strStartAddr + EDI], 42	;put the character * at the addr offset edi
				INC EDI							;increment to the next position
				MOV [strStartAddr + EDI], 32	;put the character space at the addr offset edi
				INC EDI							;increment to the next position
			loop lpPutStars2						;decrement ECX and go to the top of the loop
		MOV [strStartAddr + EDI], 10			;put the new line at the addr offset edi
		INC EDI									;increment to the next position
		INC iTemp								;increment our Temp variable to we add another star for the next line.
		MOV ECX, EBX							;restores our old ECX value
	loop lpDrawLastLineTriangle				;decrement ECX and go to the top of the loop
	JMP Complete
	
	lpDrawHollowTriangle:
		MOV [strStartAddr + EDI], 09	;put the character tab at the addr offset edi
		INC EDI							;increment to the next position
		MOV [strStartAddr + EDI], 32	;put the character space at the addr offset edi
		INC EDI							;increment to the next position
		MOV [strStartAddr + EDI], 42	;put the character * at the addr offset edi
		INC EDI							;increment to the next position
		MOV EBX, ECX					;stores the current value of ECX into EBX
		MOV EDX, iTemp
		SUB EDX, 2
		MOV ECX, EDX					;moves into ECX iTemp, so the loop knows how many stars to insert
			lpPutSpace:					
				MOV [strStartAddr + EDI], 32	;put the character space at the addr offset edi
				INC EDI							;increment to the next position
				MOV [strStartAddr + EDI], 32	;put the character space at the addr offset edi
				INC EDI							;increment to the next position
			loop lpPutSpace						;decrement ECX and go to the top of the loop
		MOV [strStartAddr + EDI], 32	;put the character space at the addr offset edi
		INC EDI							;increment to the next position
		MOV [strStartAddr + EDI], 42	;put the character * at the addr offset edi
		INC EDI							;increment to the next position
		MOV [strStartAddr + EDI], 10			;put the new line at the addr offset edi
		INC EDI									;increment to the next position
		INC iTemp						;increment our Temp variable to we add another star for the next line.
		MOV ECX, EBX					;restores our old ECX value
	loop lpDrawHollowTriangle
	
	JMP Compare
	
	Complete:
		MOV [strStartAddr + EDI], 00		;put the null character at the end to signal that this is the end of the loop
		MOV EAX, OFFSET strStartAddr		;moves the offset of the strStartAddr into EAX for return address
		POP EBP								;restore original EBP
	RET									;return
hollowTriangle ENDP

END