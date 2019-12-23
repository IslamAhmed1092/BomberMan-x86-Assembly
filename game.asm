        public GameCycle, GameCycle2,Manager, SendValueThroughSerial, ReceiveValueFromSerial
        EXTRN drawBonus1:FAR
        EXTRN drawBonus2:FAR
		EXTRN drawBonus3:FAR
        EXTRN DrawPlayer1:near
        EXTRN DrawPlayer2:near
        EXTRN DrawWalls:FAR
        EXTRN keyPressed:FAR
		EXTRN keyPressed2:FAR
        EXTRN WelcomeStart:FAR
        EXTRN CheckBonus:FAR
		EXTRN StartTime:FAR
		EXTRN InGameChat:FAR
		EXTRN sendchar:FAR
		EXTRN recvchar:FAR
        EXTRN CheckBombs:near
		EXTRN getLevel:near
        EXTRN WaitForLevel: near
        EXTRN chatflag:WORD
		EXTRN gameflag:WORD
		EXTRN p1bombs:BYTE
        EXTRN p1lifes:BYTE
        EXTRN p2lifes:BYTE
        EXTRN p2bombs:BYTE

        extrn P1Name:byte
		extrn LenUSNAME:byte
        extrn Player2Name:BYTE
        extrn Player2NameLen:BYTE

        EXTRN arrbonus3:WORD
        EXTRN arrbonus2:WORD
        EXTRN arrbonus1:WORD
        EXTRN numbonus:WORD
		EXTRN player1X:WORD
		EXTRN player1y:WORD
		EXTRN player2x:WORD
		EXTRN player2y:WORD
        extrn DrawLogo:far
		
                   .MODEL compact                  
;------------------------------------------------------
                    .STACK  
;------------------------------------------------------                    
                    .DATA
Manager db ?
IsAscii db ?      ;indicator for received value
;--------------------------------------------------------
                    .CODE                                                 
MAIN                PROC FAR
                    MOV AX,@DATA
                    MOV DS,AX
                    call InitializeSerialPort
					call WelcomeStart
        

MAIN                ENDP

;this function contains all game cycle and operations with logics
GameCycle proc
                    call exchangeNames
	                mov Manager,1
                    call DrawLogo  ;first call draw logo function
                    call getLevel
					call initProg  ;then initialize the screen and scores of each player and positions
					;draw all objects in game
					CALL DrawWalls
                    CALL DrawPlayer1
                    CALL DrawPlayer2 
					;timer for bonus generation time
					CALL StartTime
					;draw chat box in game
                    CALL InGameChat
                
				;all following checks are about any taken action in game
				check:
					CALL CheckBonus
                    CALL CheckBombs
                    mov ah,1
                    int 16h
                    jnz SendInstruction
					
					jmp CheckForInstruction
			SendInstruction:
					mov ah, 0
					int 16h
					;check all 8 keys
					cmp ah, 4Bh
					jz arrow
					cmp ah, 48h
					jz arrow
					cmp ah, 4Dh
					jz arrow
					cmp ah, 50h
					jz arrow
					cmp ah, 63    ;f5 down bomb
					jz arrow
					cmp ah, 64    ;f6  up bomb
					jz arrow
					cmp ah, 65    ;f7   left bomb
					jz arrow
					cmp ah, 66    ;f8   right bomb
					jz arrow
					cmp ah, 62    ;f4   exit game
					jz arrow
					;if it's not any of 4 arrows or 4 controls >> then it's message
					mov ah, al     ;to send al as ascii code
					call ChatKeys  
					jmp continueCycle  ;then continue cycle of game 
					arrow:     ;if it's one of arrows >> then go to game controlling
					Call GameKeys
					continueCycle:
			CheckForInstruction:
					call ReceiveValueFromSerial      ;recieve scancode
					cmp al, 1                    ;if al = 1 then ther is no input
					je check
					;we now check whether the recieved key is one of the
					;scan code of our controls
					;if so, we don't call the function that displays the input on  the screen
					cmp ah, 4Bh
					jz arrow1
					cmp ah, 48h
					jz arrow1
					cmp ah, 4Dh
					jz arrow1
					cmp ah, 50h
					jz arrow1
					cmp ah, 63    ;f5 down bomb
					jz arrow1
					cmp ah, 64    ;f6  up bomb
					jz arrow1
					cmp ah, 65    ;f7   left bomb
					jz arrow1
					cmp ah, 66    ;f8   right bomb
					jz arrow1
					cmp ah, 62    ;f4   exit game
					jz arrow1
					push ax
					mov al, ah
				    call recvchar
					pop ax
					arrow1:
					call keyPressed2
                    JMP check


