;******************************************************************************************
;Name: 		Dr. Bailey / Ryan Shupe
;Program: 	time.asm
;Class: 	CSCI 2160-001
;Lab: 		proj5a
;Date: 		November 2, 2019
;Purpose:
;		 call the GetLocalTime method and return a string made up of the time in some sort of readable format.e.g. 
; Time:  November 2, 2019  at 3:37:22 PM.  The getTime method is contained in an external file
;  time.asm  in which it will have its own data segment. It calls the getsTime method which
;  actually creates the string
;******************************************************************************************
	.486
	.model flat
;******************************************************************************************
	intasc32 			PROTO Near32 stdcall, lpStringToHold:dword, dval:dword
	intasc32Comma 		PROTO Near32 stdcall, lpStringToHold:dword, dval:dword
	GetLocalTime		PROTO Near32 stdcall, lpSystemTime:PTR SYSTEMTIME
	getsTime			PROTO Near32 stdcall, lpStringOfSysTime:dword,lpStringTime:dword
	getTime				PROTO Near32 stdcall   ;returns address of time string
	appendString		PROTO Near32 stdcall, lpDestination:dword, lpSource:dword
;******************************************************************************************	
SYSTEMTIME STRUCT
	wYear		word	?			;holds system year
	wMonth		word	?			;holds system month
	wDayOfWeek	word	?			;holds system DayOfWeek
	wDay		word	?			;holds system Day
	wHour		word	?			;holds system Hour
	wMinute		word	?			;holds system minute
	wSecond		word	?			;holds system second
	wMillisecs	word	?			;holds system millisecond									
SYSTEMTIME ENDS	
;******************************************************************************************
COMMENT%
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
	LOCAL stLoop						;;add a local label so the assembler doesnt yell when this is called more than once
	LOCAL done							;;add a local label so the assembler doesnt yell when this is called more than once
	PUSH EBP							;;preserves base register
	MOV EBP, ESP						;;sets a new stack frame
	PUSH EBX							;;pushes EBX to the stack to store this
	PUSH ESI							;;pushes ESI to the stack to preseve
	MOV EBX, String						;;moves into ebx the first val in the stack that we are going to use
	MOV ESI, 0							;;sets the initial point to 0
		
	stLoop:
		CMP byte ptr [EBX + ESI], 0		;;compares the two positions to determine if this is the end of the string
		JE done							;;if it is jump to finished
		INC ESI							;;if not increment esi
		JMP stLoop						;;jump to the top of the loop and look at the next char
	done:		
		INC ESI							;;increment esi to include the null character in the string
		MOV EAX, ESI					;;move the value of esi into eax for proper output and return
	
	POP ESI								;;restore original esi
	POP EBX								;;restore original ebx
	POP EBP								;;restore originla ebp
ENDM
;******************************************************************************************
	.DATA
sysTime 	SYSTEMTIME			<>  				  ;SYSTEM TIME variable with attributes of the time 
strTimeString  byte 200 dup(?)      				  ;contains the address of the dynamic time string
strTempString byte 50 dup(?)	    				  ;temp string that will be manipulated for output to time string
strJanuary byte 10,13,9," January ", 0
strFebruary byte 10,13,9," February ", 0
strMarch byte 10,13,9," March ", 0
strApril byte 10,13,9," April ", 0
strMay byte 10,13,9," May ", 0
strJune byte 10,13,9," June ", 0
strJuly byte 10,13,9," July ", 0
strAugust byte 10,13,9," August ", 0 
strSeptember byte 10,13,9," September ", 0
strOctober byte 10,13,9," October ", 0
strNovember byte 10,13,9," November ", 0
strDecember byte 10,13,9," December ", 0

strAM byte " A.M.", 0
strPM byte " P.M.", 0
strCol byte ":", 0
strAt byte " at ", 0
strComma byte ", ", 0
bAM byte 0											   ;byte to signify whether it is AM orPM
;******************************************************************************************
	.code
COMMENT%
******************************************************************************
*Name: getTime                                                               *
*Purpose:                                                                    *
*	  gets the system time and calls the method to format it into a string   *
*Date Created: 10/31/2019                                                    *
*Date Modified: 11/02/2019                                                   *
*                                                                            *
*                                                                            *
*****************************************************************************%
getTime	proc Near32 stdcall
	INVOKE GetLocalTime, ADDR sysTime				   ;calls the get local time method and it returns the local time from the PC 
	INVOKE getsTime, addr sysTime, addr strTimeString  ;returns a displayable string with the date and time
	RET
getTime	endp	

