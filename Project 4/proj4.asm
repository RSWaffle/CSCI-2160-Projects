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

;******************************************************************************************

;  List all necessary prototypes for methods to be called here

	ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD  					;Executes "normal" termination

	intasc32 PROTO NEAR32 stdcall, lpStringToHold:dword, dval:dword			;Will convert any D-Word number into ACSII characters

	putstring  PROTO NEAR stdcall, lpStringToDisplay:dword  				;Will display ;characters until the NULL character is found

	getstring 	PROTO stdcall, lpStringToHoldInput:dword, maxNumChars:dword ;Get input from user and convert. 

	ascint32 PROTO NEAR32 stdcall, lpStringToConvert:dword  				;This converts ASCII characters to the dword value

;******************************************************************************************

;EXTERN sizeOfString:near32,createRectangle:near32,createTriangle:near32,createStringCopy:near32,hollowRectangle:near32, hollowTriangle:near32

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

;******************************************************************************************
.DATA
	strProjInfo byte  10,13,9,
        "Name: Ryan Shupe",10,
"       Class: CSCI 2160-001",10,
"        Date: 11/02/2019",10,
"         Lab: Project 4",0

	strMenu byte 10,10,10,13,9, "M E N U",10,
	"a) Input AND Extract values for matrix A",10,
	"b) Input AND Extract values for matrix B",10,
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
	
	choiceASCII byte ?

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
		
	DisplayString clearScr	
	JMP getUserChoice
	
	
choiceA:
	;DisplayString "A"
choiceB:
choiceC:
choiceD:
choiceE:
choiceF:
choiceG:
choiceH:
choiceI:
choiceJ:
choiceK:
choiceL:
choiceM:
choiceN:
choiceO:
choiceQ:
	JMP finished									;Jump to the end of the program, terminate.

;************************************* the instructions below calls for "normal termination"	
finished:
	INVOKE ExitProcess,0						 
	PUBLIC _start
	
main ENDP
	END												;Signals assembler that there are no instructions after this statement