; bcd-addition.asm
; CSC 230: Fall 2022
;
; Code provided for Assignment #1
;
; Mike Zastre (2022-Sept-22)

; This skeleton of an assembly-language program is provided to help you
; begin with the programming task for A#1, part (c). In this and other
; files provided through the semester, you will see lines of code
; indicating "DO NOT TOUCH" sections. You are *not* to modify the
; lines within these sections. The only exceptions are for specific
; changes announced on conneX or in written permission from the course
; instructor. *** Unapproved changes could result in incorrect code
; execution during assignment evaluation, along with an assignment grade
; of zero. ****
;
; In a more positive vein, you are expected to place your code with the
; area marked "STUDENT CODE" sections.

; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
; Your task: Two packed-BCD numbers are provided in R16
; and R17. You are to add the two numbers together, such
; the the rightmost two BCD "digits" are stored in R25
; while the carry value (0 or 1) is stored R24.
;
; For example, we know that 94 + 9 equals 103. If
; the digits are encoded as BCD, we would have
;   *  0x94 in R16
;   *  0x09 in R17
; with the result of the addition being:
;   * 0x03 in R25
;   * 0x01 in R24
;
; Similarly, we know than 35 + 49 equals 84. If 
; the digits are encoded as BCD, we would have
;   * 0x35 in R16
;   * 0x49 in R17
; with the result of the addition being:
;   * 0x84 in R25
;   * 0x00 in R24
;

; ANY SIGNIFICANT IDEAS YOU FIND ON THE WEB THAT HAVE HELPED
; YOU DEVELOP YOUR SOLUTION MUST BE CITED AS A COMMENT (THAT
; IS, WHAT THE IDEA IS, PLUS THE URL).



    .cseg
    .org 0

	; Some test cases below for you to try. And as usual
	; your solution is expected to work with values other
	; than those provided here.
	;
	; Your code will always be tested with legal BCD
	; values in r16 and r17 (i.e. no need for error checking).

	; 94 + 9 = 03, carry = 1
	;ldi r16, 0x94
	;ldi r17, 0x09

	; 86 + 79 = 65, carry = 1
	;ldi r16, 0x86
	;ldi r17, 0x79

	; 35 + 49 = 84, carry = 0
	;ldi r16, 0x35
	;ldi r17, 0x49

	; 32 + 41 = 73, carry = 0
	ldi r16, 0x32
	ldi r17, 0x41

; ==== END OF "DO NOT TOUCH" SECTION ==========

; **** BEGINNING OF "STUDENT CODE" SECTION **** 

; Assigns value of R16 to R18, and R17 to R19
MOV r18, r16
MOV r19, r17

; Adds R19 and R18 into R19
ADC r19, r18

;Copies R19 byte into R21, R22
MOV r21, r19
MOV r22, r19

; Creates a mask to isolate the lower nibble of R19 
ANDI r21, 0x0F

; Makes sure that the lower nibble of R19 is less than the value of 10. If it is more than 9,  then branches to ADD_LOWER_SIX
CPI r21, 0x0A
BRGE ADD_LOWER_SIX

HERE:
; Loops R22 which contains R19 4 times. It shifts R22 to the right. It makes it so that the upper nibble becomes a lower nibble in R22.
LDI r23, 0x04

LOOP:
	LSR r22
	DEC r23
	BRNE LOOP

;Compares R22, and makes sure it is not more than 9. If it is more than 9, it will branch to ADD_UPPER_SIX
CPI r22, 0x0A
BRGE ADD_UPPER_SIX 

HERE2:
;Copies current contents of R19 to R21
MOV r21, r19

;Loops R21 four times and shifts it to the right. 
LDI r23, 0x04
LOOP4:
	LSR r21
	DEC r23
	BRNE LOOP4

; Checks that the upper nibble is still less than 10. Otherwise, it will branch to SHIFT_FORWARD_BACK
CPI R21, 0x0A
BRGE SHIFT_FORWARD_BACK

HERE3:
;Copies contents of R19 to R25 as the final result
MOV r25, r19
JMP END

; This branch makes sure that if the result is still more than 10 for the upper nibble after upper and lower nibble calculations, then make 
; the upper nibble be equal to 0. It performs two loops which shift it left four times, then right four times.
; The branch also adds the value 1 to R24 to represent the carry flag value.
SHIFT_FORWARD_BACK:
	LDI r24, 0x01
	LDI r23, 0x04
	LOOP2:
		LSL r19
		DEC r23
		BRNE LOOP2
	LDI R23, 0x04
	LOOP3:
		LSR r19
		DEC r23
		BRNE LOOP3
	JMP HERE3

; This branch adds 6 to R19 since the lower nibble exceeds the value 9.
ADD_LOWER_SIX:
	LDI r20, 0x06
	ADD r19, r20
	JMP HERE 

; This branch adds 6 to the R19, since the upper nibble exceeds the value 9. It will also add the value 1 to R24 which
; represents the carry flag value.
ADD_UPPER_SIX:
	LDI r20, 0x60
	ADD r19, r20
	LDI r24, 0x01
	JMP HERE2

END:

; **** END OF "STUDENT CODE" SECTION ********** 

; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
bcd_addition_end:
	rjmp bcd_addition_end



; ==== END OF "DO NOT TOUCH" SECTION ==========
