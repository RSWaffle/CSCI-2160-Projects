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
	intasc32 PROTO NEAR32 stdcall, lpStringToHold:dword, dval:dword			;Will convert any D-Word number into ACSII characters
	putstring  PROTO NEAR stdcall, lpStringToDisplay:dword  				;Will display ;characters until the NULL character is found
	getstring 	PROTO stdcall, lpStringToHoldInput:dword, maxNumChars:dword ;Get input from user and convert. 
	ascint32 PROTO NEAR32 stdcall, lpStringToConvert:dword  				;This converts ASCII characters to the dword value
	heapDestroyHarrison PROTO Near32 stdcall								;Destroys the memory allocated by the allocate proc 
	extractWords PROTO Near32 stdcall, StringofChars:dword, ArrayDwords:dword
	putch PROTO Near32 stdcall, bVal:byte
	pausesc   PROTO stdcall													;displays the pause screen message and waits for user to press enter
	myInfo    PROTO stdcall, sName:dword, sSection:dword, sProjNum:dword	;display the info for the project
	getTime	  PROTO Near32 stdcall   										;returns address of time string
	Student_1 PROTO stdcall													;reference to the first constuctor
	Student_2 PROTO stdcall, firstN:dword, lastN:dword						;2nd student constructor
	Student_3 PROTO stdcall, sc:dword										;copy constructor
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
	Student_setStreet PROTO stdcall, ths:dword, streetAddr:dword
	Student_setZip PROTO stdcall, ths:dword, inZip:dword
	Student_letterGrade PROTO stdcall, ths:dword
	
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

COMMENT %
******************************************************************************
*Name: setStudentInfo                                                        *
*Purpose:                                                                    *
*	 fills in the information to be able to create a student 				 *
*                                                                            *
*Date Created: 11/20/2019                                                    *
*Date Modified: 11/20/2019                                                   *
*                                                                            *
*                                                                            *
*@param testArray:byte                                                       *
*@param Studentnum:byte                                                      *
*****************************************************************************%
setStudentInfo MACRO testArray, studentNum
	MOV EAX, 0
	DisplayString strStudentFName							;display string showing students first name
	INVOKE intasc32, addr strAsciiChar, studentNum  					;convert the student number to ascii
	DisplayString strAsciiChar								;display the string showing the student number
	DisplayString strCol									;display the string :
	PullString strTempF, 100								;get what the user typed and store into strTempF
	DisplayString strStudentLName							;ask for the students last name
	INVOKE intasc32, addr strAsciiChar, studentNum  					;convert the student number into ascii
	DisplayString strAsciiChar								;display the string showing the student number
	DisplayString strCol									;display the string :
	PullString strTempL, 100								;get what the user typed and store into strTempL	
	DisplayString strStudentStreet							;ask for the students last name
	INVOKE intasc32, addr strAsciiChar, studentNum  					;convert the student number into ascii
	DisplayString strAsciiChar								;display the string showing the student number
	DisplayString strCol									;display the string :
	PullString strTempStreet, 200							;get what the user typed and store into strTempL
	DisplayString strStudentZip								;ask for the students last name
	INVOKE intasc32, addr strAsciiChar, studentNum  					;convert the student number into ascii
	DisplayString strAsciiChar								;display the string showing the student number
	DisplayString strCol									;display the string :
	
	
ENDM
;******************************************************************************************
.DATA
strName byte "Ryan Shupe",0
strSection byte "CSCI 2160-001",0
strInfo1 byte 10,09, "    Name: ",0				
strInfo2 byte 10,09, " Section: ",0
strInfo3 byte 10,09, " Project: ",0
strPressEnter byte 10, "Press ENTER to continue!",0 	
strAskValues  byte 10, "Enter the scores for 3 tests: ",0
strStudentFName byte 10,10,"Enter the first name for Student ",0
strStudentLName byte 10,"Enter the last name for Student ",0
strStudentStreet byte 10,"Enter the street for Student ",0
strStudentZip byte 10,"Enter the 5 digit zip for Student ",0
strAverage byte 10, "The average of the grades for student 2 is: ", 0
strMaxTest byte 10, "The max grade for the student 1 is: ", 0
strMinTest byte 10, "The min grade for the student 2 is: ", 0
strStreet byte 10, "The street for the student 2 is: ", 0
strZip byte 10, "The zip for student 2 is: ", 0
strLetterGrade byte 10, "The letter grade for the student 1 is: ", 0

