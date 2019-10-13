;******************************************************************************************
;*  Program Name: proj3.asm
;*  Programmer:   Ryan Shupe
;*  Class:        CSCI 2160-001 _HeapAllocHarrison@0
;*  Lab:          Proj3
;*  Date:         10/19/2019
;*  Purpose:      
;******************************************************************************************
	.486						;This tells assembler to generate 32-bit code
	.model flat					;This tells assembler that all addresses are real addresses
	.stack 100h					;EVERY program needs to have a stack allocated
;******************************************************************************************
;  List all necessary prototypes for methods to be called here
	ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD  					;Executes "normal" termination
	intasc32 PROTO NEAR32 stdcall, lpStringToHold:dword, dval:dword			;Will convert any D-Word number into ACSII characters
	putstring  PROTO NEAR stdcall, lpStringToDisplay:dword  				;Will display ;characters until the NULL character is found
	getstring 	PROTO stdcall, lpStringToHoldInput:dword, maxNumChars:dword ;Get input from user and convert. 
	ascint32 PROTO NEAR32 stdcall, lpStringToConvert:dword  				;This converts ASCII characters to the dword value
	heapDestroyHarrison PROTO Near32 stdcall								;Destroys the memory allocated by the allocate proc 
;******************************************************************************************
EXTERN sizeOfString:near32,createRectangle:near32,createTriangle:near32
;******************************************************************************************
COMMENT %
******************************************************************************
*Name: DisplayString                                                         *
*Purpose:                                                                    *
*	The purpose of this macro is to display a set of strings to the console  *
*                                                                            *
*Date Created: 10/02/2019                                                    *
*Date Modified: 10/02/2019                                                   *
*                                                                            *
*                                                                            *
*@param String1:byte                                                         *
*****************************************************************************%

DisplayString MACRO String:REQ
	INVOKE putstring, ADDR String    				;;display The string passed in 
ENDM

COMMENT %
******************************************************************************
*Name: AscInt                                                                *
*Purpose:                                                                    *
*	Converts ascii value to int and stores in dVal							 *
*                                                                            *
*Date Created: 10/02/2019                                                    *
*Date Modified: 10/02/2019                                                   *
*                                                                            *
*                                                                            *
*@param String1:byte                                                         *
*****************************************************************************%

IntAsc MACRO String:REQ, val:REQ
	INVOKE intasc32, ADDR String, ADDR val  		;;invoke ascint proc 
ENDM

COMMENT %
******************************************************************************
*Name: PullString                                                            *
*Purpose:                                                                    *
*	The purpose is to get information from the user and store into a variable*
*                                                                            *
*Date Created: 10/09/2019                                                    *
*Date Modified: 10/09/2019                                                   *
*                                                                            *
*                                                                            *
*@param String1:byte                                                         *
*@param limit:byte                                                           *
*****************************************************************************%

PullString MACRO String:REQ, limit:REQ
		INVOKE getstring, ADDR String, limit		;Take the string input and store it into a variable, max amount of chars typed is sNumChars
ENDM

COMMENT %
******************************************************************************
*Name: CvtoToNum                                                             *
*Purpose:                                                                    *
*	converts a string to its real decimal number.                            *
*                                                                            *
*Date Created: 10/09/2019                                                    *
*Date Modified: 10/09/2019                                                   *
*                                                                            *
*                                                                            *
*@param String1:byte                                                         *
*****************************************************************************%
CvtoNum MACRO String:REQ
	INVOKE ascint32, ADDR String					;Convert the ASCII value to its true decimal number
ENDM

COMMENT %
******************************************************************************
*Name: DisplayShape                                                          *
*Purpose:                                                                    *
*	takes in a string address and displays contents until null character     *
*                                                                            *
*Date Created: 10/13/2019                                                    *
*Date Modified: 10/13/2019                                                   *
*                                                                            *
*                                                                            *
*@param String1:byte                                                         *
*****************************************************************************%
DisplayShape MACRO String:REQ	
	LOCAL lpDisplay									;make this label local to avoid errors calling this more than once.
	LOCAL finishedDisplay							;make this label local to avoid errors calling this more than once.
	MOV EAX, 0										;clear out EAX to avoid error
	MOV EDI, 0										;clear out EDI to avoid error
	ADD EDI, strAddress								;Adds the address of straddress to edi so we get the memory location
	lpDisplay:
		MOV AL,[EDI]								;moves into al the byte located at the address that is in edi
		CMP AL, 00									;compare to 00 to see if we are at the end of the string
		JE finishedDisplay							;if it is equal, jump to finished display
		MOV bDisplay, AL							;move the byte into bdisplay to setup for output
		DisplayString bDisplay						;calls the DisplayString macro and passes in the byte stored in bdisplay
		INC EDI										;increment edi so we look at the next location in the loop
		JMP lpDisplay								;jump back to the top
	finishedDisplay:	
