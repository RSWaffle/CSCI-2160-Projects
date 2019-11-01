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

	intasc32 			PROTO Near32 stdcall, lpStringToHold:dword, dval:dword
	intasc32Comma 		PROTO Near32 stdcall, lpStringToHold:dword, dval:dword
	GetLocalTime		PROTO Near32 stdcall, lpSystemTime:PTR SYSTEMTIME
	getsTime			PROTO Near32 stdcall, lpStringOfSysTime:dword,lpStringTime:dword
	getTime				PROTO Near32 stdcall   ;returns address of time string
	appendString		PROTO Near32 stdcall, lpDestination:dword, lpSource:dword
	
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

	.data
sysTime 	SYSTEMTIME			<>  ;SYSTEM TIME variable with attributes of the time 
strTimeString  byte 200 dup(?)      ;contains the address of the dynamic time string
strTempString byte 100 dup(?)	    ;temp string that will be manipulated for output to time string
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

	.code
getTime	proc Near32 stdcall
	INVOKE GetLocalTime, ADDR sysTime				   ;calls the get local time method and it returns the local time from the PC 
	INVOKE getsTime, addr sysTime, addr strTimeString  ;returns a displayable string with the date and time
getTime	endp	
	
getsTime proc  Near32 stdcall, lpSystemTime:dword, lpTimeString:dword
	LOCAL outputAddress:dword					;initializes the method with a output address local variable initialized
	MOV EBX, lpSystemTime						;move the input values into the local values so i dont get confused

	MOV EAX, lpTimeString						;moves the address of the string where the time will be displayed into eax
	MOV outputAddress, EAX						;moves the address in eax into the output address
	MOV EDX, outputAddress						;moves the output address into edx

	ASSUME EBX:ptr SYSTEMTIME					;assume that ebx is a systemtime so we can reference it easier
	MOVSX EAX, word ptr [EBX].wMonth			;moves the month number into eax so we can compare it to the correct month
	
	CMP EAX, 1									;compares the month number to 1
	JE January									;if it is 1 then jump to the january section
	CMP EAX, 2									;compares the month number to 2
	JE February									;if it is the month number then jump to the appropriate section
	CMP EAX, 3									;compares the month number to 3
	JE March									;if it is the month number then jump to the appropriate section
	CMP EAX, 4									;compares the month number to 4
	JE April									;if it is the month number then jump to the appropriate section
	CMP EAX, 5									;compares the month number to 5
	JE May										;if it is the month number then jump to the appropriate section
	CMP EAX, 6									;compares the month number to 6
	JE June										;if it is the month number then jump to the appropriate section
	CMP EAX, 7									;compares the month number to 7
	JE July										;if it is the month number then jump to the appropriate section
	CMP EAX, 8									;compares the month number to 8
	JE August									;if it is the month number then jump to the appropriate section
	CMP EAX, 9									;compares the month number to 9
	JE September								;if it is the month number then jump to the appropriate section
	CMP EAX, 10									;compares the month number to 10
	JE October									;if it is the month number then jump to the appropriate section
	CMP EAX, 11									;compares the month number to 11
	JE November									;if it is the month number then jump to the appropriate section
	CMP EAX, 12									;compares the month number to 12
	JE December									;if it is the month number then jump to the appropriate section
	
	January:
		;INVOKE appendString, lpTimeString, addr strNovember
		JMP InsertRest
	February:
		;INVOKE appendString, lpTimeString, addr strNovember
		JMP InsertRest
	March:
		;INVOKE appendString, lpTimeString, addr strNovember
		JMP InsertRest
	April:
		;INVOKE appendString, lpTimeString, addr strNovember
		JMP InsertRest
	May:
		;INVOKE appendString, lpTimeString, addr strNovember
		JMP InsertRest
	June:
		;INVOKE appendString, lpTimeString, addr strNovember
		JMP InsertRest
	July:
		;INVOKE appendString, lpTimeString, addr strNovember
		JMP InsertRest
	August:
		;INVOKE appendString, lpTimeString, addr strNovember
		JMP InsertRest
	September:
		;INVOKE appendString, lpTimeString, addr strNovember
		JMP InsertRest		
	October:
		;INVOKE appendString, lpTimeString, addr strOctober
		JMP InsertRest
	November:
		;INVOKE appendString, lpTimeString, addr strNovember
		JMP InsertRest
	December:
		;INVOKE appendString, lpTimeString, addr strNovember
		JMP InsertRest
		
	InsertRest:
		INVOKE intasc32Comma, ADDR strTempString, [EBX].wDay
		;INVOKE appendString, lpTimeString, addr strTempString
		MOVSX EDX, word ptr [EBX].wYear
		INVOKE intasc32, ADDR strTempString, EDX
		;INVOKE appendString, lpTimeString, addr strTempString
		;INVOKE appendString, lpTimeString, addr strAt
	
		MOVSX EDX, word ptr [EBX].wHour
		INVOKE intasc32, ADDR strTempString, EDX
		;INVOKE appendString, lpTimeString, addr strTempString
		;INVOKE appendString, lpTimeString, addr strCol
	
		MOVSX EDX, word ptr [EBX].wMinute
		INVOKE intasc32, ADDR strTempString, EDX
		;INVOKE appendString, lpTimeString, addr strTempString
		;INVOKE appendString, lpTimeString, addr strCol
	
		MOVSX EDX, word ptr [EBX].wSecond
		INVOKE intasc32, ADDR strTempString, EDX
		;INVOKE appendString, lpTimeString, addr strTempString
		;INVOKE appendString, lpTimeString, addr strCol
		
		MOVSX EDX, word ptr [EBX].wMillisecs
		INVOKE intasc32, ADDR strTempString, EDX
		;INVOKE appendString, lpTimeString, addr strTempString
			
		ASSUME EBX: ptr nothing
		MOV EAX, lpTimeString
	RET
getsTime	endp

appendString PROC Near32 stdcall, lpDestination:dword, lpSource:dword

appendString endp 

END