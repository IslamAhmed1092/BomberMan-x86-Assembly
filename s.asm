public chatfunction
.model small
.stack 64
.data

;to store input letter 
chrSend db ?
chrRecv db ?

;to store last curser position for send char
sendCurserXi EQU 0
sendCurserYi EQU 0
sendCurserMaxX EQU 79
sendCurserMaxY	EQU 11
sendCurserX db sendCurserXi
sendCurserY db sendCurserYi
;to store last curser position for received char

RecvCurserXi EQU 0
RecvCurserYi EQU 13
RecvCurserMaxX EQU 79
RecvCurserMaxY EQU 24
RecvCurserX db RecvCurserXi
RecvCurserY db RecvCurserYi

EscCode		  EQU 27
EnterCode     EQU 13
BackSpaceCode EQU 08

.code
chatfunction proc far
mov AX,@DATA
MOV DS,AX

CALL InitializePort
call Scrlmid
CALL Scrl1
CALL Scrl2
CALL SetCurser0

;loop to read char
MainLoop:
mov ah,1
int 16h
JNZ  Send
CheckRecv:
mov dx , 3FDH ; Line Status Register
in al , dx
test al , 1
JZ MainLoop ;Not Ready
;If Ready read the VALUE in Receive data register
mov dx , 03F8H
in al , dx
mov chrRecv , al
call PrintRecv
;if not entered any char >> check receiving 
JMP MainLoop 
Send:
MOV chrSend, AL
mov ah,0
int 16h
mov dx , 3FDH ; Line Status Register
In al , dx ;Read Line Status
test al , 00100000b
JZ MainLoop ;Not empty
;If empty put the VALUE in Transmit data register
mov dx , 3F8H ; Transmit data register
mov al,chrSend
out dx , al
call PrintSend
jmp MainLoop
  
chatfunction endp
 

;-----------------------------------------------------------------------------
InitializePort      PROC    NEAR
                    
                    mov dx,3fbh 			; Line Control Register
                    mov al,10000000b		;Set Divisor Latch Access Bit
                    out dx,al	
                     
                    mov dx,3f8h			
                    mov al,0ch			
                    out dx,al
                    
                    mov dx,3f9h
                    mov al,00h
                    out dx,al

                    mov dx,3fbh
                    mov al,00011011b
                    out dx,al
                    
                    RET
InitializePort      ENDP

;----------------------------------------------
Scr1LineSend               PROC  
    ;scroll first half
    MOV AX,0601H    ;06 TO SCROLL & 00 FOR FULLJ SCREEN
    MOV BH,71H    ;ATTRIBUTE 7(grey) FOR BACKGROUND AND 1(blue) FOR FOREGROUND
    MOV CL,0    ;STARTING COORDINATES
	MOV CH,0
    MOV Dl,sendCurserMaxX       ;ENDING COORDINATES
    MOV DH,sendCurserMaxY
	
    INT 10H        ;FOR VIDEO DISPLAY
	
	;curser initial position
	mov sendCurserX,sendCurserXi
	mov sendCurserY,sendCurserMaxY
ret
Scr1LineSend               ENDP

;-----------------------------------------------------

Scr1LineRecv               PROC  
    ;scroll first half
    MOV AX,0601H    ;06 TO SCROLL & 00 FOR FULLJ SCREEN
    MOV BH,1FH    ;ATTRIBUTE 4(red) FOR BACKGROUND AND F(white) FOR FOREGROUND
    MOV CL,0    ;STARTING COORDINATES
	MOV CH,13
    MOV Dl,recvCurserMaxX       ;ENDING COORDINATES
    MOV DH,recvCurserMaxY
	
    INT 10H        ;FOR VIDEO DISPLAY
	
	;curser initial position
	mov recvCurserX,recvCurserXi
	mov recvCurserY,recvCurserMaxY
ret
Scr1LineRecv               ENDP

;-----------------------------------------------------