ENDM
;******************************************************************************************
	.DATA
	strProjInfo byte  10,13,9,
        "Name: Ryan Shupe",10,
"       Class: CSCI 2160-001",10,
"        Date: 10/19/2019",10,
"         Lab: Project 3",0
	strRectangleLength byte 10,10, "Enter a whole number length for a rectangle [3,25]: ", 0
	strRectangleWidth byte 10,10, "Enter a whole number width for a rectangle [3,25]: ", 0
	strTriangleHeight byte 10,10, "Enter a whole number height for a right triangle [4,25]: ", 0
	strSolidRectangleInfo1 byte 10,10, "This is a rectangle with input dimensions ",0
	strSolidRectangleInfo2 byte " by ",0
	strSolidRectangleInfo3 byte ": ",0
	strHallowRectangleInfo byte 10,"This is the same rectangle hollowed out: ",0
	strSolidTriangleInfo1 byte 10,10, "This is a right triangle with height ",0
	strSolidTriangleInfo2 byte ": ",0
	strHallowTriangleInfo byte 10, "This is the same right triangle hollowed out: ",0
	TestString byte 10, ":^)",0
	recLength byte 4 dup (?) 						;set aside memory to hold the length of the rectangle with an empty bytes between the next variable
	recWidth byte 4 dup (?) 	 					;set aside memory to hold the width of the rectangle with an empty bytes between the next variable
	triHeight byte ?								;memory to hold the height of a triangle
	recLengthASCII byte 4 dup (?) 					;set aside memory to hold the length of the rectangle in ASCII form with an empty bytes between the next variable
	recWidthASCII byte 4 dup (?) 	 				;set aside memory to hold the width of the rectanglein ASCII form with an empty bytes between the next variable
	triHeightASCII byte ?							;memory to hold the height of a triangle in ASCII form

	crlf byte  10,13,0								;Null-terminated string to skip to new line
	sizeString dword ?								;Temp memory to hold the size of a string
	strAddress dword ?								;Memory to hold the 4 byte address of a string
	bDisplay byte ?									;memory to hold a byte to display
	iTemp dword ?									;temp memory to hold a number for calculation

;******************************************************************************************
	.CODE
	
_start:
	MOV EAX, 0										;Statement to help in debugging
	
main PROC

	DisplayString strProjInfo						;calls the display string macro as passes in the project information.
	
getRectangleLength:	
	DisplayString strRectangleLength				;calls the display string macro as passes in the length string.
	PullString recLengthASCII, 2					;get the user specified string and store into a variable, also in EAX
	CvtoNum recLengthASCII							;convert the value to its true decimal number so we can actually use it.
	MOV recLength, AL								;moves the length of the rectangle into AL so we can properly compare it
	
	CMP EAX, 0										;Compare EAX to 0 to see if the user typed null character
	JE getRectangleLength							;If it is null then jump to getRectangleLength
	CMP EAX, 25										;Compare EAX to 25 to see if the user typed a number greater than 25.
	JG getRectangleLength							;If greater than, jump to getRectangleLength
	CMP EAX, 3										;Compare EAX to 3 to see if it is less than 3	
	JL getRectangleLength							;If so, jump to getRectangleLength 
	
	
