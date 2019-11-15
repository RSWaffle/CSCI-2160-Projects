;******************************************************************************************
;*  Program Name: proj4.asm
;*  Programmer:   Ryan Shupe
;*  Class:        CSCI 2160-001 
;*  Lab:          Proj4
;*  Date:         11/02/2019
;*  Purpose:      This is the driver program that handles input and output and calls other classes to 
;*				  manipulate matrices 
;******************************************************************************************

	.486						;This tells assembler to generate 32-bit code

	.model flat					;This tells assembler that all addresses are real addresses

	.stack 100h					;EVERY program needs to have a stack allocated
	.listall

;******************************************************************************************

;  List all necessary prototypes for methods to be called here

	ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD  					;Executes "normal" termination

	intasc32 PROTO NEAR32 stdcall, lpStringToHold:dword, dval:dword			;Will convert any D-Word number into ACSII characters

	putstring  PROTO NEAR stdcall, lpStringToDisplay:dword  				;Will display ;characters until the NULL character is found

	getstring 	PROTO stdcall, lpStringToHoldInput:dword, maxNumChars:dword ;Get input from user and convert. 

	ascint32 PROTO NEAR32 stdcall, lpStringToConvert:dword  				;This converts ASCII characters to the dword value
	
	extractDwords PROTO Near32 C, StringofChars:dword, ArrayDwords:dword
	
	displayArray PROTO Near32 C, lpArrayDwords:dword, rows:dword, cols:dword, lpStringtoHold:dword
	
	selectionSort PROTO Near32 C, lpArrayDwords:dword, iLength:dword
	
	sumUpArray PROTO Near32 C, lpArrayDwords:dword, rows:dword, cols:dword
	
	smallestValue PROTO Near32 C, lpArrayDwords:dword, rows:dword, cols:dword

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
getBytes MACRO String:REQ
	LOCAL stLoop
	LOCAL done
	PUSH EBP							;preserves base register
	MOV EBP, ESP						;sets a new stack frame
	PUSH EBX							;pushes EBX to the stack to store this
	PUSH ESI							;pushes ESI to the stack to preseve
	MOV EBX, String						;moves into ebx the first val in the stack that we are going to use
	MOV ESI, 0							;sets the initial point to 0
		
	stLoop:
		CMP byte ptr [EBX + ESI], 0		;compares the two positions to determine if this is the end of the string
		JE done							;if it is jump to finished
		INC ESI							;if not increment esi
		JMP stLoop						;jump to the top of the loop and look at the next char
	done:		
		INC ESI							;increment esi to include the null character in the string
		MOV EAX, ESI					;move the value of esi into eax for proper output and return
	
	POP ESI								;restore original esi
	POP EBX								;restore original ebx
	POP EBP								;restore originla ebp
ENDM

;******************************************************************************************
.DATA
	strProjInfo byte  10,13,9,
        "Name: Ryan Shupe",10,
