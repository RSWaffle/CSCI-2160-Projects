;******************************************************************************************
;*  Program Name: Student.asm
;*  Programmer:   Ryan Shupe
;*  Class:        CSCI 2160-001
;*  Lab:		  Proj 5
;*  Date:         Created 11/23/2019
;*  Purpose:      create a student class that can hold different attrubutes about a student
;*				   and create setters and getters
;******************************************************************************************
	.486						;This tells assembler to generate 32-bit code
	.model flat					;This tells assembler that all addresses are real addresses
	.stack 100h					;EVERY program needs to have a stack allocated
;******************************************************************************************
memoryallocBailey PROTO Near32 stdcall, dSize:DWORD
appendString	  PROTO Near32 stdcall, lpDestination:dword, lpSource:dword
intasc32 proto Near32 stdcall, lpStringToHold:dword, dval:dword
Student_setName PROTO stdcall, ths:dword, addrFirst:dword, addrLast:dword
Student_getZip PROTO stdcall, ths:dword
Student_getName PROTO stdcall, ths:dword
Student_getStreet PROTO stdcall, ths:dword
getBytes PROTO stdcall, String1:dword
Student_calcAvg PROTO stdcall, ths:dword
Student_letterGrade PROTO stdcall, ths:dword
;******************************************************************************************	
Student STRUCT 
	last byte 100 dup(0)					;space to hold the last name of the student
	first byte 100 dup(0)					;space to hold the first name of the student
	street byte 200 dup(0)					;space to hold the street address
	zip dword ?								;space to hold the zip
	test1 word ?							;word to hold the test score 1
	test2 word ?							;word to hold the test score 2
	test3 word ? 							;word to hold the test score 3
Student ENDS
;******************************************************************************************
.DATA
spaceChar byte 32,0									;memory to hold the space char
nextLine byte 10,0									;memory to store the next line char

strTest1 byte "Test 1: ", 0
strTest2 byte "Test 2: ", 0
strTest3 byte "Test 3: ", 0
strAverage byte "Average: ", 0
strGrade byte "Grade: ", 0
;******************************************************************************************
.CODE

COMMENT%
******************************************************************************
*Name: Student_1                                                             *
*Purpose:                                                                    *
*	  Creates a student object with dynamic memory allocated                 *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*****************************************************************************%
Student_1 PROC stdcall
	INVOKE memoryallocBailey, sizeof Student 			;allocates memory onto the heap the required amount for a student struct
	RET													;returns where I was called, address in EAX
Student_1 endp

COMMENT%
******************************************************************************
*Name: Student_2                                                             *
*Purpose:                                                                    *
*	  Creates a student object with enough memory allocated, with a name set *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param addrFirst:dword                                                      *
*@param addrLast:dword                                                       *
*****************************************************************************%
Student_2 PROC stdcall, firstN:dword, lastN:dword
	INVOKE memoryallocBailey, sizeof Student			;allocate enough memory to hold a student
	PUSH EAX											;store the address it gives
	INVOKE Student_setName, EAX, firstN, lastN			;set the name of the student
	POP EAX												;restore our pushed address of the student
	RET 8												;return back to where i was called cleaning
	8 bytes, address in EAX
Student_2 ENDP

COMMENT%
******************************************************************************
*Name: Student_3                                                             *
*Purpose:                                                                    *
*	  Creates a student object with enough memory allocated, also intakes    *
*      another student and copies from it and fills the new student.		 *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param sc:dword                                         		             *
*****************************************************************************%
Student_3 PROC stdcall, sc:dword

	RET 4												;returns back to where I was called with 4 bytes, address in eax.
Student_3 ENDP

COMMENT%
******************************************************************************
*Name: setName                                                               *
*Purpose:                                                                    *
*	  Intakes a student first and last name and stores it onto the heap address*
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@param addrFirst:dword                                                      *
*@param addrLast:dword                                                       *
*****************************************************************************%
Student_setName PROC stdcall uses EBX, ths:dword, addrFirst:dword, addrLast:dword
	MOV EBX, ths										;moves the address of the student into ebx.
	ASSUME EBX:PTR Student								;assumes that ebx is a student pointer so we dont have to type that every line
	INVOKE appendString, addr [EBX].first, addrFirst	;appends the first name string sent in onto the correct memory location	
	INVOKE appendString, addr [EBX].last, addrLast		;appends the last name string sent in ontto the correct memory location	
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 12												;return to where I was called, cleaning 12 bytes.
Student_setName ENDP

