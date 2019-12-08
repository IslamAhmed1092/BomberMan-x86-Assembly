extrn NamePlayer2:byte

public WelcomeStart, USNAME,LenUSNAME,P1Name,PAGE2

.Model compact
.STACK 64
.DATA
mess1 db 'Welcome To The Game', '$'
mess2 db 'Please Enter Your Name:', '$'
mess3 db 'Press Enter to Continue', '$'
chmes db '*To statrt chatting press F1', '$'
plmes db '*To start a game press F2', '$'
exmes db '*To end the program press ESC', '$'
outOfChat db 'Press F3 to end chatting with ','$'


USNAME  db 20
LenUSNAME db ?
P1Name db 20 dup('$')

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
		
noname:	MOV DX, 0A19H
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
		
		mov cl, LenUSNAME
		cmp cl, 0
		je noname	

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

check:  mov ah, 0
		int 16h			;READING KEY PRESSED
		
		
		CMP AH, 3BH		;if F1
		JNE TXT	
		CALL ChatPage
		
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

;------------------------------ This is chat page procedure

ChatPage proc

call cleanPage
;move curser to start of screen
mov dx,0
call movcrsr

;print player1
mov di,offset P1Name
mov ch,0
mov cl,LenUSNAME
mov ah,2
WriteN1:
mov dl,[di]
int 21h
inc di
dec cx
jnz WriteN1


;print colon
mov ah,2
mov dl,58  ;colon
int 21h


;mov curser to middle of screen
mov ah,2
mov bh,0
mov dh,12
mov dl,0
int 10h
;display dash horizontally to split page
mov ah,2
mov dl,95     ;Dash
mov cx,0
dashSplit:
int 21h
inc cx
cmp cx,80
jnz dashSplit

;player 2 name
mov dx,offset NamePlayer2
mov ah,9
int 21h
;print colon
mov ah,2
mov dl,58  ;colon
int 21h

;mov curser to nearly end of screen
mov ah,2
mov bh,0
mov dh,23
mov dl,0
int 10h
;display dash horizontally to split page
mov ah,2
mov dl,95     ;Dash
mov cx,0
dashSplit2:
int 21h
inc cx
cmp cx,80
jnz dashSplit2

mov dx,offset outOfChat
mov ah,9
int 21h
mov dx,offset NamePlayer2
mov ah,9
int 21h

;move curser to start of screen
mov ah,2
mov bh,0
mov dh,0
mov dl,LenUSNAME
add dl,2
int 10h

checkOFEnd:  
        mov ah,0
		int 16h			;READING KEY PRESSED
		CMP AH, 3DH		;if F3
		jz Endthischat
		mov ah,2
		mov dl,al
		int 21h
		jmp checkOFEnd
		
		Endthischat:
		call cleanPage
        call PAGE2
ret
ChatPage endp
end