"       Class: CSCI 2160-001",10,
"        Date: 11/02/2019",10,
"         Lab: Project 4",0

	strMenu byte 10,10,10,13,9, "M E N U",10,
	"a) Set values for matrix A",10,
	"b) Set values for matrix B",10,
	"c) Display values in array A",10,
	"d) Display values in array B",10,
	"e) Add up the values in A array",10,
	"f) Add up the values in B array",10,
	"g) Sort and display the values of array A",10,
	"h) Sort and display the values of array B",0
	
	strMenu2 byte 10,
	"i) Multiply matrix A and B to get matrix C",10,
	"j) Display values in matrix C",10,
	"k) Add up the values in C array",10,
	"l) Sort and display the values of array C",10,
	"m) Smallest Value in array A",10,
	"n) Smallest Value in array B",10,
	"o) Smallest value in array C",10,
	"p)",10,
	"q) EXIT program",10,10,13,0
	clearScr byte 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,0
	strTypeChoice byte 10,13, "Type the letter of your choice: ",0
	strAskValues byte 10,10,13, "Enter the values you wish to store in the array: ",0
	strValuesStored byte 10,13, "Values successfully stored!", 0
	strMethodNotAdded byte 10,13, "ERROR! Method not implemented!", 0
	enterToCont byte 10,10,13, "Press ENTER to Continue...",0
	enterValCol byte 10,10,13, "Enter a value for col: ",0
	enterValRow byte 10,10,13, "Enter a value for row: ",0
	strSum byte 10,10,13, "The sum of the values in the array is: ", 0
	strSmallestNum byte 10,10,13, "The smallest value in the array is: ", 0
	strSortLength byte 10,10,13, "Enter the number of elements you want to sort in the array: ",0
	strLocked byte 10,10,13, "ERROR: This method is currently locked!", 0
	crlf byte  10,13,0								;Null-terminated string to skip to new line
	choiceASCII byte 0								;Holds the ascii number choice 
	strDisplay dword 200 dup(0)						;memory to hold a display string
	numbersASCII byte 200 dup (?), 00				;memory to hold the ascii numbers
	arrayA dword 100 dup (?)						;memory to hold dwords in an array
	arrayB dword 100 dup (?)						;memory to hold dwords in an array
	strEnter byte 0									;something to signify that the user pressing nothing but enter
	tempNum dword 0									;memory to hold a temp number
	numValues dword 0								;the number of values in array
	rowA dword 0									;number of rows in A
	colA dword 0									;numbers of cols in B
	rowB dword 0									;numbers of rows in B
	colB dword 0									;numbers of cols in B
	matrixAActive byte 0							;byte to signify if A is active
	matrixBActive byte 0							;byte to signify if B is active


;******************************************************************************************
.CODE

_start:
	MOV EAX, 0										;Statement to help in debugging
	
main PROC

	DisplayString strProjInfo						;display the string that contains the project information
	