COMMENT%
******************************************************************************
*Name: setTestScores                                                         *
*Purpose:                                                                    *
*	  Intakes a student and test scores and stores them in the appropriate   *
*			memory location 												 *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@param t1:word                                                              *
*@param t2:word                                                              *
*@param t3:word                                                              *
*****************************************************************************%
Student_setTestScores PROC stdcall uses ebx edx, ths:dword, t1:word, t2:word, t3:word
	MOV EBX, ths										;moves the address of the student into ebx.
	ASSUME EBX:PTR Student								;assumes that ebx is a student pointer so we dont have to type that every line
	MOV DX, t1											;moves the first test into dx
	MOV [EBX].test1, DX									;moves the word into the memory location where test 1 is 
	MOV DX, t2											;moves the first test into dx
	MOV [EBX].test2, DX									;moves the word into the memory location where test 1 is 
	MOV DX, t3											;moves the first test into dx
	MOV [EBX].test3, DX									;moves the word into the memory location where test 1 is 
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 10												;return to where I was called, cleaning 12 bytes.
Student_setTestScores ENDP

COMMENT%
******************************************************************************
*Name: setTest                                                               *
*Purpose:                                                                    *
*	  Intakes a student and test scores and stores them in the appropriate   *
*			memory location 												 *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@param score:word                                                           *
*@param testNum:word                                                         *
*****************************************************************************%
Student_setTest PROC stdcall uses EBX, ths:dword, score:word, numTest:word
	MOV EBX, ths										;moves the address of the student into ebx.
	ASSUME EBX:PTR Student								;assumes that ebx is a student pointer so we dont have to type that every line
	.IF numTest == 1									;if the in test num is equal to 1
		MOV DX, score									;moves the first test into dx
		MOV [EBX].test1, DX								;moves the word into the memory location where test 1 is 
	.ELSEIF numTest == 2								;if the in test num is equal to 2
		MOV DX, score									;moves the first test into dx
		MOV [EBX].test2, DX								;moves the word into the memory location where test 1 is 	
	.ELSEIF numTest == 3								;if the in test num is equal to 3
		MOV DX, score									;moves the first test into dx
		MOV [EBX].test3, DX								;moves the word into the memory location where test 1 is 
	.ELSE												;if the test number is not 1-3
														;if this was java i would throw an exception here
	.ENDIF												;end if
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 8												;return to where i was called from and cleaning 8 bytes
Student_setTest ENDP

COMMENT%
******************************************************************************
*Name: setStreet                                                             *
*Purpose:                                                                    *
*	  Intakes a student and a street and copies the street onto the memory   *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@param streetAddr:dword                                                     *
*****************************************************************************%
Student_Street PROC stdcall, ths:dword, streetAddr:dword
	MOV EBX, ths										;moves the address of the student into ebx.
	ASSUME EBX:PTR Student								;assumes that ebx is a student pointer so we dont have to type that every line
	INVOKE appendString, addr [EBX].street, streetAddr	;appends the street in into the location it should go onto the heap
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 8												;return to where i was called from and cleaning 8 bytes
Student_Street ENDP

COMMENT%
******************************************************************************
*Name: setZip                                                                *
*Purpose:                                                                    *
*	  Intakes a student and a dword zip code, then places the zip in, into   *
*     the student's zip                                                      *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@param inZip:dword                                                          *
*****************************************************************************%
Student_setZip PROC stdcall uses EBX EDX, ths:dword, inZip:dword
	MOV EBX, ths										;moves the address of the student into ebx
	ASSUME EBX:ptr Student								;assumes ebx is a student pointer so we dont have to type it 
	MOV EDX, inZip										;moves the zip parameter into a register, cant do mem to mem
	MOV [EBX].zip, EDX									;moves the zip sent into the method into the zip in student 
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 8												;returns to where I was called cleaning 8 bytes. 
Student_setZip ENDP