;scroll screen for first half
Scrl1               PROC  
    ;scroll first half
    MOV AX,0600H    ;06 TO SCROLL & 00 FOR FULLJ SCREEN
    MOV BH,71H    ;ATTRIBUTE 7(grey) FOR BACKGROUND AND 1(blue) FOR FOREGROUND
    MOV CL,sendCurserXi    ;STARTING COORDINATES
	MOV CH, sendCurserYi
    MOV Dl,sendCurserMaxX       ;ENDING COORDINATES
    MOV DH,sendCurserMaxY
	
    INT 10H        ;FOR VIDEO DISPLAY
	
	;curser initial position
	mov sendCurserX,sendCurserXi
	mov sendCurserY,sendCurserYi
ret
Scrl1               ENDP
;-----------------------------------------------
;scroll between 2 boxes
Scrlmid               PROC  
    ;scroll first half
    MOV AX,0600H    ;06 TO SCROLL & 00 FOR FULLJ SCREEN
    MOV BH,0A0H    ;ATTRIBUTE A(green)
    MOV CL,0    ;STARTING COORDINATES
	MOV CH,sendCurserMaxY
    MOV Dl,sendCurserMaxX       ;ENDING COORDINATES
    MOV DH,sendCurserMaxY+1
	
    INT 10H        ;FOR VIDEO DISPLAY
	ret
Scrlmid               ENDP

;--------------------------------------------
;scroll screen for first half
Scrl2               PROC
    ;scroll second half
    MOV AX,0600H    ;06 TO SCROLL & 00 FOR FULLJ SCREEN
	MOV BH,1FH    ;ATTRIBUTE 4(red) FOR BACKGROUND AND F(white) FOR FOREGROUND
	MOV CL,0    ;STARTING COORDINATES
	MOV CH, 13
    MOV Dl,recvCurserMaxX       ;ENDING COORDINATES
    MOV DH,recvCurserMaxY	
    INT 10H        ;FOR VIDEO DISPLAY
    
	;curser initial position
	mov recvCurserX,RecvCurserXi
	mov recvCurserY,RecvCurserYi  
ret             
Scrl2               ENDP 
 
;------------------------------------------------------------------- 
 
SetCurser0         PROC  
;set curser position
mov ah,2
mov dl,SendCurserXi
mov dh,sendCurserYi
mov bh,0
int 10h
ret
SetCurser0         ENDP
;------------------------------------------------------------------- 
SetCurser013       PROC
mov ah,2
mov dl,RecvCurserXi
mov dh,RecvCurserYi
mov bh,0
int 10h
ret
SetCurser013       ENDP 
 
;-----------------------------------------------------------------
;store char in chrSend,clean keyboard buffer, print char

PrintSend       PROC 
Mov al, chrSend
cmp al,EscCode
jnz cont
call endchat 
cont:
cmp al, EnterCode
JNE notEnterS
mov sendCurserX, sendCurserXi
inc sendCurserY
mov ah,2
mov bh,0
mov dl,sendCurserX
mov dh,sendCurserY
int 10h
cmp sendCurserY, sendCurserMaxY+1
jz enterAtEnd
ret
enterAtEnd:
call Scr1LineSend
mov ah,2
mov bh,0
mov dl,sendCurserX
mov dh,sendCurserY
int 10h
jmp extproc
notEnterS:
;------------------------------------------------
Mov al, chrSend
cmp al,BackSpaceCode
jnz NotBackSpace
;check start of box
mov cl,SendCurserXi     ;min x
mov ch,sendCurserYi     ;min y
;if(x==0 && y==0) >> Return 
cmp cl,sendCurserX
jnz notstart
cmp ch,sendCurserY
jnz notstart
mov ah,2
mov bh,0
mov dl,sendCurserX
mov dh,sendCurserY
int 10h
ret
;check if pressed in start of any line
notstart:
cmp cl,sendCurserX  ;if true >> y-- , x=max
jnz normalBSpace    ;if not >> then it's normal backspace
mov dh,79
mov sendCurserX,dh
dec sendCurserY     ;then continue to print blanck in prev line 
normalBSpace:
dec sendCurserX
mov ah,2
mov bh,0
mov dl,sendCurserX
mov dh,sendCurserY
int 10h
mov dl,32
mov ah,2
int 21h
ret 
;-------------------------------------------------
;set curser position
NotBackSpace:
mov ah,2
mov bh,0
mov dl,sendCurserX
mov dh,sendCurserY
int 10h
;print char
mov dl,chrSend
mov ah,2
int 21h

