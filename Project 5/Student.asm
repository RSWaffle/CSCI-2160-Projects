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