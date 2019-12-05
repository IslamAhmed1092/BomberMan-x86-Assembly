        EXTRN drawBomb:FAR
        EXTRN drawBonus1:FAR
        EXTRN drawBonus2:FAR
        EXTRN DrawPlayer1:FAR
        EXTRN DrawPlayer2:FAR
        EXTRN DrawWalls:FAR
        EXTRN moveMan:FAR
        EXTRN WelcomeStart:FAR
		EXTRN USNAME:BYTE

                   .MODEL compact                  
;------------------------------------------------------
                    .STACK         
;------------------------------------------------------                    
                    .DATA
;--------------------------------------------------------
                    .CODE                                                 
MAIN                PROC FAR
                    MOV AX,@DATA
                    MOV DS,AX
                    
					call WelcomeStart
					
					call initProg
					CALL DrawWalls
                    CALL DrawPlayer1
                    CALL DrawPlayer2 

                check:
                    mov ah,0
                    int 16h
                    CALL moveMan
                    JMP check

                    MOV AH,4CH 
                    INT 21H 

MAIN                ENDP


initProg proc
                    mov ax,0600h
                    mov bh,07h
                    mov cx,0
                    mov dx,184FH
                    int 10h
                    
                    mov ah,0
                    mov al,13h
                    int 10h


ret
initProg endp
                    END MAIN