COMMENT%
******************************************************************************
*Name: setAddr                                                               *
*Purpose:                                                                    *
*	  Intakes a student and a dword address to an address, then places the   *
*		address in, into the student's address              				 *
*                                                                            *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@param inAddr:dword                                                         *
*****************************************************************************%
Student_setAddr PROC stdcall uses EBX EDX, ths:dword, inAddr:dword, inZip:dword
	MOV EBX, ths										;moves the address of the student into ebx
	ASSUME EBX:PTR Student								;assumes ebx is a student so we dont have to type it later
	INVOKE appendString, addr [EBX].street, inAddr		;appends the street in into the location it should go onto the heap
	MOV EDX, inZip										;moves the zip param into edx, cant do mem to mem
	MOV [EBX].zip, EDX									;moves the zip sent into the method into the zip in the student
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 8												;returns to where I was called, cleaning 8 bytes.
Student_setAddr ENDP

COMMENT%
******************************************************************************
*Name: getName                                                               *
*Purpose:                                                                    *
*	  Intakes a student and returns the address of where the name is 		 *
*			( new generated string on the heap)                              *
*                                                                            *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@returns outAddr:dword                                                      *  
*****************************************************************************%
Student_getName PROC stdcall uses EBX EDX, ths:dword
	MOV EBX, ths										;moves the address of the student into ebx
	ASSUME EBX:PTR Student								;assumes ebx is a student so we dont have to type it later
	INVOKE memoryallocBailey, 200						;allocate 200 bytes of memory (enough for a big name)
	MOV EDX, EAX										;moves the address of the heap onto edx so we can invoke it
	INVOKE appendString, EDX, addr [EBX].first			;appends the first name at the address
	INVOKE appendString, EDX, addr spaceChar			;appends a space character onto the address
	INVOKE appendString, EDX, addr [EBX].last			;appends the last name onto the address
	MOV EAX, EDX										;moves the address of the name into eax for returning
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 4												;returns to where I was called, cleaning 8 bytes.
Student_getName ENDP

COMMENT%
******************************************************************************
*Name: getTest                                                               *
*Purpose:                                                                    *
*	  Intakes a student and test number and retuns the test grade            *
*                                                                            *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@param numTest:word                                                         *
*@returns testScore:word                                                     *  
*****************************************************************************%
Student_getTest PROC stdcall uses EBX, ths:dword, numTest:word
	MOV EBX, ths										;moves the address of the student into ebx
	ASSUME EBX:PTR Student								;assumes ebx is a student so we dont have to type it later
	.IF numTest == 1									;if the in test num is equal to 1
		MOV AX, [EBX].test1								;moves the score from the test into AX
	.ELSEIF numTest == 2								;if the in test num is equal to 2
		MOV AX, [EBX].test2								;moves the score from the test into AX	
	.ELSEIF numTest == 3								;if the in test num is equal to 3
		MOV AX, [EBX].test3								;moves the score from the test into AX
	.ELSE												;if the test number is not 1-3
	.ENDIF												;if this was java i would throw an exception at the else
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 6												;returns to where I was called, cleaning 8 bytes.
Student_getTest ENDP


COMMENT%
******************************************************************************
*Name: getAddress                                                            *
*Purpose:                                                                    *
*	  Intakes a student and returns the street + zip 			             *
*                                                                            *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@returns outAddr:dword                                                      *  
*****************************************************************************%
Student_getAddress PROC stdcall uses ECX EDX EDI, ths:dword 
	MOV EDX, 0
	MOV EBX, ths										;moves the address of the student into ebx
	ASSUME EBX:PTR Student								;assumes ebx is a student so we dont have to type it later
	INVOKE memoryallocBailey, 205						;allocates enough memory for a complete address
	MOV EDI, EAX										;moves into edi the address given back from the allocation
	INVOKE Student_getStreet, ths						;gets the street from the current student passed in
	MOV EDX, EAX										;moves into EDX, the returning street address in EAX
	INVOKE appendString, EDI, EDX						;appends the street to the blank allocated memory
	INVOKE appendString, EDI, addr spaceChar			;appends a space character onto the address
	INVOKE Student_getZip, ths							;gets the current zip from the student and address is in eax
	MOV EDX, EAX										;moves the address of the zip into eax
	INVOKE appendString, EDI, EDX						;appends the zip at the end of the current string allocated (the street and the space to seperate)
	MOV EAX, EDI										;moves the address of the address into eax for returning
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 4												;returns to where I was called, cleaning 8 bytes.
Student_getAddress ENDP

