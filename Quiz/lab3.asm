COMMENT %
Lab using logical directives
;*************************************************************************************
; Program Name:  lab3.asm
; Programmer:    Dr. Bailey  /  Ryan Shupe
; Class:         CSCI 2160
; Date:          Nov. 8, 2019  /  Nov. 19, 2019
; Purpose:  An exercise in using logical directives. The CMP instruction cannot be used
;  anywhere in the program. You may add any identifiers you need to the data segment.
;       
;************************************************************************************%  
	.486				;tells assembler to generate 32-bit code
	.model flat			;tells assembler that all addresses are real addresses
	.stack 100h			;EVERY program needs to have a stack allocated
;************************************************************************************
	ExitProcess	PROTO near32 stdcall, dVal:dword
	putstring 	PROTO Near32 stdcall, lpStringToDisplay:dword
	getstring 	PROTO Near32 stdcall, lpStringToHold:dword, dLimitOnInput:dword
	intasc32 	PROTO Near32 stdcall, lpStringToHoldASCII:dword, dValToConvert:dword
	ascint32 	PROTO Near32 stdcall, lpStringContainingASCII:dword
	hexToChar 	PROTO Near32 stdcall, lpStringToHoldHexASCII:dword, dValToConvert:dword, spec:dword
	putch		PROTO Near32 stdcall, chr:byte

	.data
dVals	dword  35, 65, 275, 86, 72, -90, 76, 45, -37, 275, 76, -43, 182
iX	dword  27
iY	dword  35
iZ  dword  20
;Any identifiers that you want to add, insert them BELOW this line.

strGreatestNum byte 10,"The greatest number is: ",0
strSumOfNum byte 10,"The sum of the numbers in the array is: ", 0
strSmallest byte 10, "The smallest number in the array is: ", 0
strGreatest byte 10, "The greatest number in the array is: ", 0
strSearch byte 10, "Enter the number you wish to search for: ", 0
strFound byte 10, "The number you searched for is located at: ", 0 
strNotFound byte 10, "The number you searched for was not found.", 0
tempNum dword ?
tempString byte 12 dup(0)

	.code
_start:
	mov eax,0									;dummy statement
main	proc
	
;1) display the larger of iX,iY, and iZ WITH AN APPROPRIATE COMMENT

MOV EAX, iX										;moves the value in iX into register so we can compare without mem to mem error
.IF  EAX > iY && EAX > iZ						;if the value in iX is greater than iY and iZ
		INVOKE putstring, addr strGreatestNum   ;Displays a message to the user that the greatest number is about to be displayed.
		INVOKE intasc32, addr tempNum, iX		;convert the number that is in iX into ascii format and store into a variable
		INVOKE putstring, addr tempNum			;display the ascii converted number onto the screen	
.ELSE											;considering the value in iX is less than iY and iZ we can use else
	MOV EAX, iY									;moves the value of iY into the register for comparison
	
	.IF EAX > iZ								;if the value iY is greater than iZ, it is therefore the greatest number	
		INVOKE putstring, addr strGreatestNum   ;Displays a message to the user that the greatest number is about to be displayed.
		INVOKE intasc32, addr tempNum, iY		;convert the number that is in iY into ascii format and store into a variable
		INVOKE putstring, addr tempNum			;display the ascii converted number onto the screen	
	.ELSE										;iZ is the greatest if this gets hit
		INVOKE putstring, addr strGreatestNum   ;Displays a message to the user that the greatest number is about to be displayed.
		INVOKE intasc32, addr tempNum, iZ		;convert the number that is in iZ into ascii format and store into a variable
		INVOKE putstring, addr tempNum			;display the ascii converted number onto the screen	
	.ENDIF										;ends if
.ENDIF											;ends if

;SET UP A LOOP TO add up all the values reference by dVals and display the sum
;BASIC LOOP;

MOV EBX, 0										;clear EBX
MOV EDX, 0										;clear EDX
MOV EDI, OFFSET dVals							;Moves the address of dVals starting position into edi
MOV ECX, LENGTHOF dVals							;moves the number of elements in dVals into ECX

lpAddEmUp:
	MOV EDX, [EDI]								;moves the value at address edi into edx
	ADD EBX, EDX								;add into ebx the value in edx
	ADD EDI, 4									;add 4 to edi to get to the next dword number
loop lpAddEmUp									;decrement ecx and jump to the top of the loop

INVOKE putstring, addr strSumOfNum   			;Displays a message to the user that the sum is about to be displayed.
INVOKE intasc32, addr tempNum, EBX				;convert the number that is in iZ into ascii format and store into a variable
INVOKE putstring, addr tempNum					;display the ascii converted number onto the screen

;set up a while loop  to find the smallest value in the array ref by dVals and display an
; appropriate message

MOV EDI, OFFSET dVals							;Moves the address of dVals starting position into edi
MOV ECX, LENGTHOF dVals							;moves the number of elements in dVals into ECX
MOV EBX, [EDI]									;moves the first value at edi into ebx so we have a starting point
ADD EDI, 4										;increment to the next position
DEC ECX											;decrement ecx so we dont go over the length of the array
MOV AL, 0										;intitialize AL to 0, to show that a negative number is NOT in EBX right now

