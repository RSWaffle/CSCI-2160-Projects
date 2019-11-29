;******************************************************************************************
;*  Program Name: convertMethods.asm
;*  Programmer:   Ryan Shupe
;*  Class:        CSCI 2160-001
;*  Lab:		  Project 6b
;*  Date:         Created 12/07/2019
;*  Purpose:      Methods to convert ascii characters to hex characters and vise versa, with encryption
;******************************************************************************************
	.486						;This tells assembler to generate 32-bit code
	.model flat					;This tells assembler that all addresses are real addresses
	.stack 100h					;EVERY program needs to have a stack allocated
;******************************************************************************************
	ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD  						;Executes "normal" termination
;******************************************************************************************
.DATA
;******************************************************************************************
.CODE


;************************************* the instructions below calls for "normal termination"	

END