getUserChoice:	
	DisplayString strMenu							;display the first part of the menu
	DisplayString strMenu2							;display the second part of the menu
	DisplayString strTypeChoice						;display the message "enter choice"
	
	PullString choiceASCII, 1						;read in the next line that the user inputs and store the ascii value.
	
	CMP choiceASCII, 65								;compare the ascii value to a capital A
	JE choiceA										;if it is equal to the capital value, jump to the choiceA secion of the code.
	CMP choiceASCII, 97								;compare the ascii value to the lowercase a
	JE choiceA										;if it is equal to this number then jump to the choiceA section.
	
	CMP choiceASCII, 66								;compare the ascii value to a capital B
	JE choiceB										;if it is equal to the capital value, jump to the choiceB secion of the code.
	CMP choiceASCII, 98								;compare the ascii value to the lowercase b
	JE choiceB										;if it is equal to this number then jump to the choiceB section.
	
	CMP choiceASCII, 67								;compare the ascii value to a capital C
	JE choiceC										;if it is equal to this number then jump to the choiceC section.
	CMP choiceASCII, 99								;compare the ascii value to the lowercase c
	JE choiceC										;if it is equal to this number then jump to the choiceC section.
	
	CMP choiceASCII, 68								;compare the ascii value to a capital D
	JE choiceD										;if it is equal to this number then jump to the choiceD section.
	CMP choiceASCII, 100							;compare the ascii value to the lowercase d
	JE choiceD										;if it is equal to this number then jump to the choiceD section.
	
	CMP choiceASCII, 69								;compare the ascii value to a capital E
	JE choiceE										;if it is equal to this number then jump to the choiceE section.
	CMP choiceASCII, 101							;compare the ascii value to the lowercase e
	JE choiceE										;if it is equal to this number then jump to the choiceE section.
	
	CMP choiceASCII, 70								;compare the ascii value to a capital F
	JE choiceF										;if it is equal to this number then jump to the choiceF section.
	CMP choiceASCII, 102							;compare the ascii value to the lowercase f
	JE choiceF										;if it is equal to this number then jump to the choiceF section.
	
	CMP choiceASCII, 71								;compare the ascii value to a capital G
	JE choiceG										;if it is equal to this number then jump to the choiceG section.
	CMP choiceASCII, 103							;compare the ascii value to the lowercase g
	JE choiceG										;if it is equal to this number then jump to the choiceG section.
	
	CMP choiceASCII, 72								;compare the ascii value to a capital H
	JE choiceH										;if it is equal to this number then jump to the choiceH section.
	CMP choiceASCII, 104							;compare the ascii value to the lowercase h
	JE choiceH										;if it is equal to this number then jump to the choiceH section.
	
	CMP choiceASCII, 73								;compare the ascii value to a capital I
	JE choiceI										;if it is equal to this number then jump to the choiceI section.
	CMP choiceASCII, 105							;compare the ascii value to the lowercase i
	JE choiceI										;if it is equal to this number then jump to the choiceI section.
	
	CMP choiceASCII, 74								;compare the ascii value to a capital J
	JE choiceJ										;if it is equal to this number then jump to the choiceJ section.
	CMP choiceASCII, 106							;compare the ascii value to the lowercase j
	JE choiceJ										;if it is equal to this number then jump to the choiceJ section.
	
	CMP choiceASCII, 75								;compare the ascii value to a capital K
	JE choiceK										;if it is equal to this number then jump to the choiceK section.
	CMP choiceASCII, 107							;compare the ascii value to the lowercase k
	JE choiceK										;if it is equal to this number then jump to the choiceK section.
	
	CMP choiceASCII, 76								;compare the ascii value to a capital L
	JE choiceL										;if it is equal to this number then jump to the choiceL section.
	CMP choiceASCII, 108							;compare the ascii value to the lowercase l
	JE choiceL										;if it is equal to this number then jump to the choiceL section.
	
	CMP choiceASCII, 77								;compare the ascii value to a capital M
	JE choiceM										;if it is equal to this number then jump to the choiceM section.
	CMP choiceASCII, 109							;compare the ascii value to the lowercase m
	JE choiceM										;if it is equal to this number then jump to the choiceM section.
	
	CMP choiceASCII, 78								;compare the ascii value to a capital N
	JE choiceN										;if it is equal to this number then jump to the choiceN section.
	CMP choiceASCII, 110							;compare the ascii value to the lowercase n
	JE choiceN										;if it is equal to this number then jump to the choiceN section.
	
	CMP choiceASCII, 79								;compare the ascii value to a capital O
	JE choiceO										;if it is equal to this number then jump to the choiceO section
	CMP choiceASCII, 111							;compare the ascii value to the lowercase o
	JE choiceO										;if it is equal to this number then jump to the choiceO section.
	
	CMP choiceASCII, 81								;compare the ascii value to a capital Q
	JE choiceQ										;if it is equal to this number then jump to the choiceQ section.
	CMP choiceASCII, 113							;compare the ascii value to the lowercase q
	JE choiceQ										;if it is equal to this number then jump to the choiceQ section.
		
	DisplayString clearScr							;display the characters to clear the screen
	JMP getUserChoice								;jump back up to display the menu
	
	
choiceA: ;input a
	MOV ECX, lengthof arrayA						;moves the length of array a into ECX so we can clear that amount to clear the array
	lpClearA:
	MOV arrayA[ECX], 0								;sets the byte at position ecx to 0 (this will exclude the first byte but thats ok because its going to be overwritten)
	loop lpClearA									;decrement ECX and go to the top of the loop
	DisplayString strAskValues						;display the string asking which values to store
	PullString numbersASCII, 50						;get what the user typed and store into numbersASCII
	
	INVOKE extractDwords, OFFSET numbersASCII, 		;call the extract dwords function so we have our array properly loaded into mem
	OFFSET arrayA
	
	DisplayString clearScr							;display the characters to clear the screen
	DisplayString clearScr							;display the characters to clear the screen
	DisplayString strValuesStored					;display a helpful message telling the user that the values have been stored. 
	DisplayString crlf								;display characters to go to next line.
	DisplayString crlf								;display characters to go to next line.
	DisplayString enterToCont						;display the press enter to continue message
	PullString strEnter, 0							;wait for the user to press enter
	DisplayString clearScr							;display the characters to clear the screen
	MOV matrixAActive, 1 							;set the matrix as active so it unlocks the other methods
	JMP getUserChoice								;jump back up to display the menu
