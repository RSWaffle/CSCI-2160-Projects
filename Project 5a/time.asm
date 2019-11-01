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

	ASSUME EBX:ptr SYSTEMTIME
	MOVSX EAX, word ptr [EBX].wMonth
	
	CMP EAX, 1
	;JE January
	CMP EAX, 2
	;JE February
	CMP EAX, 3
	;JE March
	CMP EAX, 4
	;JE April
	CMP EAX, 5
	;JE May
	CMP EAX, 6
	;JE June
	CMP EAX, 7
	;JE July	
	CMP EAX, 8
	;JE August	
	CMP EAX, 9
	;JE September	
	CMP EAX, 10
	JE October
	CMP EAX, 11
	;JE November
	CMP EAX, 12
	;JE December
		
	October:
		;INVOKE appendString, lpTimeString, addr strOctober
		JMP InsertRest
	November:
		;INVOKE appendString, lpTimeString, addr strOctober
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