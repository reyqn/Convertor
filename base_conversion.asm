Progr           segment
                assume  cs:Progr, ds:dane, ss:stosik

start:          mov     ax,	dane
                mov     ds, ax
                mov     ax, stosik
                mov     ss, ax
                mov     sp, offset szczyt

      		dispChoice:
                mov 	dx, offset choice
                mov 	ah, 09h
                int 	21h
                mov 	ah, 01h
                int 	21h
                cmp 	al, '1'
                je 		convertNine
                cmp 	al, '2'
                je 		convertSeven
                cmp 	al, '3'
                je 		exit
                jmp 	dispChoice

            convertNine:
				mov 	baseTo, 9
				mov 	baseFrom, 7
                call 	conversion
                jmp 	dispChoice

            convertSeven:
				mov 	baseTo,	7
				mov 	baseFrom, 9
                call 	conversion
                jmp 	dispChoice

		conversion proc
                mov 	dx, offset number
                mov 	ah, 09h
                int 	21h
                mov 	ax, 0
                push 	ax		; push 0 for first iteration
		
            getDigit: 			; Gets number and converts it to base 10
                mov 	ah, 01h
                int 	21h
                cmp 	al, 0dh	; if enter pressed
                je 		startDiv
                mov 	ah, 0	; clear accumulator
                sub 	al, 30h	; ascii to int
                mov 	cx, ax
                pop 	ax					
                mov 	bx, baseFrom
                mul 	bx
                add 	ax, cx
                push 	ax		; stack = baseFrom * stack + digit
                jmp 	getDigit

            startDiv:
                mov 	cx, 0
                mov 	bx, baseTo
                pop 	ax

            division:			; Converts number from base 10
                div 	bx
                push 	dx		; remainder
                add 	cx, 1	; counter
                mov 	dx, 0
                cmp 	ax, 0	; quotient
                jne 	division

            print:				; Prints number
                mov 	dx, 0
                pop 	dx
                add 	dl, 30h ; int to ascii
                mov 	ah, 02h
                int 	21h
                loop 	print	; decrease counter
                ret

        conversion endp

			exit:
				mov 	al, 0
				mov 	ah, 4ch
				int 	21h

Progr			ends

dane            segment
				choice		db	10, 13, '1. Base 7 to base 9'
							db  10, 13, '2. Base 9 to base 7'
							db  10, 13, '3. Leave', 10, 13, '$'
				number    	db	10, 13, 'Choose a number to convert ', 10, 13, '$'
				baseTo		dw 	?
				baseFrom	dw 	?
dane            ends

stosik          segment
				dw    100h dup(0)
szczyt          Label word
stosik          ends

end start