COMMENT%
******************************************************************************
*Name: getsTime                                                              *
*Purpose:                                                                    *
*	  Gets the time and returns the address with the formatted string in it  *
*Date Created: 10/31/2019                                                    *
*Date Modified: 11/02/2019                                                   *
*                                                                            *
*                                                                            *
*@param lpSystemTime:dword                                                   *
*@param lpTimeString:dword	                                                 *
*****************************************************************************%

getsTime proc  Near32 stdcall, lpSystemTime:dword, lpTimeString:dword
		LOCAL outputAddress:dword					   ;initializes the method with a output address local variable initialized
		MOV EBX, lpSystemTime						   ;move the input values into the local values so i dont get confused

		MOV EAX, lpTimeString						   ;moves the address of the string where the time will be displayed into eax
		MOV outputAddress, EAX						   ;moves the address in eax into the output address
		MOV EDX, outputAddress						   ;moves the output address into edx

		ASSUME EBX:ptr SYSTEMTIME					   ;assume that ebx is a systemtime so we can reference it easier
		MOVSX EAX, word ptr [EBX].wMonth			   ;moves the month number into eax so we can compare it to the correct month
		
		CMP EAX, 1									   ;compares the month number to 1
		JE January									   ;if it is 1 then jump to the january section
		CMP EAX, 2									   ;compares the month number to 2
		JE February									   ;if it is the month number then jump to the appropriate section
		CMP EAX, 3									   ;compares the month number to 3
		JE March									   ;if it is the month number then jump to the appropriate section
		CMP EAX, 4									   ;compares the month number to 4
		JE April									   ;if it is the month number then jump to the appropriate section
		CMP EAX, 5									   ;compares the month number to 5
		JE May										   ;if it is the month number then jump to the appropriate section
		CMP EAX, 6									   ;compares the month number to 6
		JE June										   ;if it is the month number then jump to the appropriate section
		CMP EAX, 7									   ;compares the month number to 7
		JE July										   ;if it is the month number then jump to the appropriate section
		CMP EAX, 8									   ;compares the month number to 8
		JE August									   ;if it is the month number then jump to the appropriate section
		CMP EAX, 9									   ;compares the month number to 9
		JE September								   ;if it is the month number then jump to the appropriate section
		CMP EAX, 10									   ;compares the month number to 10
		JE October									   ;if it is the month number then jump to the appropriate section
		CMP EAX, 11									   ;compares the month number to 11
		JE November									   ;if it is the month number then jump to the appropriate section
		CMP EAX, 12									   ;compares the month number to 12
		JE December									   ;if it is the month number then jump to the appropriate section
	
	January:	
		INVOKE appendString, lpTimeString, addr strJanuary			;appends the january string at the beginning of the address using appendString
		JMP InsertRest												;jump to the section to insert the rest of the time into the string
	February:
		INVOKE appendString, lpTimeString, addr strFebruary			;appends the february string at the beginning of the address using appendString
		JMP InsertRest												;jump to the section to insert the rest of the time into the string
	March:
		INVOKE appendString, lpTimeString, addr strMarch			;appends the march string at the beginning of the address using appendString
		JMP InsertRest												;jump to the section to insert the rest of the time into the string
	April:
		INVOKE appendString, lpTimeString, addr strApril			;appends the april string at the beginning of the address using appendString
		JMP InsertRest												;jump to the section to insert the rest of the time into the string
	May:	
		INVOKE appendString, lpTimeString, addr strMay				;appends the may string at the beginning of the address using appendString
		JMP InsertRest												;jump to the section to insert the rest of the time into the string
	June:
		INVOKE appendString, lpTimeString, addr strJune				;appends the june string at the beginning of the address using appendString
		JMP InsertRest												;jump to the section to insert the rest of the time into the string
	July:
		INVOKE appendString, lpTimeString, addr strJuly				;appends the july string at the beginning of the address using appendString
		JMP InsertRest												;jump to the section to insert the rest of the time into the string
	August:
		INVOKE appendString, lpTimeString, addr strAugust			;appends the august string at the beginning of the address using appendString
		JMP InsertRest												;jump to the section to insert the rest of the time into the string
	September:
		INVOKE appendString, lpTimeString, addr strSeptember		;appends the september string at the beginning of the address using appendString
		JMP InsertRest												;jump to the section to insert the rest of the time into the string		
	October:
		INVOKE appendString, lpTimeString, addr strOctober			;appends the octiber string at the beginning of the address using appendString
		JMP InsertRest												;jump to the section to insert the rest of the time into the string
	November:
		INVOKE appendString, lpTimeString, addr strNovember			;appends the november string at the beginning of the address using appendString
		JMP InsertRest												;jump to the section to insert the rest of the time into the string
	December:
		INVOKE appendString, lpTimeString, addr strDecember			;appends the december string at the beginning of the address using appendString
		JMP InsertRest												;jump to the section to insert the rest of the time into the string
		
	InsertRest:
		MOVSX EDX, word ptr [EBX].wDay 								;moves the day number into EDX with its sign extended to clear out the rest of the numbers
		INVOKE intasc32, ADDR strTempString, EDX 					;turns the day into a temp string of ascii characters
		INVOKE appendString, lpTimeString, addr strTempString		;appends the day at the end of the current time string which is just the month right now
		INVOKE appendString, lpTimeString, addr strComma			;inserts the comma string at the end of the current time string
		
		MOVSX EDX, word ptr [EBX].wYear								;moves the year into EDX with its sign extended to clear out the rest of the numbers
		INVOKE intasc32, ADDR strTempString, EDX					;turns the year into a temp string of ascii characters
		INVOKE appendString, lpTimeString, addr strTempString		;appends the day at the end of the current time string which is the month and day
		INVOKE appendString, lpTimeString, addr strAt				;inserts the word at at the end of the current time string
	
		MOVSX EDX, word ptr [EBX].wHour								;moves the current hour into edx with its sign extended to clear out the rest of the numbers
		CMP EDX, 0													;compares the hour number to 0 to check to osee if it is midnight
		JE Midnight													;if it is then jump to the midnight section
		CMP EDX, 24													;compares the current hour to 24 to see if it is midnight
		JE Midnight													;if it is then jump to the midnight section
		CMP EDX, 13													;compares the hour number to 13
		JGE PMConvert												;if it is greater than or equal to 13 then jump to the section that will enable the PM string
		INVOKE intasc32, ADDR strTempString, EDX					;converts the hour into the ascii characters
		INVOKE appendString, lpTimeString, addr strTempString		;appends to the end of the current time string what is in temp string 
		INVOKE appendString, lpTimeString, addr strCol				;appends a : at the end of the current time string
		MOV bAM, 1												;set the bAM variable to 1, so later we can display the AM message
		JMP Minute													;jump to the minute section
		
		Midnight:
			ADD EDX, 12												;adds 12 the the current hour to symbolize 12 AM
			INVOKE intasc32, ADDR strTempString, EDX				;comverts the hour into the ascii characters
			INVOKE appendString, lpTimeString, addr strTempString	;appends to the end of the current time string what is in temp string 
			INVOKE appendString, lpTimeString, addr strCol			;appends a : at the end of the current time string
			MOV bAM, 1												;set the bAM variable to 1, so later we can display the AM message
			JMP Minute												;jump to the minute section
			
		PMConvert:
			SUB EDX, 12												;subtracts 12 from the current hour to convert it for displaying
			INVOKE intasc32, ADDR strTempString, EDX				;converts the hour to the current ascii characters
			INVOKE appendString, lpTimeString, addr strTempString	;appends to the end of the current time string what is in temp string 
			INVOKE appendString, lpTimeString, addr strCol			;appends a : at the end of the current time string
			MOV bAM, 0												;set the BAM byte to 1, to signify that its PM 
			JMP Minute												;jump to the minute section 
			
		Minute:
			MOVSX EDX, word ptr [EBX].wMinute						;moves the current minute into edx
			CMP EDX, 10												;compares the current minute to see if it is less than 10
			JL formatMin											;if it is less than 10 then we need to format it to 2 digits so jump to the section
			INVOKE intasc32, ADDR strTempString, EDX				;if it is not, convert the current minute into ascii characters 
			INVOKE appendString, lpTimeString, addr strTempString	;appends to the end of the current time string what is in temp string 
			INVOKE appendString, lpTimeString, addr strCol			;appends a : at the end of the current time string
			JMP Second												;jump to the seconds section
		
		formatMin:
			INVOKE intasc32, ADDR strTempString, 0					;append a 0 at the end of the current string for formattiong
			INVOKE appendString, lpTimeString, addr strTempString	;appends to the end of the current time string what is in temp string 
			INVOKE intasc32, ADDR strTempString, EDX				;convert the minute into the ascii characters
			INVOKE appendString, lpTimeString, addr strTempString	;appends to the end of the current time string what is in temp string 
			INVOKE appendString, lpTimeString, addr strCol			;appends a : at the end of the current time string
			JMP Second												;jump to the seconds section
		
		Second:
			MOVSX EDX, word ptr [EBX].wSecond						;moves the current second into EDX
			CMP EDX, 10												;compares the seconds to see if it is less than 10
			JL formatSec											;if it is less than then we need to format it
			INVOKE intasc32, ADDR strTempString, EDX				;if it is not, convert the seconds into the ascii characters
			INVOKE appendString, lpTimeString, addr strTempString	;appends to the end of the current time string what is in temp string 
			INVOKE appendString, lpTimeString, addr strCol			;appends a : at the end of the current time string
			JMP Millisecs											;jump to the milliseconds section
		
		formatSec:
			INVOKE intasc32, ADDR strTempString, 0					;append a 0 at the end of the current string for formattiong
			INVOKE appendString, lpTimeString, addr strTempString	;appends to the end of the current time string what is in temp string 
			INVOKE intasc32, ADDR strTempString, EDX				;convert the minute into the ascii characters
			INVOKE appendString, lpTimeString, addr strTempString	;appends to the end of the current time string what is in temp string 
			INVOKE appendString, lpTimeString, addr strCol			;appends a : at the end of the current time string
			JMP Millisecs											;jump to the milliseconds section
		
		Millisecs:
			MOVSX EDX, word ptr [EBX].wMillisecs					;moves the current millisecond into EDX
			CMP EDX, 100											;compares it to see if it is less than 100
			JL formatMill											;if it is, then we need to format it
			INVOKE intasc32, ADDR strTempString, EDX				;if not, then convert the current millisecond into ascii characters. 
			INVOKE appendString, lpTimeString, addr strTempString	;appends to the end of the current time string what is in temp string 
			JMP endofTime											;jump to the end of time section
			
		formatMill:	
			INVOKE intasc32, ADDR strTempString, 0					;append a 0 at the end of the current string for formattiong
			INVOKE appendString, lpTimeString, addr strTempString	;appends to the end of the current time string what is in temp string 
			INVOKE intasc32, ADDR strTempString, EDX				;convert the minute into the ascii characters
			INVOKE appendString, lpTimeString, addr strTempString	;appends to the end of the current time string what is in temp string 
			JMP endofTime											;jump to the end of time section
			
		endofTime:
			CMP bAM, 1												;compares to see if the bAM byte is 1
			JE itsAM												;if it is 1, then it is AM
			INVOKE appendString, lpTimeString, addr strPM			;if not, then it is PM call appendstring and add PM at the end of the current string 
			JMP done												;jump to done. 
			
			itsAM:
				INVOKE appendString, lpTimeString, addr strAM		;call appendstring and add AM at the end of the current string 
				JMP done											;jump to done
				
			done:
			ASSUME EBX: ptr nothing									;now that we are done we dont have to assume ebx is a time anymore
			MOV EAX, lpTimeString									;moves into eax the address of the time string for returning	
			RET														;return to where i was called. 