strCol byte ": ", 0		
zipDecimal1 dword 0,0								;memory to hold a decimal zip	
zipDecimal2 dword 0,0								;memory to hold a decimal zip	
zipDecimal3 dword 0,0								;memory to hold a decimal zip	
zipDecimal4 dword 0,0								;memory to hold a decimal zip	
strAsciiChar byte 0									;memory to hold 1 ascii char
;ALIGN
crlf byte  10,13,0									;Null-terminated string to skip to new line
strEmpty byte 0
tempNum dword 0
strTemp byte 0										;a temp byte in memory for getstring
strProj byte 4 dup(0), 10 							;memory to hold the project number
testArray word 50 dup (?),00						;memory to hold dwords in an array
numbersASCII byte 50 dup (?), 00					;memory to hold the ascii numbers
strTempF byte 100 dup (0),00						;memory that can hold a first name
strTempL byte 100 dup (0),00						;memory that can hold a last name
strTempStreet byte 200 dup (0),00					;memory that can hold a street
strTempZip byte 5 dup (0),00						;memory that can hold a zip	

s1 dword ?											;reference variable for student 1
s2 dword ?											;reference variable for student 2
s3 dword ?											;reference variable for student 3
s4 dword ?											;reference variable for student 4
;******************************************************************************************
.CODE

_start:
	MOV EAX, 0												;Statement to help in debugging