COMMENT%
******************************************************************************
*Name: getStreet                                                             *
*Purpose:                                                                    *
*	  Intakes a student and returns the street      			             *
*                                                                            *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@returns outAddr:dword                                                      *  
*****************************************************************************%
Student_getStreet PROC stdcall uses ebx edx, ths:dword
	MOV EDX, 0											;clear our edx
	MOV EBX, ths										;moves the address of the student into ebx
	ASSUME EBX:PTR Student								;assumes ebx is a student so we dont have to type it later
	INVOKE memoryallocBailey, 200						;allocate 205 bytes of memory (enough for a street and 5 digit zip)
	MOV EDX, EAX										;moves the address of the heap onto edx so we can invoke it
	INVOKE appendString, EDX, addr [EBX].street			;appends the street at the address
	MOV EAX, EDX										;moves the address of the address into eax for returning
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 4												;returns to where I was called, cleaning 8 bytes.
Student_getStreet ENDP

COMMENT%
******************************************************************************
*Name: getStreet                                                             *
*Purpose:                                                                    *
*	  Intakes a student and returns the street      			             *
*                                                                            *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@returns outAddr:dword                                                      *  
*****************************************************************************%
Student_getZip PROC stdcall uses ebx ecx edi, ths:dword
	MOV ECX, 0											;clear out ecx
	MOV EBX, ths										;moves the address of the student into ebx
	ASSUME EBX:PTR Student								;assumes ebx is a student so we dont have to type it later
	INVOKE memoryallocBailey, 5							;allocate 5 bytes to convert the zip
	MOV EDI, EAX										;move the address of the zip into edi
	MOV ECX, [EBX].zip									;moves the address of the zip into ECX
	INVOKE intasc32, EDI, dword ptr [ECX]				;converts the zipcode into ascii form 
	MOV EAX, EDI										;moves the address of the address into eax for returning
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 4												;returns to where I was called, cleaning 8 bytes.
Student_getZip ENDP

COMMENT%
******************************************************************************
*Name: findMax                                                               *
*Purpose:                                                                    *
*	  finds the max test grade of the student        			             *
*                                                                            *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@returns outTest:word                                                       *  
*****************************************************************************%
Student_findMax PROC stdcall uses EBX , ths:dword										
	MOV EBX, ths										;moves the address of the student into ebx
	ASSUME EBX:PTR Student								;assumes ebx is a student so we dont have to type it later
	MOV AX, [EBX].test1									;moves the value in t1 into register so we can compare without mem to mem error
	.IF  AX > [EBX].test2 && AX > [EBX].test3			;if the value in t1 is greater than t2 and t3
		MOV AX, [EBX].test1								;moves the first test into the largest spot
	.ELSE												;considering the value in t1 is less than t2 and t3 we can use else
		MOV AX, [EBX].test2								;moves the value of t2 into the register for comparison
		.IF AX > [EBX].test3							;if the value t2 is greater than t3, it is therefore the greatest number	
			MOV AX, [EBX].test2							;moves the test 2 into the largest spot
		.ELSE											;test3 is the greatest if this gets hit
			MOV AX, [EBX].test3							;move the test score 3 into the largest spot
		.ENDIF											;end if
	.ENDIF												;ends if
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 4												;returns to where I was called, cleaning 8 bytes.
Student_findMax ENDP

COMMENT%
******************************************************************************
*Name: findMin                                                               *
*Purpose:                                                                    *
*	  finds the min test grade of the student        			             *
*                                                                            *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@returns outTest:word                                                       *  
*****************************************************************************%
Student_findMin PROC stdcall, ths:dword
	MOV EBX, ths										;moves the address of the student into ebx
	ASSUME EBX:PTR Student								;assumes ebx is a student so we dont have to type it later
	MOV AX, [EBX].test1									;moves the value in t1 into register so we can compare without mem to mem error
	.IF  AX < [EBX].test2 && AX < [EBX].test3			;if the value in t1 is greater than t2 and t3
		MOV AX, [EBX].test1								;moves the first test into the smallest spot
	.ELSE												;considering the value in t1 is less than t2 and t3 we can use else
		MOV AX, [EBX].test2								;moves the value of t2 into the register for comparison
		.IF AX < [EBX].test3							;if the value t2 is greater than t3, it is therefore the greatest number	
			MOV AX, [EBX].test2							;moves the test 2 into the smallest spot
		.ELSE											;test3 is the greatest if this gets hit
			MOV AX, [EBX].test3							;move the test score 3 into the smallest spot
		.ENDIF											;end if
	.ENDIF												;ends if
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 4												;returns to where I was called, cleaning 8 bytes.
Student_findMin ENDP