getsTime	endp


COMMENT%
******************************************************************************
*Name: appendString                                                          *
*Purpose:                                                                    *
*	  This method copies the null-terminated string starting at the address  *
*  indicated by the source parameter into the string starting at the address *
*  indicated by the destination. The destination string will be null-terminated*
*  after appending.                                                          *
*Date Created: 10/31/2019                                                    *
*Date Modified: 11/02/2019                                                   *
*                                                                            *
*                                                                            *
*@param lpDestination:dword                                                  *
*@param lpDSource:dword	                                                     *
*****************************************************************************%
appendString PROC Near32 stdcall uses EDX ECX EDI EBX, lpDestination:dword, lpSource:dword
	LOCAL numBytesToCopy:dword
	
	MOV EDX, lpSource				;moves the source address into EDX so we can get the number of current bytes
	getBytes EDX					;call the getbytes macro so we get the current number of bytes. 
	MOV numBytesToCopy, EAX			;stores this into a local variable
	MOV EAX, lpDestination			;moves into EAX, the destination address
	getBytes EAX					;gets the number of bytes of the destination address
	MOV EDI, EAX					;stores the number of bytes in the output into EDI
	DEC EDI							;decrements edi so we ignore the null character the getBytes counts for
	MOV EBX, lpDestination			;moves the address of the output into ebx
	MOV ECX, numBytesToCopy			;moves the number of bytes to copy into ecx so we can loop
	ADD EBX, EDI 					;adds EDI to the initial address so we get the starting address were going to paste to
	
	lpCopyString:
		MOV EAX, [EDX]				;moves the current value at address edx into eax
		MOV [EBX], AL				;moves into the current address of ebx the value in AL
		INC EBX						;increments to the next position in the destination
		INC EDX						;increments to the next position in the source
	loop lpCopyString				;decrement ecx, and jump back to the top
	RET								;return back to where I was called from. 
appendString endp 

END