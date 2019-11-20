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
Student_setName PROTO stdcall, ths:dword, addrFirst:dword, addrLast:dword
	
Student STRUCT 
	last byte 100 dup(0)
	first byte 100 dup(0)
	street byte 200 dup(0)
	zip dword ?
	test1 word ?
	test2 word ?
	test3 word ? 
Student ENDS
;******************************************************************************************
.DATA
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
	INVOKE memoryallocBailey, sizeof Student 	;allocates memory onto the heap the required amount for a student struct
	RET											;returns where I was called, address in EAX
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
	INVOKE memoryallocBailey, sizeof Student	;allocate enough memory to hold a student
	PUSH EAX									;store the address it gives
	INVOKE Student_setName, EAX, firstN, lastN	;set the name of the student
	POP EAX										;restore our pushed address of the student
	RET 8										;return back to where i was called with 8 bytes, address in EAX
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

RET 4											;returns back to where I was called with 4 bytes, address in eax.
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
	RET 12												;return to where I was called, returning 12 bytes.
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
	RET 10												;return to where I was called, returning 12 bytes.
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
	RET 8												;return to where i was called from and return 8 bytes
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
	RET 8												;return to where i was called from and return 8 bytes
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
	MOV EBX, ths									;moves the address of the student into ebx
	ASSUME EBX:ptr Student							;assumes ebx is a student pointer so we dont have to type it 
	MOV EDX, inZip									;moves the zip parameter into a register, cant do mem to mem
	MOV [EBX].zip, EDX								;moves the zip sent into the method into the zip in student 
	ASSUME EBX:ptr nothing							;ebx does not point to a student anymore
	RET 8											;returns to where I was called returning 8 bytes. 
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
	MOV EBX, ths									;moves the address of the student into ebx
	ASSUME EBX:PTR Student							;assumes ebx is a student so we dont have to type it later
	INVOKE appendString, addr [EBX].street, inAddr	;appends the street in into the location it should go onto the heap
	MOV EDX, inZip									;moves the zip param into edx, cant do mem to mem
	MOV [EBX].zip, EDX								;moves the zip sent into the method into the zip in the student
	ASSUME EBX:ptr nothing							;ebx does not point to a student anymore
	RET 8											;returns to where I was called, returning 8 bytes.
Student_setAddr ENDP

Student_getName PROC stdcall, ths:dword
Student_getName ENDP

Student_getTest PROC stdcall, ths:dword
Student_getTest ENDP

Student_getAddr PROC stdcall, ths:dword 
Student_getAddr ENDP

Student_getStreet PROC stdcall, ths:dword
Student_getStreet ENDP

Student_getZip PROC stdcall, ths:dword
Student_getZip ENDP

Student_findMax PROC stdcall, ths:dword
Student_findMax ENDP

Student_findMin PROC stdcall, ths:dword
Student_findMin ENDP

Student_calcAvg PROC stdcall, ths:dword
Student_calcAvg ENDP

Student_studentRecord PROC stdcall, ths:dword
Student_studentRecord ENDP

Student_letterGrade PROC stdcall, ths:dword
Student_letterGrade ENDP

Student_equals PROC stdcall, ths:dword, sc:dword
Student_equals ENDP
END