ret
GameCycle endp
;------------------------------------------------------------------------
;Called for player 2
GameCycle2 proc
call exchangeNames2
	            mov Manager,0
                    call DrawLogo  ;first call draw logo function
                    CALL WaitForLevel
					call initProg  ;then initialize the screen and scores of each player and positions
					;draw all objects in game
					CALL DrawWalls
                    CALL DrawPlayer1
                    CALL DrawPlayer2 
					;timer for bonus generation time
					CALL StartTime
					;draw chat box in game
                    CALL InGameChat
                
				;all following checks are about any taken action in game
				check2:
		    CALL CheckBonus
                    CALL CheckBombs
                    mov ah,1
                    int 16h
                    jnz SendInstruction2
					jmp CheckForInstruction2
			SendInstruction2:
                    mov ah, 0
					int 16h
					;check all 8 keys
					cmp ah, 4Bh
					jz arrow2
					cmp ah, 48h
					jz arrow2
					cmp ah, 4Dh
					jz arrow2
					cmp ah, 50h
					jz arrow2
					cmp ah, 63
					jz arrow2
					cmp ah, 64
					jz arrow2
					cmp ah, 65
					jz arrow2
					cmp ah, 66
					jz arrow2
					cmp ah, 62    ;f4
					jz arrow2
					;if it's not any of 4 arrows or 4 controls >> then it's message
					mov ah, al     ;to send al as ascii code
					call ChatKeys  
					jmp continueCycle2  ;then continue cycle of game 
					arrow2:     ;if it's one of arrows >> then go to game controlling
					Call GameKeys2
					continueCycle2:
				CheckForInstruction2:
					call ReceiveValueFromSerial ;recieve scancode
					cmp al, 1           ;if al = 1 then ther is no input
					je check2
					;we now check whether the recieved key is one of the
					;scan code of our controls
					;if so, we don't call the function that displays the input on  the screen
					cmp ah, 4Bh
					jz arrow3
					cmp ah, 48h
					jz arrow3
					cmp ah, 4Dh
					jz arrow3
					cmp ah, 50h
					jz arrow3
					cmp ah, 63
					jz arrow3
					cmp ah, 64
					jz arrow3
					cmp ah, 65
					jz arrow3
					cmp ah, 66
					jz arrow3
					cmp ah, 62    ;f4
					jz arrow3
					push ax
					mov al, ah
					call recvchar
					pop ax
					arrow3:
					call keyPressed
                    JMP check2
					ret
GameCycle2                   endp
;initialize game with new clear screen and scores of each player and positions
initProg proc
                    ;scroll last text mode page
                    mov ax,0600h
                    mov bh,07h
                    mov cx,0
                    mov dx,184FH
                    int 10h
                    ;new graphics mode 
                    mov ah,0
                    mov al,13h
                    int 10h
                    ;initializing all scores
                    mov p1lifes,4
                    mov p2lifes,4
                    mov p1bombs,8
                    mov p2bombs,8
                    ;positions of players in game starting
                    mov player1X, 0
                    mov player1Y, 0
                    mov player2X, 300
                    mov player2Y, 120
                    
					;initializing bonus array with default values to start generation from scratch
                    mov arrbonus3[0], 0
                    mov arrbonus3[2],-1
                    mov arrbonus3[4],-1

                    mov arrbonus2[0], 0
                    mov arrbonus2[2],-1
                    mov arrbonus2[4],-1

                    mov arrbonus1[0], 0
                    mov arrbonus1[2],-1
                    mov arrbonus1[4],-1
                    ;counter of bonus appeared
                    mov numbonus, 0
					mov gameflag, 0
					mov chatflag, 0

ret
initProg endp
;Initializes the serial port
;@param			none
;@return		none
InitializeSerialPort	PROC	NEAR
		mov dx,3fbh 			; Line Control Register
		mov al,10000000b		;Set Divisor Latch Access Bit
		out dx,al				;Out it

		mov dx,3f8h				;Set LSB byte of the Baud Rate Divisor Latch register.	
		mov al,0ch			
		out dx,al

		mov dx,3f9h				;Set MSB byte of the Baud Rate Divisor Latch register.
		mov al,00h
		out dx,al

		mov dx,3fbh				;Set port configuration
		mov al,00011011b
		out dx, al
		RET
InitializeSerialPort	ENDP
;-------------------------
;This procedure sends the value in AH through serial
;@param			AH: value to be sent
;@return		none
SendValueThroughSerial	PROC	NEAR
		push dx
		push ax
;Check that Transmitter Holding Register is Empty
		mov dx , 3FDH ; Line Status Register
	 	In al , dx ;Read Line Status
		test al , 00100000b
		JNZ EmptyLineRegister ;Not empty
		pop ax
		pop dx
		RET
EmptyLineRegister:
;If empty put the VALUE in Transmit data register
		mov dx , 3F8H ; Transmit data register
		mov al, ah
		out dx, al
		pop ax
		pop dx
		RET