;increament curser
inc sendCurserX

;check boudaries
mov cl,SendCurserMaxX   ;max x
mov ch,SendCurserMaxY   ;max y

;if(x==79 && y==12) >> scroll screen1 
cmp cl,sendCurserX
jnz check2
cmp ch,sendCurserY
jnz check2
call Scr1LineSend
mov ah,2
mov bh,0
mov dl,sendCurserX
mov dh,sendCurserY
int 10h

ret
;if(x==79) >> x=0; y++ (new line)
check2:
cmp cl,sendCurserX
jnz extproc
mov sendCurserX,SendCurserXi
inc sendCurserY 

extproc:
ret
PrintSend       ENDP
 
;--------------------------------------------------------------------
;store char in chrRecv,clean keyboard buffer, print char

PrintRecv       PROC 
Mov al, chrRecv
cmp al,EscCode
JNZ contn
call endchat
contn:
cmp al, EnterCode
JNE notEnterR
mov recvCurserX, recvCurserXi
inc recvCurserY
mov ah,2
mov bh,0
mov dl,recvCurserX
mov dh,recvCurserY
int 10h
cmp recvCurserY, recvCurserMaxY+1
jz lastLineR
ret
lastLineR:
call Scr1LineRecv
mov ah,2
mov bh,0
mov dl,recvCurserX
mov dh,recvCurserY
int 10h
ret
notEnterR:
;------------------------------------------------
Mov al, chrRecv
cmp al,BackSpaceCode
jnz NotBackSpaceR
;check start of box
mov cl,RecvCurserXi     ;min x
mov ch,RecvCurserYi     ;min y
;if(x==0 && y==0) >> Return 
cmp cl,recvCurserX
jnz notstartR
cmp ch,recvCurserY
jnz notstartR
mov ah,2
mov bh,0
mov dl,recvCurserX
mov dh,recvCurserY
int 10h
ret
;check if pressed in start of any line
notstartR:
cmp cl,recvCurserX  ;if true >> y-- , x=max
jnz normalBSpaceR    ;if not >> then it's normal backspace
mov dh,79
mov recvCurserX,dh
dec recvCurserY     ;then continue to print blanck in prev line 
normalBSpaceR:
dec recvCurserX
mov ah,2
mov bh,0
mov dl,recvCurserX
mov dh,recvCurserY
int 10h
mov dl,32
mov ah,2
int 21h
ret 
;-------------------------------------------------
;set curser position
NotBackSpaceR:
;set curser position
mov ah,2
mov bh,0
mov dl,recvCurserX
mov dh,recvCurserY
int 10h
;print char
mov dl,chrRecv
mov ah,2
int 21h

;increament curser
inc recvCurserX

;check boudaries
mov cl,RecvCurserMaxX   ;max x
mov ch,RecvCurserMaxY   ;max y

;if(x==79 && y==24) >> scroll screen2 
cmp cl,recvCurserX
jnz check22
cmp ch,recvCurserY
jnz check22
call Scr1LineRecv
mov ah,2
mov bh,0
mov dl,recvCurserX
mov dh,recvCurserY
int 10h
ret
;if(x==79) >> x=0; y++ (new line)
check22:
cmp cl,recvCurserX
jnz extproc2
mov recvCurserX,RecvCurserXi
inc recvCurserY 

extproc2:
ret
PrintRecv       ENDP
;-----------------------------------------------
;this function to end chat if user pressed esc
endchat         PROC
    ;clear whole screen
    MOV AX,0600H    ;06 TO SCROLL & 00 FOR FULLJ SCREEN
    MOV BH,07H    
    MOV CX,0000H    ;STARTING COORDINATES
    MOV DX,184fh    ;to
    INT 10H        
	;set curser to start of screen
    mov ah,2
    mov bh,0
    mov dx,0
	int 10h

;return to BIOS    
mov ax,4c00h
int 21h

ret          
endchat         endp 
 
 
 
END chatfunction