COMMENT%
******************************************************************************
*Name: calcAvg                                                               *
*Purpose:                                                                    *
*	  finds the average of the 3 test grades        			             *
*                                                                            *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@returns outAvg:word                                                        *  
*****************************************************************************%
Student_calcAvg PROC stdcall uses EBX, ths:dword
	MOV EBX, ths										;moves the address of the student into ebx
	ASSUME EBX:PTR Student								;assumes ebx is a student so we dont have to type it later
	MOV AX, [EBX].test1									;moves the first test into AX
	MOV DX, [EBX].test2									;moves the second test into DX
	ADD AX, DX											;add the first two tests together
	MOV DX, [EBX].test3									;move the third test into DX
	ADD AX, DX											;all 3 are added together now
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	MOV BL, 3											;we are dividing by 3
	iDIV BL												;divide by 3
	CBW													;converts the byte to word
	RET 4												;returns to where I was called, cleaning 8 bytes.
Student_calcAvg ENDP

COMMENT%
******************************************************************************
*Name: calcAvg                                                               *
*Purpose:                                                                    *
*	  sends back a string address containing the students record             *
*                                                                            *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@returns outAddr:word                                                       *  
*****************************************************************************%
Student_studentRecord PROC stdcall uses EBX EDX EDI ESI, ths:dword
	MOV EBX, ths										;moves the address of the student into ebx
	ASSUME EBX:PTR Student								;assumes ebx is a student so we dont have to type it later
	INVOKE memoryallocBailey, 400						;holds enough space to have the record...
	MOV EDI, EAX										;moves the address given back into edi
	INVOKE Student_getName, ths							;gets the name of the student, address is in eax
	MOV EDX, EAX										;stores this address into edx
	INVOKE appendString, EDI, EDX						;appends the name onto the main string
	INVOKE appendString, EDI, addr nextLine				;appends the new line character
	INVOKE Student_getAddress, ths						;gets the address of the student, address is in eax
	MOV EDX, EAX										;moves the address into edx
	INVOKE appendString, EDI, EDX						;appends the address of the student at the end of the main string
	INVOKE appendString, EDI, addr nextLine				;appends the new line character
	INVOKE appendString, EDI, addr nextLine				;appends the new line character
	INVOKE appendString, EDI, addr strTest1				;append the test 1 string
	INVOKE Student_getTest, ths, 1						;get the score for the test
	MOV DX, AX											;move the score into dx
	INVOKE memoryallocBailey, 4							;allocate 4 bytes, to hold the asc conversion
	MOV ESI, EAX										;move into esi the address of the 4 byte allocation
	INVOKE intasc32, ESI, DX							;converts the test into ascii
	INVOKE appendString, EDI, ESI						;appends the test at the end of the main string
	INVOKE appendString, EDI, addr spaceChar			;appends the space char
	INVOKE appendString, EDI, addr spaceChar			;append the space character
	INVOKE appendString, EDI, addr strTest2				;append the test 1 string
	INVOKE Student_getTest, ths, 2						;get the score for the test
	MOV DX, AX											;move the score into dx
	INVOKE intasc32, ESI, DX							;converts the test into ascii
	INVOKE appendString, EDI, ESI						;appends the test at the end of the main string
	INVOKE appendString, EDI, addr spaceChar			;appends the space char
	INVOKE appendString, EDI, addr spaceChar			;append the space character
	INVOKE appendString, EDI, addr strTest3				;append the test 1 string
	INVOKE Student_getTest, ths, 3						;get the score for the test
	MOV DX, AX											;move the score into dx
	INVOKE intasc32, ESI, DX							;converts the test into ascii
	INVOKE appendString, EDI, ESI						;appends the test at the end of the main string
	INVOKE appendString, EDI, addr spaceChar			;appends the space char
	INVOKE appendString, EDI, addr spaceChar			;append the space character
	INVOKE appendString, EDI, addr strAverage			;append the average string		
	INVOKE Student_calcAvg, ths							;get the average
	MOV DX, AX											;move the avg into dx
	INVOKE intasc32, ESI, DX							;converts the test into ascii
	INVOKE appendString, EDI, ESI						;appends the test at the end of the main string
	INVOKE appendString, EDI, addr spaceChar			;append the space character
	INVOKE appendString, EDI, addr spaceChar			;append the space character
	INVOKE appendString, EDI, addr strGrade				;append the grade string to the main string
	INVOKE memoryallocBailey, 1							;allocated 1 byte of storage onto the heap
	MOV ESI, EAX										;moves the address of the 1 byte into esi
	INVOKE Student_letterGrade, ths						;gets the letter grade of the student
	MOV [ESI], AL										;moves into tehe 1 byte storage the letter grade
	INVOKE appendString, EDI, ESI						;appends the letter grade onto the main string
	MOV EAX, EDI										;moves the address of the main string into eax
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 4												;returns to where I was called, cleaning 8 bytes.
Student_studentRecord ENDP