SendValueThroughSerial	ENDP
;-------------------------
;This procedure receives a byte from serial
;@param			none
;@return		AH: byte received, AL: {0: yes input, 1: no input}
ReceiveValueFromSerial	PROC	NEAR
;Check that Data is Ready
		push dx
		mov dx , 3FDH ; Line Status Register
		in al , dx
		test al , 1
		JNZ SerialInput ;Not Ready
		mov al, 1
		pop dx
		RET		;if 1 return
SerialInput:
;If Ready read the VALUE in Receive data register
		mov dx , 03F8H
		in al , dx
		mov ah, al
		mov al, 0
		pop dx
		RET
ReceiveValueFromSerial	ENDP

;--------------------------------------------
GameKeys             proc					
call SendValueThroughSerial
CALL keyPressed
ret
GameKeys				endp

;------------------------------------------
ChatKeys             proc					

					call SendValueThroughSerial ;send scancode
					push ax
					call sendchar
					pop ax
					ret
ChatKeys				endp
;-----------------------------------------------

GameKeys2			proc
call SendValueThroughSerial
CALL keyPressed2
ret
ret
GameKeys2			endp

exchangeNames proc 
    
               ;send my name to player 2 ---------------------send name ------------   
                    ;send length of manager name
               sendagainM: 
                    mov al,LenUSNAME
                    call SendValueThroughSerialHex
                    ;send name char by char
                    mov cl,0 
                    mov di,offset P1Name
               nextletterM:     
                     mov al,[di] 
                     push cx
                     call SendValueThroughSerialHex  ;try to send
                     pop cx
                     inc di
                    
                     inc cl
                     cmp cl,LenUSNAME
                     JB nextletterM  
                     ;receive player 2 Name length-------------------receive name--------------------
                checkM:
                    call ReceiveValueFromSerialHex
		            mov Player2NameLen,ah	
                    ;receive player 2 name char by char 
                    mov cl,0
                    mov di,offset Player2Name
               nextletter2M:
              
                     push cx
                     call ReceiveValueFromSerialHex   ;try to rec ieve
		             pop cx
		             mov [di],ah 
                     inc di
                   
                     inc cl
                     cmp cl,Player2NameLen
                     JB nextletter2M

                    ;-------------------------   
    ret   
exchangeNames endp 



exchangeNames2 proc 
    
              
                     ;receive player 2 Name length-------------------receive name--------------------
                checkMN:
                    call ReceiveValueFromSerialHex
		            cmp al, 1                 ;if al = 1 then ther is no input
		       ;     je checkMN
		            mov Player2NameLen,ah	
                    ;receive player 2 name char by char 
                    mov cl,0
                    mov di,offset Player2Name
               nextletter2MN:
                     push cx
                     call ReceiveValueFromSerialHex   ;try to rec ieve
		             pop cx
		             mov [di],ah 
                     inc di
                     
                     inc cl
                     cmp cl,Player2NameLen
                     JB nextletter2MN
                    
                     ;send my name to player 2 ---------------------send name ------------   
                    ;send length of manager name
               sendagainMN: 
                    mov al,LenUSNAME
                    call SendValueThroughSerialHex
                    ;send name char by char
                    mov cl,0 
                    mov di,offset P1Name
               nextletterMN:     
                     mov al,[di] 
                     push cx
                     call SendValueThroughSerialHex  ;try to send
                     pop cx
                     inc di
                     
                     inc cl
                     cmp cl,LenUSNAME
                     JB nextletterMN  
                    ;------------------------- 
                      
    ret   
exchangeNames2 endp 



;------------------------------------------------------send and recive hex------------------
SendValueThroughSerialHex	PROC	NEAR  
        
		push dx
		push ax
;Check that Transmitter Holding Register is Empty
        mov dx , 3FDH		; Line Status Register
        AGAIN:   In al , dx 			;Read Line Status
  		AND al , 00100000b
  		JZ AGAIN
EmptyLineRegisterHex:
;If empty put the VALUE in Transmit data register  
        pop ax
        mov dx , 3F8H		; Transmit data register
  		out dx , al 
		pop dx 
		
		RET
SendValueThroughSerialHex	ENDP
;-------------------------
;This procedure receives a byte from serial
;@param			none
;@return		AH: byte received, AL: {0: yes input, 1: no input}
ReceiveValueFromSerialHex	PROC	NEAR
;Check that Data is Ready     
        
		push dx
		mov dx , 3FDH		; Line Status Register
	    CHK:	in al , dx 
  		AND al , 1
  		JZ CHK
SerialInputHex:
;If Ready read the VALUE in Receive data register
	    mov dx , 03F8H
  		in al , dx 
  		mov ah , al
		pop dx 
		
		RET
ReceiveValueFromSerialHex	ENDP

                    END MAIN