main PROC
	INVOKE myInfo, addr strName, addr strSection, 5 		;display the student information, section, time, and project number. 
	
	setStudentInfo testArray, 1
	MOV EAX, 0												;initialize the zip code to 0, so it doesnt pull a random value if the user enters nothing
	PullString strTempZip, 5   								;get what the user typed and store into strTempL
	INVOKE ascint32, addr strTempZip						;converts the zip into decimal 
	MOV zipDecimal1, EAX									;moves the decimal zip into dword 
	
	MOV EAX, offset testArray								;moves the address of the test array into eax
	MOV word ptr [EAX], 0									;set the first test score to 0 to clear out the value from the previous student
	MOV word ptr [EAX + 2], 0								;set the second test score to 0 to clear out the value from the previous student
	MOV word ptr [EAX + 4], 0								;set the third test score to 0 to clear out the value from the previous student
	
	DisplayString strAskValues								;display the string asking which values to store
	PullString numbersASCII, 50								;get what the user typed and store into numbersASCII			
	INVOKE extractWords, OFFSET numbersASCII, 				;call the extract words function so we have can convert our test scores into actual decimal numbers
	OFFSET testArray 
	
	INVOKE Student_1										;create the student 1 object
	MOV s1, EAX												;move the address of the student into s1
	INVOKE Student_setName, s1, addr strTempF, addr strTempL;sets the student name corresponding to the names passed in
	INVOKE Student_setAddr, s1, addr strTempStreet, 		;sets the address for the student corresponding to what the user typed in
	addr zipDecimal1
	MOV EDX, offset testArray								;moves the address of the 3 tests array into edx so we can reference the positions
	INVOKE Student_setTestScores, s1, word ptr [EDX], 		;sets the test scores for the student.
	word ptr [EDX + 2], word ptr [EDX + 4]
	
	setStudentInfo testArray, 2
	MOV EAX, 0												;initialize the zip code to 0, so it doesnt pull a random value if the user enters nothing
	PullString strTempZip, 5   								;get what the user typed and store into strTempL
	INVOKE ascint32, addr strTempZip						;converts the zip into decimal 
	MOV zipDecimal1, EAX									;moves the decimal zip into dword 
	
	MOV EAX, offset testArray								;moves the address of the test array into eax
	MOV word ptr [EAX], 0									;set the first test score to 0 to clear out the value from the previous student
	MOV word ptr [EAX + 2], 0								;set the second test score to 0 to clear out the value from the previous student
	MOV word ptr [EAX + 4], 0								;set the third test score to 0 to clear out the value from the previous student
	
	DisplayString strAskValues								;display the string asking which values to store
	PullString numbersASCII, 50								;get what the user typed and store into numbersASCII			
	INVOKE extractWords, OFFSET numbersASCII, 				;call the extract words function so we have can convert our test scores into actual decimal numbers
	OFFSET testArray 
	
	INVOKE Student_2, addr strTempF, addr strTempL			;create the student 2 object passing in the name provided
	MOV s2, EAX												;move the address of the student into s1
	INVOKE Student_setAddr, s2, addr strTempStreet, 		;sets the address for the student corresponding to what the user typed in
	addr zipDecimal2
	MOV EDX, offset testArray								;moves the address of the 3 tests array into edx so we can reference the positions
	INVOKE Student_setTest, s2, word ptr [EDX], 1			;sets the first test score
	INVOKE Student_setTest, s2, word ptr [EDX + 2], 2		;sets the second test score
	INVOKE Student_setTest, s2, word ptr [EDX + 4], 3		;sets the third test score
		
	setStudentInfo testArray, 3
	MOV EAX, 0												;initialize the zip code to 0, so it doesnt pull a random value if the user enters nothing
	PullString strTempZip, 5   								;get what the user typed and store into strTempL
	INVOKE ascint32, addr strTempZip						;converts the zip into decimal 
	MOV zipDecimal1, EAX									;moves the decimal zip into dword 
	
	MOV EAX, offset testArray								;moves the address of the test array into eax
	MOV word ptr [EAX], 0									;set the first test score to 0 to clear out the value from the previous student
	MOV word ptr [EAX + 2], 0								;set the second test score to 0 to clear out the value from the previous student
	MOV word ptr [EAX + 4], 0								;set the third test score to 0 to clear out the value from the previous student
	
	DisplayString strAskValues								;display the string asking which values to store
	PullString numbersASCII, 50								;get what the user typed and store into numbersASCII			
	INVOKE extractWords, OFFSET numbersASCII, 				;call the extract words function so we have can convert our test scores into actual decimal numbers
	OFFSET testArray 
	
	INVOKE Student_2, addr strTempF, addr strTempL			;create the student 2 object passing in the name provided
	MOV s3, EAX												;move the address of the student into s3
	INVOKE Student_setAddr, s3, addr strTempStreet, 		;sets the address for the student corresponding to what the user typed in
	addr zipDecimal3
	MOV EDX, offset testArray								;moves the address of the 3 tests array into edx so we can refernce the positions
	INVOKE Student_setTestScores, s3, word ptr [EDX], 		;sets the test scores for the student
	word ptr [EDX + 2], word ptr [EDX + 4]
	
	INVOKE Student_3, s1									;creates a copy of student 1
	MOV s4, EAX												;moves the address into s4
	
	INVOKE Student_studentRecord, s1						;gather the student record for the student
	DisplayString [EAX]										;display the students information
	
	INVOKE Student_studentRecord, s2						;gather the student record for the student
	DisplayString [EAX]										;display the students information
	
	INVOKE Student_studentRecord, s3						;gather the student record for the student
	DisplayString [EAX]										;display the students information
	
	INVOKE Student_studentRecord, s4						;gather the student record for the student
	DisplayString [EAX]										;display the students information
		
	INVOKE pausesc											;press enter to continue
	
; //1. Display s2’s test average with an appropriate message.
	DisplayString crlf										;skip to new line
	DisplayString strAverage								;display average is string
	INVOKE Student_calcAvg, s1								;gets the students average in AX
	CWDE													;convert to eax
	INVOKE intasc32, addr tempNum, EAX						;convert the average into ascii
	DisplayString tempNum									;displays the test score
	
