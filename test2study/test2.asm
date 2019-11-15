	.486				;tells assembler to generate 32-bit code
	.model flat			;tells assembler that all addresses are real addresses
	.stack 100h			;EVERY program needs to have a stack allocated

	ExitProcess PROTO Near32 stdcall, dwExitCode:DWORD
	
.data
	sX word 22h, 0FFE4h
	bVal byte 27h, 0FEh
	dVal dword 37h, 42h
	qVal qword 1234a678h
.code
_start:
	
	MOV EAX, 0
	
	MOV DX, 55h
	MOV AL, 1Ch
	CBW
	MOV BL, 07h
	IDIV BL
	MOV ECX, 0
	
	INVOKE ExitProcess, 0	;normal termination
	PUBLIC _start
	END
	