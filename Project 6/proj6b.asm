;******************************************************************************************
;*  Program Name: Proj6a.asm
;*  Programmer:   Ryan Shupe
;*  Class:        CSCI 2160-001
;*  Lab:		  Project 6b
;*  Date:         Created 12/07/2019
;*  Purpose:      Driver to test the methods written in convertMethods
;******************************************************************************************
	.486						;This tells assembler to generate 32-bit code
	.model flat					;This tells assembler that all addresses are real addresses
	.stack 100h					;EVERY program needs to have a stack allocated
;******************************************************************************************
	ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD  						;Executes "normal" termination
	putstring  PROTO NEAR stdcall, lpStringToDisplay:dword
	hexToCharacter PROTO stdcall, lpDestination:dword, lpSource:dword, numBytes:dword
	charTo4HexDigits PROTO stdcall, lpSourceString:dword
	encrypt32Bit PROTO stdcall, lpSourceString:dword, dMask:dword , numBytes:dword
	getstring 	PROTO stdcall, lpStringToHoldInput:dword, maxNumChars:dword ;Get input from user and convert. 
	ascint32 PROTO NEAR32 stdcall, lpStringToConvert:dword  				;This converts ASCII characters to the dword value
	heapDestroyHarrison PROTO Near32 stdcall								;Destroys the memory allocated by the allocate proc 
;******************************************************************************************
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
strProjInfo byte  10,13,9,
        "Name: Ryan Shupe",10,
"       Class: CSCI 2160-001",10,
"        Date: 12/07/2019",10,
"         Lab: Project 6b",0
strChar byte 10 dup (0)					;memory to hold a key the user types
strString byte 256 dup (0),0			;hold a string that the user types in
strHexChars byte 100 dup(0)				;holds converted string of characters
crlf byte  10,13,0						;Null-terminated string to skip to new line
hexKey DWORD ?							;converted key into a dword
numBytes dword ?						;number of bytes in the user typed string

strAsk4Key byte "Enter a 8 character encryption key: ", 0
strAskSentence byte "Type a sentence you wish to encrypt: ", 0
strNormal byte "This is the unencrypted sentence in HEX: ", 0 
strEncrypted byte "  This is the encrypted sentence in HEX: ", 0 
strAfter byte "  This is the decrypted sentence in HEX: ", 0
strTranslates byte " translates to: ", 0
;******************************************************************************************
.CODE
	XOR EAX, EAX													;aid in debugging
	
_start:
INVOKE putstring, addr strProjInfo									;display the project information
INVOKE putstring, addr crlf											;skip to a new line
INVOKE putstring, addr crlf											;skip to a new line
INVOKE putstring, addr strAskSentence								;ask the user to type in a sentence to encrypt
INVOKE getstring, addr strString, 256								;wait for input with a max of 256 characters
MOV EAX, offset strString											;move the address of the user typed string into eax to get the number of bytes
getBytes EAX														;return the number of bytes
DEC EAX																;remove null
MOV numBytes, EAX													;store the number of bytes

tryAgainBuddy:
	INVOKE putstring, addr crlf										;skip to a new line
	INVOKE putstring, addr strAsk4Key								;ask the user to enter a key
	INVOKE getstring, addr strChar, 8								;get the 8 character key
	INVOKE charTo4HexDigits, addr strChar							;convert into the 4 byte dword the user typed key
.IF EAX == -1														;if eax returns a -1
	JMP tryAgainBuddy												;if the key is invalid then jump back up
.ENDIF																;endif

MOV hexKey, EAX														;store the user entered key

INVOKE putstring, addr crlf											;skip to a new line
INVOKE putstring, addr crlf											;skip to a new line
INVOKE putstring, addr strNormal									;display that this is the normal string
INVOKE hexToCharacter, addr strHexChars, addr strString, numBytes	;convert into hex characters ascii format
INVOKE putstring, addr strHexChars									;display the ascii hex chars
INVOKE putstring, addr crlf											;skip to a new line

INVOKE putstring, addr strEncrypted									;display that this is the encrypted string
INVOKE encrypt32Bit, addr strString, hexKey, numBytes				;call the encryption method
MOV EBX, EAX														;keep this for later because eax is going to be overridden
INVOKE hexToCharacter, addr strHexChars, EAX, numBytes				;convert the encryped hex values to the appropriate ascii 
INVOKE putstring, addr strHexChars									;display the encrypted string

INVOKE putstring, addr crlf											;skip to a new line
INVOKE putstring, addr strAfter										;display that this is the string after passing through the method again
INVOKE encrypt32Bit, EBX, hexKey, numBytes							;call the encryption method to decrypt the message
INVOKE hexToCharacter, addr strHexChars, EAX, numBytes				;convert the hex to appropriate ascii
INVOKE putstring, addr strHexChars									;display the converted back string 

XOR EAX, EAX														;aid in debugging

;************************************* the instructions below calls for "normal termination"
INVOKE heapDestroyHarrison											;clears the memory used by heap allocharrion	
INVOKE ExitProcess,0						 
PUBLIC _start
END