choiceB: ;input b
	MOV ECX, lengthof arrayB						;moves the length of array a into ECX so we can clear that amount to clear the array
	lpClearB:
	MOV arrayB[ECX], 0								;sets the byte at position ecx to 0 (this will exclude the first byte but thats ok because its going to be overwritten)
	loop lpClearB									;decrement ECX and go to the top of the loop
	DisplayString strAskValues						;display the string asking which values to store
	PullString numbersASCII, 50						;get what the user typed and store into numbersASCII
		
	INVOKE extractDwords, OFFSET numbersASCII, 		;call the extract dwords function so we have our array properly loaded into mem
	OFFSET arrayB
	
	DisplayString clearScr							;display the characters to clear the screen
	DisplayString clearScr							;display the characters to clear the screen
	DisplayString strValuesStored					;display a helpful message telling the user that the values have been stored.
	DisplayString crlf								;display characters to go to next line.
	DisplayString crlf								;display characters to go to next line.
	DisplayString enterToCont						;display the press enter to continue message
	PullString strEnter, 0							;wait for the user to press enter
	DisplayString clearScr							;display the characters to clear the screen
	MOV matrixBActive, 1 							;set the matrix as active so it unlocks the other methods
	JMP getUserChoice								;jump back up to display the menu
choiceC: ;display a
	CMP matrixAActive, 1							;checks to see if the matrix is active before executing the method
	JNE lockedMethod								;if it is not active, then jump to display it is locked
	DisplayString enterValRow						;Displays the string asking for the number of rows
	PullString rowA, 10								;get the number input and put into variable
	CvtoNum rowA									;convert the ascii value into dec
	MOV rowA, EAX									;store this in vairiable
	DisplayString enterValCol						;Displays the string asking for the number of cols
	PullString colA, 10								;get the number input and put into variable
	CvtoNum colA									;convert the ascii value into dec
	MOV colA, EAX									;store this in vairiable
	
	INVOKE displayArray, OFFSET arrayA, rowA, colA, ;call the display array method so we have the set of characters in the strdisplay address
	OFFSET strDisplay
	
	DisplayString crlf								;display characters to go to next line.
	DisplayString crlf								;display characters to go to next line.
	DisplayString crlf								;display characters to go to next line.
	DisplayString strDisplay						;display the characters inside ofo the str display vairiable
	DisplayString enterToCont						;display the press enter to continue message
	PullString strEnter, 0							;wait for the user to press enter
	DisplayString clearScr							;display the characters to clear the screen
	JMP getUserChoice								;jump back up to display the menu
choiceD: ;display b
	CMP matrixBActive, 1							;checks to see if the matrix is active before executing the method
	JNE lockedMethod								;if it is not active, then jump to display it is locked
	DisplayString enterValRow						;Displays the string asking for the number of rows
	PullString rowB, 10								;get the number input and put into variable
	CvtoNum rowB									;convert the ascii value into dec
	MOV rowB, EAX									;store this in vairiable
	DisplayString enterValCol						;Displays the string asking for the number of cols
	PullString colB, 10								;get the number input and put into variable
	CvtoNum colB									;convert the ascii value into dec
	MOV colB, EAX									;store this in vairiable
	
	INVOKE displayArray, OFFSET arrayB, rowB, colB,	;call the display array method so we have the set of characters in the strdisplay address
	OFFSET strDisplay
	DisplayString crlf								;display characters to go to next line.	
	DisplayString crlf								;display characters to go to next line.
	DisplayString crlf								;display characters to go to next line.
	DisplayString strDisplay						;display the characters inside ofo the str display vairiable
	DisplayString enterToCont						;display the press enter to continue message
	PullString strEnter, 0							;wait for user to press enter
	DisplayString clearScr							;display the characters to clear the screen
	JMP getUserChoice								;jump back up to display the menu							