COMMENT%
******************************************************************************
*Name: letterGrade                                                           *
*Purpose:                                                                    *
*	  sends back a letter grade corresponding to the average                 *
*                                                                            *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@returns outASCII:byte                                                      *  
*****************************************************************************%
Student_letterGrade PROC stdcall uses EBX EDX, ths:dword
	MOV EBX, ths										;moves the address of the student into ebx
	ASSUME EBX:PTR Student								;assumes ebx is a student so we dont have to type it later
	INVOKE Student_calcAvg, ths							;get the average of the tests
	.IF AX >= 90										;if the average is greater than or equal to 90
		MOV DL, 41h										;move the ASCII A (in hex) into DL
	.ELSEIF AX >= 80									;if it is greater or equal to 80
		MOV DL, 42h										;move the B character in DL
	.ELSEIF AX >= 70									;if it is greater or equal to 70
		MOV DL, 43h										;move the C character in DL
	.ELSEIF AX >= 60									;if it is greater or equal to 60
		MOV DL, 44h										;move the D character in DL
	.ELSE												;if it is not any of the above
		MOV DL, 45h										;move the F character into DL
	.ENDIF												;end if
	MOV AL, DL											;move DL into AL for output
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 4												;returns to where I was called, cleaning 8 bytes.
Student_letterGrade ENDP

COMMENT%
******************************************************************************
*Name: equals                                                                *
*Purpose:                                                                    *
*	  tests if the students tests are equal, if they are it returns 1        *
*                                                                            *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@param sc:dword                                                             *
*@returns outResult:byte                                                     *  
*****************************************************************************%
Student_equals PROC stdcall uses EBX ECX EDX, ths:dword, sc:dword
MOV ECX, 0												;moves 0 into ecx, to initialize
INVOKE Student_getTest, ths, 1							;get the first students test score
MOV DX, AX												;move the test score into edx
INVOKE Student_getTest, sc, 1							;get the second students test score
.IF AX == DX											;compare the two to see if they are equal
	INVOKE Student_getTest, ths, 2						;get the first students test score
	MOV DX, AX											;move the test score into edx
	INVOKE Student_getTest, sc, 2						;get the second students test score
	.IF AX == DX										;compare the two to see if they are equal
	INVOKE Student_getTest, ths, 3						;get the first students test score
	MOV DX, AX											;move the test score into edx
	INVOKE Student_getTest, sc, 3						;get the second students test score
		.IF AX == DX									;compare the two to see if they are equal
			MOV CL, 1									;if they are then the students test scores are equal
		.ELSE											;if not
			MOV CL, 0									;move 0 into cl if they are not equal
		.ENDIF											;end if
	.ELSE												;if not
		MOV CL, 0										;move 0 into cl they are not equal
	.ENDIF												;end if
.ELSE													;if not
	MOV CL, 0											;move 0 into cl they are not equal
.ENDIF													;end if
MOV AL, CL												;move the cl into al for standard output
RET 8													;return to where i was called cleaning 8 bytes
Student_equals ENDP
END