; //2. Display s1’s 2nd test score, then display his first score, then display his 3rd score.
	DisplayString crlf								 		;skip to a new line.
	INVOKE Student_getTest, s1, 2							;gets the 2nd test score into AX
	CWDE													;convert to eax	
	DisplayString crlf										;skip to new line	
	INVOKE intasc32, addr numbersASCII, EAX					;converts it to ascii
	DisplayString numbersASCII								;displays the test score
	INVOKE Student_getTest, s1, 1							;gets the first test score into AX
	CWDE													;convert to eax				
	DisplayString crlf										;skip to new line	
	INVOKE intasc32, addr numbersASCII, EAX					;converts it to ascii
	DisplayString numbersASCII								;displays the average
	INVOKE Student_getTest, s1, 3							;gets the test score into AX
	CWDE													;convert to eax
	DisplayString crlf										;skip to new line	;
	INVOKE intasc32, addr numbersASCII, EAX					;converts it to ascii
	DisplayString numbersASCII								;displays the test score
	
; //3. pause
	INVOKE pausesc											;press enter to continue
	
; //4. Attempt to change s1’s 4th test score to 70. 
	INVOKE Student_setTest, s1, 70, 4						;attempts to change the 4th test score to 70
	
; //5. Attempt to Change s1’s 2nd test score to -65
	INVOKE Student_setTest, s1, -65, 2						;attemps to set the 2ns test to -65
	
; //6. Display s1’s 2nd test score. If your setter worked correctly, it should not have changed
	INVOKE Student_getTest, s1, 2							;get the 2nd test from the student in ax
	CWDE													;convert AX into EAX
	INVOKE intasc32, addr numbersASCII, EAX					;convert the test number into ascii
	DisplayString crlf										;skip to new line
	DisplayString numbersASCII								;display the test
	
; //7. Change s1’s name to NOTHING, that is the empty string.
	;INVOKE Student_setName, s1, strEmpty, strEmpty 
	
; //8. Display s1’s name. It should still be the same
	;INVOKE Student_getName, s1
	;MOV dword ptr numbersASCII, EAX
	;DisplayString numbersASCII
	
; //9. pause
	INVOKE pausesc											;press enter to continue
	
; //10. Display s1's highest test score with an appropriate message
	DisplayString strMaxTest								;display max test message
	INVOKE Student_findMax, s1								;get the students max test size into ax
	CWDE													;convert AX into EAX
	INVOKE intasc32, addr numbersASCII, EAX					;convert the test number into ascii
	DisplayString numbersASCII								;display the test
	DisplayString crlf										;skip to new line	
	
; //11. Display s2’s lowest test score with an appropriate message.
	DisplayString strMinTest								;display min test message
	INVOKE Student_findMin, s2								;get the students min test size into ax
	CWDE													;convert AX into EAX
	INVOKE intasc32, addr numbersASCII, EAX					;convert the test number into ascii
	DisplayString numbersASCII								;display the test
	DisplayString crlf										;skip to new line
	
; //12. Display s1’s lettergrade with an appropriate message.
	DisplayString strLetterGrade							;display letter grade message
	INVOKE Student_letterGrade, s1							;call the letter grade method to get the letter grade
	INVOKE putch, AL										;puts the letter grade onto the screen
	DisplayString crlf										;skip to new line
	
; //13. Display the name in the Student object ref by s1
; //14. pause
	INVOKE pausesc											;press enter to continue
	
; //15. Display s1’s name and address using ONE method

; //16. Display the street that s2 lives on with an appropriate message.
	DisplayString strStreet									;display street message
	INVOKE Student_getStreet, s2							;get the street address
	MOV tempNum, EAX										;moves the address into a temp variable
	INVOKE putstring, tempNum								;display the street of the student
	
	
; //17. Display the City that s2 lives in with an appropriate message.
	;???????	DOES NOT EXIST									
	
; //18. Display the State that s2 lives in with an appropriate message.
	;???????	DOES NOT EXIST							
	
; //19. Display the Zip Code for s2 with an appropriate message.	
	DisplayString strZip									;display street message
	INVOKE Student_getZip, s2	
	MOV tempNum, EAX										;moves the zip into eax
	INVOKE intasc32, addr strAsciiChar, addr tempNum
	DisplayString tempNum									;display the street from the stored address
	
; //20. pause
	INVOKE pausesc											;press enter to continue

	
;************************************* the instructions below calls for "normal termination"	
finished:
	;INVOKE heapDestroyHarrison						;clears the memory used by heap allocharrion
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
LOCAL bbyte:byte
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
LOCAL bbyte:byte
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