.WHILE ECX != 0									;while there is still numbers left in dVals array
	MOV EDX, [EDI]								;move the number currently at address edi into edx
	.IF AL == 0 								;if there is not a negative number in ebx
		TEST EDX, EDX							;test the number with itself to set flags
		.IF SIGN?								;if the sign flag is set with the previous line, a negative number is in edx
			MOV EBX, EDX						;move the negative number into the register that has the smallest val in it
			MOV AL, 1							;set AL to 1 to that when the loop executes again, it will know there is a negative
		.ELSEIF EDX < EBX						;if the sign flag is not set, and edx is less than the current smallest number
			MOV EBX, EDX						;move the number in edx into ebx 
		.ENDIF									;end if statement
	.ELSE										;if AL contains a 1, that means there is a negative number in the smallest value register ebx
		TEST EDX, EDX							;test the current number in edx to see if it is negative
		.IF SIGN?								;if it is a negative then continue, if it is not, then we dont care about it because a positive is not lower than a negative 
			.IF EBX > EDX						;if the new negative is a greater number (smaller in this case) than the current one, then 
				MOV EBX, EDX					;move the value in edx into the smallest number ebx register
			.ENDIF								;end if
		.ENDIF									;end if
	.ENDIF										;end if
	ADD EDI, 4									;increment 4 to get the next dword value
	DEC ECX										;decrement ecx as there is one less number to check for
.ENDW											;end while loop

INVOKE putstring, addr strSmallest   			;Displays a message to the user that the smallest number is about to be displayed.
INVOKE intasc32, addr tempNum, EBX				;convert the number that is in iZ into ascii format and store into a variable
INVOKE putstring, addr tempNum					;display the ascii converted number onto the screen

;setup a repeat/until loop to find the largest value in the array ref by dVals and display
; an appropriate response

MOV EDI, OFFSET dVals							;Moves the address of dVals starting position into edi
MOV ECX, LENGTHOF dVals							;moves the number of elements in dVals into ECX
MOV EBX, [EDI]									;moves the first value at edi into ebx so we have a starting point
ADD EDI, 4										;increment to the next position
DEC ECX											;decrement ecx so we dont go over the length of the array
TEST EBX, EBX									;test the first value in the array to see if it is negative
.IF SIGN?										;if it is negative
	MOV AL, 1									;move 1 into al to signify that there is a negative in the largest spot
.ELSE											;if it is positive
	MOV AL, 0									;move 0 into al to signify that a positive is in the largest spot 
.ENDIF											;end if

.REPEAT											;repeat until ecx is equal to 0
	MOV EDX, [EDI]								;move the number currently at address edi into edx

	.IF AL == 0									;if there is a positive number in the largest spot
		TEST EDX, EDX							;test EDX against itself to test if its negative
		.IF SIGN?								;if the value in edx is a negative (if it is we can ignore it because al = 0)
		.ELSE									;if it is positive, we need to check it
			.IF EDX > EBX						;if the new value is greater than the current largest
				MOV EBX, EDX					;move the new value into the register keeping track of the largest value
				MOV AL, 0						;set AL to say there is a positive in the largest spot
			.ENDIF								;end if
		.ENDIF									;end if
	.ELSE										;if there is a negative in the largest spot
		TEST EDX, EDX							;test EDX against itself to test if its negative
		.IF SIGN?								;if the value in edx is a negative
			.IF EBX < EDX						;check to see if the value currently in edx is larger than the one in ebx
				MOV EBX, EDX					;moves the new value into the largest spot
				MOV AL, 1						;check AL to show there is a negative in the largest spot
			.ENDIF								;end if
		.ELSE									;if it is not a negative number, it is already larger than the current largest number
				MOV EBX, EDX					;moves the positive number into the position
				MOV AL, 0						;signal to Al that the largest number is a positive number
		.ENDIF									;end if
	.ENDIF										;end if
	ADD EDI, 4									;increment 4 to get the next dword value
	DEC ECX										;decrement ecx as there is one less number to check for
.UNTIL ECX == 0									;repeat this until ecx is equal to 0

INVOKE putstring, addr strGreatest   			;Displays a message to the user that the smallest number is about to be displayed.
INVOKE intasc32, addr tempNum, EBX				;convert the number that is in iZ into ascii format and store into a variable
INVOKE putstring, addr tempNum					;display the ascii converted number onto the screen

;Prompt the user for a key value which will be used to search the array. When found, get
;out of the loop and display the address IN HEX of the found value with an appropriate 
;message. If not found, display an appropriate message as well.

INVOKE putstring, addr strSearch				;display the string asking for the user to enter a number to search
INVOKE getstring, addr tempString, 8			;get input from the user
INVOKE ascint32, addr tempString
MOV tempNum, EAX

MOV EDI, OFFSET dVals							;Moves the address of dVals starting position into edi
MOV ECX, LENGTHOF dVals							;moves the number of elements in dVals into ECX
					
.REPEAT 										;repeat while there are elements in the array
	MOV EBX, [EDI]								;moves the new value at edi into ebx 	
	.IF EBX == tempNum							;if number is found
		MOV ECX, 0								;set ecx to 0 to get out of the loop
		MOV AL, 1								;set AL to 1, so we know the value was found
	.ELSE										;if it is not found then
		ADD EDI, 4								;add 4 to edi to get the next number location 
		DEC ECX									;decrement ecx so we can get out of the loop if it is not found
		MOV AL, 0								;if it is not found, move 0 into al
	.ENDIF										;end if
.UNTIL ECX == 0									;repeat until ecx is 0

.IF AL == 1										;if found
	INVOKE putstring, addr strFound				;display string saying it was found.
	INVOKE hexToChar, addr tempString, EDI, 0	;convert the address into ascii
	INVOKE putstring, addr tempString			;display the address
.ELSE											;if it was not found
	INVOKE putstring, addr strNotFound			;display the string that it was not found in the array
.ENDIF											;end if

INVOKE getstring, addr tempString, 0			;press enter to continue no msg
;************************************************************************************
	INVOKE ExitProcess,0
	PUBLIC _start
main endp
	END
	