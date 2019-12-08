        public GameCycle
        EXTRN drawBonus1:FAR
        EXTRN drawBonus2:FAR
		EXTRN drawBonus3:FAR
        EXTRN DrawPlayer1:FAR
        EXTRN DrawPlayer2:FAR
        EXTRN DrawWalls:FAR
        EXTRN keyPressed:FAR
        EXTRN WelcomeStart:FAR
        EXTRN CheckBonus:FAR
		EXTRN StartTime:FAR
		EXTRN InGameChat:FAR
        EXTRN CheckBombs:near
		;following 4 functions, call them after updating any score or bonus
		EXTRN drawp2sc:near        ;if you update lifes for player2
		EXTRN drawp2sc2:near       ;if you update bombs for player2
		EXTRN drawp1sc2:near       ;if you update bombs for player1
		EXTRN drawp1sc:near        ;if you update lifes for player1
		
		EXTRN USNAME:BYTE
        EXTRN arrbonus3:WORD
        EXTRN arrbonus2:WORD
        EXTRN arrbonus1:WORD
        EXTRN numbonus:WORD
		EXTRN player1X:WORD
		EXTRN player1y:WORD
		EXTRN player2x:WORD
		EXTRN player2y:WORD

		
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
                    call GameCycle

MAIN                ENDP

GameCycle proc

					call initProg
					CALL DrawWalls
                    CALL DrawPlayer1
                    CALL DrawPlayer2 
					CALL StartTime
                    CALL InGameChat
                check:
					CALL CheckBonus
                    CALL CheckBombs
                    mov ah,1
                    int 16h
                    jZ check
                    CALL keyPressed
                    JMP check


ret
GameCycle endp

initProg proc
                    mov ax,0600h
                    mov bh,07h
                    mov cx,0
                    mov dx,184FH
                    int 10h
                    
                    mov ah,0
                    mov al,13h
                    int 10h

                    mov player1X, 0
                    mov player1Y, 0
                    mov player2X, 300
                    mov player2Y, 120

                    mov arrbonus3[0], 0
                    mov arrbonus3[2],-1
                    mov arrbonus3[4],-1

                    mov arrbonus2[0], 0
                    mov arrbonus2[2],-1
                    mov arrbonus2[4],-1

                    mov arrbonus1[0], 0
                    mov arrbonus1[2],-1
                    mov arrbonus1[4],-1

                    mov numbonus, 0


ret
initProg endp





                    END MAIN