choiceE: ;add up A
	CMP matrixAActive, 1							;checks to see if the matrix is active before executing the method
	JNE lockedMethod								;if it is not active, then jump to display it is locked
	DisplayString enterValRow						;Displays the string asking for the number of rows
	PullString rowA, 10								;get the number input and put into variable
	CvtoNum rowA									;convert the ascii value into dec
	MOV rowA, EAX									;store this in vairiable
	DisplayString enterValCol						;Displays the string asking for the number of cols
	PullString colA, 10								;get the number input and put into variable
	CvtoNum colA									;convert the ascii value into dec
	MOV colA, EAX									;store this in vairiable
	
	INVOKE sumUpArray, OFFSET arrayA, rowA, colA	;call the sum up array method which returns the value in eax
	MOV tempNum, EAX								;store this into a variable so we dont pass eax as invoke
		
	INVOKE intasc32, addr strDisplay, tempNum		;convert the number into ascii and store into strdisplay

	DisplayString strSum							;display the sum message
	DisplayString strDisplay						;display the characters inside ofo the str display vairiable
	DisplayString enterToCont						;display the press enter to continue message
	PullString strEnter, 0							;wait for user to press enter
	DisplayString clearScr							;display the characters to clear the screen
	JMP getUserChoice								;jump back up to display the menu		
choiceF: ;Add up B
	CMP matrixBActive, 1							;checks to see if the matrix is active before executing the method
	JNE lockedMethod								;if it is not active, then jump to display it is locked
	DisplayString enterValRow						;Displays the string asking for the number of rows
	PullString rowB, 10								;get the number input and put into variable
	CvtoNum rowB									;convert the ascii value into dec
	MOV rowB, EAX									;store this in vairiable
	DisplayString enterValCol						;Displays the string asking for the number of cols
	PullString colB, 10								;get the number input and put into variable
	CvtoNum colB									;convert the ascii value into dec
	MOV colB, EAX									;store this in vairiable
	
	INVOKE sumUpArray, OFFSET arrayB, rowB, colB	;call the sum up array method which returns the value in eax
	MOV tempNum, EAX								;store this into a variable so we dont pass eax as invoke
		
	INVOKE intasc32, addr strDisplay, tempNum		;convert the number into ascii and store into strdisplay

	DisplayString strSum							;display the sum message
	DisplayString strDisplay						;display the characters inside ofo the str display vairiable
	DisplayString enterToCont						;display the press enter to continue message
	PullString strEnter, 0							;wait for user to press enter
	DisplayString clearScr							;display the characters to clear the screen
	JMP getUserChoice								;jump back up to display the menu		
choiceG: ;sort and display A
	CMP matrixAActive, 1							;checks to see if the matrix is active before executing the method
	JNE lockedMethod								;if it is not active, then jump to display it is locked
	DisplayString strSortLength						;display a string asking how many elements to sort
	PullString numValues, 10						;pull the string the user types in 
	CvtoNum numValues								;convert the ascii number to decimal
	MOV numValues, EAX								;move eax into a variable so we dont invoke it
	DisplayString crlf								;display characters to go to next line.
	DisplayString crlf								;display characters to go to next line.
	INVOKE selectionSort, OFFSET arrayA, numValues  ;call the selection sort method to sort the array
	DisplayString enterToCont						;display the press enter to continue message
	PullString strEnter, 0							;wait for user to press enter
	DisplayString clearScr							;display the characters to clear the screen
	JMP getUserChoice								;jump back up to display the menu		
choiceH: ;sort and display B
	CMP matrixBActive, 1							;checks to see if the matrix is active before executing the method
	JNE lockedMethod								;if it is not active, then jump to display it is locked
	DisplayString strSortLength						;display a string asking how many elements to sort
	PullString numValues, 10						;pull the string the user types in 
	CvtoNum numValues								;convert the ascii number to decimal
	MOV numValues, EAX								;move eax into a variable so we dont invoke it
	DisplayString crlf								;display characters to go to next line.
	DisplayString crlf								;display characters to go to next line.
	INVOKE selectionSort, OFFSET arrayB, numValues  ;call the selection sort method to sort the array
	DisplayString enterToCont						;display the press enter to continue message
	PullString strEnter, 0							;wait for user to press enter
	DisplayString clearScr							;display the characters to clear the screen
	JMP getUserChoice								;jump back up to display the menu			
