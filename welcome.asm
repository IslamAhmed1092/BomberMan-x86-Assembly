
public WelcomeStart, USNAME


.Model compact
.STACK 64
.DATA
mess1 db 'Welcome To The Game', '$'
mess2 db 'Please Enter Your Name:', '$'
mess3 db 'Press Enter to Continue', '$'
chmes db '*To statrt chatting press F1', '$'
plmes db '*To start a game press F2', '$'
exmes db '*To end the program press ESC', '$'


USNAME  db 30, ?
.CODE
WelcomeStart	PROC FAR

		CALL cleanPage
		CALL PAGE1
		CALL cleanPage          ;clearing the page
		CALL PAGE2	
		
WelcomeStart	ENDP


cleanPage	PROC 
		MOV AX, 0600H
		MOV BH, 07
		MOV CX, 0000
		MOV DX, 184FH	;cleaning the page
		INT 10H
		RET
cleanPage	ENDP

;--------------------------------------------------

printchar	proc 
		
		MOV AH, 9
		MOV BH, 0	
					;move the ascii of the character to al before calling the function
					;move the number of printing times to  cx
		mov BL, 00fh
		INT 10H
		RET
		
printchar endp

;-----------------------------------------------------
printstr	proc 
		
		MOV AH, 9
		INT 21H		;MOV DX, OFFSET MESSEGE BEFORE CALLING
		RET
		
printstr	endp 
;----------------------------------------------------

movcrsr proc 
		
		MOV AH, 2
		MOV BH, 00
		INT 10H		;MOV DX, yx BEFORE CALLING
		RET
		
movcrsr endp

;-----------------------------------------------------
PAGE1	PROC 
		
		MOV DX, 0A19H
		CALL movcrsr              ;moving cursor to the middle of the page
		
		MOV DX, OFFSET mess1
		CALL printstr            ;diplaying messege1
		
		
		MOV DX, 0B19H
		CALL movcrsr            ;moving cursor to the middle of the page
		
		MOV DX, OFFSET mess2
		CALL printstr             ;diplaying messege2
		
		
		MOV DX, 0C19H
		CALL movcrsr		;moving cursor
		
		
		MOV DX, OFFSET USNAME  
		MOV AH, 0AH           ;reading username
		INT 21H   
		
		MOV DX, 0D19H
		CALL movcrsr           ;movig cursor to the middle of the page
		
		MOV DX, OFFSET mess3
		CALL printstr            ;displaying messege3
		
LOP:	MOV AH, 0
		INT 16H  
		CMP AH, 1CH
		JNE LOP         ;waiting for enter
		ret
PAGE1	ENDP

;-------------------------------------

PAGE2	PROC 
		
		MOV DX, 071AH
		CALL movcrsr          ;moving cursor
		
		MOV DX, OFFSET chmes
		CALL printstr           ;Printing chat mode messege
	
		MOV DX, 091AH       ;moving cursor
		CALL movcrsr 
		
		MOV DX, OFFSET plmes
		CALL printstr          ;printing playing mode messege
		
		MOV DX, 0B1AH         ;moving cursor
		CALL movcrsr
		
		MOV DX, OFFSET exmes
		CALL printstr          ;printing exiting messege                 
		        
		
		MOV DX, 1500H         ;moving cursor
		CALL movcrsr  
	
        MOV AL, 2DH
        MOV CX, 50H  
		call printchar  ;printing dashes	

check:  mov ah, 1
		int 16h			;READING KEY PRESSED
		jz check
		
		CMP AH, 3BH		;if F1
		JNE TXT	
		CALL cleanPage
		
						;playing code
						
						
txt:    CMP AH, 3CH		;if f2
		JNE EXIT
		RET
						;chatting code
		
EXIT:	CMP AH, 1
		JNE CHECK
						
		mov ah,4ch
		int 21h
		
PAGE2	ENDP    
end