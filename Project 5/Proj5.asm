;******************************************************************************************
;*  Program Name: Proj5.asm
;*  Programmer:   Ryan Shupe
;*  Class:        CSCI 2160-001
;*  Lab:		  Proj 5
;*  Date:         Created 10/19/2019
;*  Purpose:      create a Student
;******************************************************************************************
	.486						;This tells assembler to generate 32-bit code
	.model flat					;This tells assembler that all addresses are real addresses
	.stack 100h					;EVERY program needs to have a stack allocated
;******************************************************************************************
	ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD  					;Executes "normal" termination
	intasc32  PROTO NEAR32 stdcall, lpStringToHold:dword, dval:dword			;Will convert any D-Word number into ACSII characters
	putstring PROTO NEAR stdcall, lpStringToDisplay:dword  				;Will display ;characters until the NULL character is found
	getstring PROTO stdcall, lpStringToHoldInput:dword, maxNumChars:dword ;Get input from user and convert. 
	ascint32  PROTO NEAR32 stdcall, lpStringToConvert:dword  				;This converts ASCII characters to the dword value
	;createHeapString PROTO stdcall, inAddr:dword
	pausesc   PROTO stdcall
	myInfo    PROTO stdcall, sName:dword, sSection:dword, sProjNum:dword
	getTime	  PROTO Near32 stdcall   ;returns address of time string
	Student_1 PROTO stdcall
	Student_2 PROTO stdcall, firstN:dword, lastN:dword
	Student_setName PROTO stdcall, ths:dword, addrFirst:dword, addrLast:dword
	Student_setAddr PROTO stdcall, ths:dword, inAddr:dword, inZip:dword
	Student_setTestScores PROTO stdcall, ths:dword, t1:word, t2:word, t3:word
	Student_setTest PROTO stdcall, ths:dword, score:word, numTest:word
	Student_getName PROTO stdcall, ths:dword
	Student_getTest PROTO stdcall, ths:dword, numTest:word
	Student_getAddress PROTO stdcall, ths:dword 
	Student_getZip PROTO stdcall, ths:dword
	Student_getStreet PROTO stdcall, ths:dword
	Student_findMax PROTO stdcall, ths:dword
	Student_findMin PROTO stdcall, ths:dword
	Student_calcAvg PROTO stdcall, ths:dword
	Student_studentRecord PROTO stdcall, ths:dword
	Student_equals PROTO stdcall, ths:dword, sc:dword
	


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
	INVOKE getstring, ADDR String, limit			;;Take the string input and store it into a variable, max amount of chars typed is sNumChars	
ENDM
;******************************************************************************************
.DATA
strName byte "Ryan Shupe",0
strSection byte "CSCI 2160-001",0

first byte "Ryan",0
last byte "Shupe",0
address byte "3008 South Roan St., Apt. 6",0
zip dword 37601

s1 dword ?
s2 dword ?
;******************************************************************************************
.CODE

_start:
	MOV EAX, 0										;Statement to help in debugging

main PROC
	INVOKE myInfo, addr strName, addr strSection, 5
	INVOKE Student_1
	MOV s1, EAX
	INVOKE Student_setName, s1, addr first, addr last
	INVOKE Student_setAddr, s1, addr address, addr zip
	INVOKE Student_setTestScores, s1, 100, 70, 88
	
	INVOKE Student_2, addr first, addr last
	MOV s2, EAX
	
	INVOKE Student_getName, s2
	INVOKE Student_setTestScores, s2, 100, 66, 88
	INVOKE Student_getTest, s2, 2
	
	INVOKE Student_getStreet, s1
	INVOKE Student_getZip, s1
	
	INVOKE Student_getAddress, s1
	
	INVOKE Student_findMax, s1
	INVOKE Student_findMin, s1
	
	INVOKE Student_calcAvg, s1
	INVOKE Student_studentRecord, s1
	
	INVOKE Student_equals, s1, s2
	
	
	INVOKE pausesc
	
	
;************************************* the instructions below calls for "normal termination"	
finished:
	INVOKE ExitProcess,0						 
	PUBLIC _start
	
main ENDP

COMMENT%
******************************************************************************
*Name: pausesc                                                               *
*Purpose:                                                                    *
*	  When invoked, displays a message press enter to continue. When the user* 
*		presses enter, the program returns 									 *
*Date Created: 11/15/2019                                                    *
*Date Modified: 11/15/2019                                                   *
*                                                                            *
*****************************************************************************%
pausesc PROC stdcall
.data
	strPressEnter byte 10, "Press ENTER to continue!",0 	
	strTemp byte 0											;a temp byte in memory for getstring
.code
	
	INVOKE putstring, addr strPressEnter					;display the press enter to continue message
	INVOKE getstring, addr strTemp, 0						;wait for the user to press enter
RET 														;return to where i was called.
pausesc ENDP

COMMENT%
******************************************************************************
*Name: myInfo                                                                *
*Purpose:                                                                    *
*	  Accepts a name and a section number and displays info to the screen    *
*		accordingly 														 *
*Date Created: 11/15/2019                                                    *
*Date Modified: 11/15/2019                                                   *
*                                                                            *
*                                                                            *
*@param nameAddr:dword                                                       *
*@param sSectionAddr:dword	                                                 *
*****************************************************************************%
myInfo PROC stdcall, sName:dword, sSection:dword, sProjNum:dword
.data
  strInfo1 byte 10,09, "    Name: ",0				
  strInfo2 byte 10,09, " Section: ",0
  strInfo3 byte 10,09, " Project: ",0
 strProj byte 4 dup(0)
.code
INVOKE putstring, addr strInfo1						;display the first part of the info screen
INVOKE putstring, sName								;display the provided name
INVOKE putstring, addr strInfo2						;display the second part of the info screen
INVOKE putstring, sSection							;display the provided section
INVOKE putstring, addr strInfo3						;display the third part of the info screen
INVOKE intasc32, addr strProj, sProjNum				;convert the decimal number into ascii
INVOKE putstring, addr strProj						;display the project number
INVOKE getTime										;call the get time method to get the current system time and construct a string
INVOKE putstring, EAX								;display the current time thats address is in eax
RET													;return to where i was called from
myInfo ENDP

	END												;Signals assembler that there are no instructions after this statement