getRectangleWidth:	
	DisplayString strRectangleWidth					;calls the display string macro as passes in the length string.
	PullString recWidthASCII, 2						;get the user specified string and store into a variable, also in EAX
	CvtoNum recWidthASCII							;convert the value to its true decimal number so we can actually use it.
	MOV recWidth, AL								;moves the width of the rectangle into AL so we can properly compare it
	
	CMP EAX, 0										;Compare EAX to 0 to see if the user typed null character
	JE getRectangleWidth							;If it is null then jump to getRectangleWidth
	CMP EAX, 25										;Compare EAX to 25 to see if the user typed a number greater than 25.
	JG getRectangleWidth							;If greater than, jump to getRectangleWidth
	CMP EAX, 3										;Compare EAX to 3 to see if it is less than 3	
	JL getRectangleWidth							;If so, jump to getRectangleWidth 
	JMP displayRectangle							;jump to the next section to display the rectangle
	
	
displayRectangle:	
	DisplayString strSolidRectangleInfo1			;calls the display string macro and passes in the specified string and shows this is a rectangle with the specified dims.
	DisplayString recLengthASCII					;this will display the length of the rectangle via the macro
	DisplayString strSolidRectangleInfo2			;this will show the second part of the string "by"
	DisplayString recWidthASCII						;this will display the width of the rectangle via the macro
	DisplayString strSolidRectangleInfo3			;this will display the end colon to make the string look nice. 
	DisplayString crlf								;calls the display string macro and passes in the specified string to skip to a new line.
	PUSH dword ptr recLength						;Push the length of the rectangle so the method is able to access it
	PUSH dword ptr recWidth							;Push the width of the rectangle so the method is able to access it
	CALL CreateRectangle							;Call the method in proj3procs
	ADD ESP, 8										;Add back the bits that we used in the method
	MOV strAddress, EAX								;move the address that the method gave us into a variable
	DisplayShape strAddress							;call the display shape macro to display the shape for us
	DisplayString strHallowRectangleInfo			;calls the display string macro and passes in the specified string and tells user that this is the hollowed rectangle.
	DisplayString crlf								;displays the chars to skip to a new line.	
	DisplayString TestString						;Display test string because im happy
	JMP getTriangleHeight							;jump to the next section after completion.
	
	
getTriangleHeight:	
	DisplayString strTriangleHeight					;calls the display string macro as passes in the length string.
	PullString triHeightASCII, 2					;get the user specified string and store into a variable, also in EAX
	CvtoNum triHeightASCII							;convert the value to its true decimal number so we can actually use it.
	MOV triHeight, AL								;moves the height of the triangle into AL so we can properly compare it
	
	CMP EAX, 0										;Compare EAX to 0 to see if the user typed null character
	JE getTriangleHeight							;If it is null then jump to getRectangleWidth
	CMP EAX, 25										;Compare EAX to 25 to see if the user typed a number greater than 25.
	JG getTriangleHeight							;If greater than, jump to getRectangleWidth
	CMP EAX, 4										;Compare EAX to 4 to see if it is less than 4	
	JL getTriangleHeight							;If so, jump to getRectangleWidth 
	JMP displayTri									;jump to next section
	
displayTri:	
	DisplayString crlf								;calls the display string macro and passes in the specified string to skip to a new line.
	DisplayString strSolidTriangleInfo1				;calls the display string macro and passes in the specified string to show information about the solid triangle.
	DisplayString triHeightASCII					;this will call the macro to display the height of the rectangle 
	DisplayString strSolidTriangleInfo2				;calls the display string macro and passes in the specified string to show information about the solid triangle.
	DisplayString crlf								;calls the display string macro and passes in the specified string to skip to a new line.
	PUSH dword ptr triHeight						;Push the height of the triangle so the method is able to access it
	CALL createTriangle								;call the method create triangle so we can get the location of our stored triangle
	ADD ESP, 4										;add back the bytes we used
	MOV strAddress, EAX								;move the address that the method gave us into a variable
	DisplayShape  strAddress						;call the display shape macro to display the shape for us
	DisplayString strHallowTriangleInfo				;calls the display string macro and passes in the specified string telling user this is the hollowed triangle.
	DisplayString crlf								;displays the chars to skip to a new line.	
	DisplayString TestString						;Display test string because im happy
	
	PUSH OFFSET strSolidRectangleInfo2
	call sizeOfString
	ADD ESP, 4
	
	MOV EAX, 0										;Statement to help in debugging
	JMP finished

;************************************* the instructions below calls for "normal termination"	
finished:
	INVOKE heapDestroyHarrison
	INVOKE ExitProcess,0						 
	PUBLIC _start
	
main ENDP
	END												;Signals assembler that there are no instructions after this statement