choiceI: ;multiply
	JMP notImplemented								;jump to the not implemented section
choiceJ: ;display c
	JMP notImplemented								;jump to the not implemented section
choiceK: ;add up c
	JMP notImplemented								;jump to the not implemented section
choiceL: ;sort c
	JMP notImplemented								;jump to the not implemented section
choiceM: ;smallest a
	CMP matrixAActive, 1							;checks to see if the matrix is active before executing the method
	JNE lockedMethod								;if it is not active, then jump to display it is locked
	DisplayString enterValRow						;Displays the string asking for the number of rows
	PullString rowA, 10								;get the number input and put into variable
	CvtoNum rowA									;convert the ascii value into dec
	MOV rowA, EAX									;store this in vairiable
	DisplayString enterValCol						;Displays the string asking for the number of cols
	PullString colA, 10								;get the number input and put into variable
	CvtoNum colA									;convert the ascii value into dec
	MOV colA, EAX									;store this in vairiable
	
	INVOKE smallestValue, OFFSET arrayA, rowA, colA	;call the sum up array method which returns the value in eax
	MOV tempNum, EAX								;store this into a variable so we dont pass eax as invoke
		
	INVOKE intasc32, addr strDisplay, tempNum		;convert the number into ascii and store into strdisplay

	DisplayString strSmallestNum					;display the sum message
	DisplayString strDisplay						;display the characters inside ofo the str display vairiable
	DisplayString enterToCont						;display the press enter to continue message
	PullString strEnter, 0							;wait for user to press enter
	DisplayString clearScr							;display the characters to clear the screen
	JMP getUserChoice								;jump back up to display the menu	
choiceN: ;smallest b
	CMP matrixBActive, 1							;checks to see if the matrix is active before executing the method
	JNE lockedMethod								;if it is not active, then jump to display it is locked
	DisplayString enterValRow						;Displays the string asking for the number of rows
	PullString rowB, 10								;get the number input and put into variable
	CvtoNum rowB									;convert the ascii value into dec
	MOV rowB, EAX									;store this in vairiable
	DisplayString enterValCol						;Displays the string asking for the number of cols
	PullString colB, 10								;get the number input and put into variable
	CvtoNum colB									;convert the ascii value into dec
	MOV colB, EAX									;store this in vairiable
	
	INVOKE smallestValue, OFFSET arrayB, rowB, colB	;call the sum up array method which returns the value in eax
	MOV tempNum, EAX								;store this into a variable so we dont pass eax as invoke
		
	INVOKE intasc32, addr strDisplay, tempNum		;convert the number into ascii and store into strdisplay

	DisplayString strSmallestNum					;display the sum message
	DisplayString strDisplay						;display the characters inside ofo the str display vairiable
	DisplayString enterToCont						;display the press enter to continue message
	PullString strEnter, 0							;wait for user to press enter
	DisplayString clearScr							;display the characters to clear the screen
	JMP getUserChoice								;jump back up to display the menu
choiceO: ;smallest c
	JMP notImplemented								;jump to the not implemented section
choiceQ:
	JMP finished									;Jump to the end of the program, terminate.
	
lockedMethod:
	DisplayString clearScr							;display the characters to clear the screen
	DisplayString strLocked							;show a message telling the user that this method is currently locked
	JMP getUserChoice								;jump back up to display the menu	
notImplemented:
	DisplayString clearScr							;display the characters to clear the screen
	DisplayString strMethodNotAdded					;show a message telling the user that this method has not been implemented
	JMP getUserChoice								;jump back up to display the menu

;************************************* the instructions below calls for "normal termination"	
finished:
	INVOKE ExitProcess,0						 
	PUBLIC _start
	
main ENDP

	END												;Signals assembler that there are no instructions after this statement