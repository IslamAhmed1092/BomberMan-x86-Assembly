        EXTRN drawBomb:FAR
        EXTRN drawBonus1:FAR
        EXTRN drawBonus2:FAR
		EXTRN drawBonus3:FAR
        EXTRN DrawPlayer1:FAR
        EXTRN DrawPlayer2:FAR
        EXTRN DrawWalls:FAR
        EXTRN keyPressed:FAR
        EXTRN WelcomeStart:FAR
        
		ExtrN InGameChat:FAR
		;following 4 functions, call them after updating any score or bonus
		EXTRN drawp2sc:near        ;if you update lifes for player2
		EXTRN drawp2sc2:near       ;if you update bombs for player2
		EXTRN drawp1sc2:near       ;if you update bombs for player1
		EXTRN drawp1sc:near        ;if you update lifes for player1
		
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
                    CALL InGameChat
                check:
                    mov ah,1
                    int 16h
                    jZ check
                    CALL keyPressed
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