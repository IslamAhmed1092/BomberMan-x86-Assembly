.model small
.stack 64
.data

;2 lines Y-position of score bar(const)
line1score dw 141
line2score dw 155

Nameplayer1 db 'Hossam','$'
lenp1 equ 6

Nameplayer2 db 'Youssef'
lenp2 equ 7


colonletter db ':'     

;end of page message
messageEnd1 db 'to end game with'
lenEnd1 equ 16
messageEnd2 db ', Press F4'
lenEnd2 equ 10


;in score bar with small size (const)

heartSmall             db 00h, 00h, 00h, 00h, 00h, 00h, 00h,00h
                       db 00h, 28h, 28h, 00h, 00h, 28h, 28h, 00h
                       db 28h, 0fh, 28h, 28h, 28h, 28h, 28h, 28h
                       db 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h
                       db 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h
                       db 00h, 28h, 28h, 28h, 28h, 28h, 28h, 00h
                       db 00h, 00h, 28h, 28h, 28h, 28h, 00h, 00h
                       db 00h, 00h, 00h, 28h, 28h, 00h, 00h, 00h

;in score bar with small size (const)
bombSmall             db 0,0,0,6,6,0,0,0
                      db 0,0,4,4,4,4,0,0
                      db 0,4,4,4,4,4,4,0
                      db 4,4,4,4,4,4,4,4
                      db 4,4,4,4,4,4,4,4
                      db 0,4,4,4,4,4,4,0
                      db 0,4,4,4,4,4,4,0
                      db 0,0,4,4,4,4,0,0


;coordinates of drawing small life bonus in score bar (const)
lifesX dw ?
lifesY dw 143
                                                             
;coordinates of drawing small bomb in score bar (const)
bombsX dw ?
bombsY dw 143




;store player1 score(variables)
p1Lifes db 5
p1Bombs db 3 

;store player2 score(variables)
p2Lifes db 7
p2Bombs db 8 



.code

main proc
mov ax,@data
mov ds,ax

;clear  
mov ax,0600h
mov bh,07h
mov cx,0
mov dx,184FH
;gfx13
int 10h
mov ah,0
mov al,13h
int 10h


call scorelines
call p1info
call drawlifes
call drawp1sc
call drawsbombs
call drawp1sc2
call p2info
call drawlifes2  
call drawp2sc
call drawsbombs
call drawp2sc2
call chatbox
call PageEnd

mov ax,004ch
int 21h
  
main endp

;draws 2 lines of score bar
scorelines proc 
mov cx,0
mov dx,line1score
mov al,9
mov ah,0ch
line1loop: 
mov dx,line1score
int 10h    
mov dx,line2score
int 10h    
inc cx
cmp cx,320
jnz line1loop

;vertical line to seperate 2 players scores
mov cx,160        ;mid of screen
mov dx,line1score      ;from line1
mov al,9
mov ah,0ch
loopvert:
int 10h    
inc dx
cmp dx,line2score      ;untill line2
jnz loopvert
 
ret    
scorelines endp    


;write player1 Name
p1info proc
MOV AX, @DATA
MOV ES, AX
MOV BP, OFFSET Nameplayer1 ; ES: BP POINTS TO THE TEXT
MOV AH, 13H ; WRITE THE STRING
MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
XOR BH,BH ; VIDEO PAGE = 0
MOV BL, 0Fh ;GREEN
MOV CX, lenp1 ; LENGTH OF THE STRING
MOV DH,18 ;ROW TO PLACE STRING
MOV DL, 0 ; COLUMN TO PLACE STRING
INT 10H

ret    
p1info endp    


;draw small heart for player1
drawlifes proc
               mov di,offset heartSmall    
               
               ;to calculate lifeX=8*NameDim + 8(for space)=9*NameDim
               mov ah,0
               mov al,lenp1
               mov cl,9
               mul cl
               
               mov lifesx,ax ;set life position
               
               
               mov cx,lifesX
               mov dx,lifesY
               mov bx,8
               nxtline6:
               line6:
               mov al,[di]
               inc di
               mov ah,0ch
               int 10h
               inc cx
               push bx
               mov bx,lifesX
               add bx,8
               cmp cx,bx
               pop bx
               jnz line6
               inc dx
               mov cx,lifesX
               dec bx
               and bx,bx
               jnz nxtline6


ret 
drawlifes endp    

;write conlon then lifes score , NOTE:Call this funcion ''only'' after taking life bonus for player1  
;Don't render any other function, i seperated them for this purpose(reduce flickering)
drawp1sc proc
MOV BP, OFFSET colonletter ; ES: BP POINTS TO THE TEXT
MOV AH, 13H ; WRITE THE STRING
MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
XOR BH,BH ; VIDEO PAGE = 0
MOV BL, 0Fh ;GREEN
MOV CX,1 ; LENGTH OF THE STRING
MOV DH,18 ;ROW TO PLACE STRING
mov dl,lenp1
add dl,2  ; COLUMN TO PLACE STRING 
INT 10H

mov ah,2
mov dl,p1Lifes
add dl,30h
int 21h
    
ret
drawp1sc endp    


;draw bombs for player1&player2
drawsbombs proc
               mov di,offset bombSmall    
               
               ;to calculate bombX=lifeX+8(DimHeart)+8(space)+8(colon)+8(scoreLifes)+8(space) = lifeX+32
               mov ax,lifesX
               add ax,32
               mov bombsX,ax ;set bomb position
               
               mov cx,bombsX
               mov dx,bombsY
               mov bx,8
               nxtline7:
               line7:
               mov al,[di]
               inc di
               mov ah,0ch
               int 10h
               inc cx
               push bx
               mov bx,bombsX
               add bx,8
               cmp cx,bx
               pop bx
               jnz line7
               inc dx
               mov cx,bombsX
               dec bx
               and bx,bx
               jnz nxtline7

ret
drawsbombs endp    

;Draw score of bombs for player1, NOTE:Call this function ''ONLY'' after taking bomb bonus for player
;Don't render any other function, i seperated them for this purpose(reduce flickering)
drawp1sc2 proc
MOV BP, OFFSET colonletter ; ES: BP POINTS TO THE TEXT
MOV AH, 13H ; WRITE THE STRING
MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
XOR BH,BH ; VIDEO PAGE = 0
MOV BL, 0Fh ;White
MOV CX,1 ; LENGTH OF THE STRING
MOV DH,18 ;ROW TO PLACE STRING

mov dl,lenp1
add dl,6  ; COLUMN TO PLACE STRING 
INT 10H

mov ah,2
mov dl,p1Bombs
add dl,30h
int 21h
    
ret
drawp1sc2 endp    



;----------------------------------------------------------------------------------
;Player2 functions


;write player2 name
p2info proc
MOV AX, @DATA
MOV ES, AX
MOV BP, OFFSET Nameplayer2 ; ES: BP POINTS TO THE TEXT
MOV AH, 13H ; WRITE THE STRING
MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
XOR BH,BH ; VIDEO PAGE = 0
MOV BL, 0Fh ;GREEN
MOV CX, lenp2 ; LENGTH OF THE STRING
MOV DH,18 ;ROW TO PLACE STRING
MOV DL,21 ; COLUMN TO PLACE STRING
INT 10H
ret    
p2info endp    

;draw small heart after name
drawlifes2 proc
               mov di,offset heartSmall    
               
               ;to calculate lifeX=8*NameDim +160(half screec)+ 8(for space)=8*NameDim+168
               mov ah,0
               mov al,lenp2
               mov cl,10
               mul cl
               
               add ax,168
               mov lifesx,ax ;set life position
               
               mov cx,lifesX
               mov dx,lifesY
               mov bx,8
               nxtline8:
               line8:
               mov al,[di]
               inc di
               mov ah,0ch
               int 10h
               inc cx
               push bx
               mov bx,lifesX
               add bx,8
               cmp cx,bx
               pop bx
               jnz line8
               inc dx
               mov cx,lifesX
               dec bx
               and bx,bx
               jnz nxtline8


ret 
drawlifes2 endp    
                                                                                       
                                                                                       
;write conlon then lifes score , NOTE:Call this funcion ''ONLY'' after taking life bonus for player2  
;Don't render any other functions, i seperated them for this purpose(reduce flickering)
drawp2sc proc
MOV BP, OFFSET colonletter ; ES: BP POINTS TO THE TEXT
MOV AH, 13H ; WRITE THE STRING
MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
XOR BH,BH ; VIDEO PAGE = 0
MOV BL, 0Fh ;WHITE
MOV CX,1 ; LENGTH OF THE STRING
MOV DH,18 ;ROW TO PLACE STRING
mov dl,lenp2
add dl,24  ; 20(half of screen+1(heart)+1(space) 
INT 10H

mov ah,2
mov dl,p2Lifes
add dl,30h
int 21h
    
ret
drawp2sc endp    


;write conlon then lifes score , NOTE:Call this funcion ''ONLY'' after taking life bonus for player2  
;Don't render any other functions, i seperated them for this purpose(reduce flickering)
drawp2sc2 proc
MOV BP, OFFSET colonletter ; ES: BP POINTS TO THE TEXT
MOV AH, 13H ; WRITE THE STRING
MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
XOR BH,BH ; VIDEO PAGE = 0
MOV BL, 0Fh ;White
MOV CX,1 ; LENGTH OF THE STRING
MOV DH,18 ;ROW TO PLACE STRING

mov dl,lenp2
add dl,28  ; COLUMN TO PLACE STRING 
INT 10H

mov ah,2
mov dl,p2Bombs
add dl,30h
int 21h
    
ret
drawp2sc2 endp    
 

;------------------------------------------------------
;chatBox part 
chatbox proc
;scroll ccreen for chat box
MOV AH, 06h ; Scroll up function
XOR AL, AL ; Clear entire screen
mov Ch, 20 ; Upper left corner CH=row, CL=column
mov cl,0   
MOV DX, 184FH ; lower right corner DH=row, DL=column
MOV BH, 0 ; color
INT 10H
;write player name
MOV BP, OFFSET Nameplayer1 ; ES: BP POINTS TO THE TEXT
MOV AH, 13H ; WRITE THE STRING
MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
XOR BH,BH ; VIDEO PAGE = 0
MOV BL, 09h ;Light blue
MOV CX, lenp1 ; LENGTH OF THE STRING
MOV DH,20 ;ROW TO PLACE STRING
MOV DL, 0 ; COLUMN TO PLACE STRING
INT 10H
;write colon
mov ah,2
mov dl,58 ;58 is ascii code of( : )
int 21h

ret
chatbox endp     

;function to write end of page note
PageEnd proc
mov cx,0
mov dx,190 ;last 10 pexils in screen (last row of letters)
mov al,9
mov ah,0ch
endpageloop: 
int 10h    
inc cx
cmp cx,320
jnz endpageloop

;end message divided into 3 parts

;first part
MOV BP, OFFSET messageEnd1 ; ES: BP POINTS TO THE TEXT
MOV AH, 13H ; WRITE THE STRING
MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
XOR BH,BH ; VIDEO PAGE = 0
MOV BL, 09h ;blue
MOV CX, lenEnd1 ; LENGTH OF THE STRING
MOV DH,24 ;ROW TO PLACE STRING
MOV DL, 0 ; COLUMN TO PLACE STRING
INT 10H

;second part
MOV BP, OFFSET NamePlayer2 ; ES: BP POINTS TO THE TEXT
MOV CX, lenp2 ; LENGTH OF THE STRING
MOV DH,24 ;ROW TO PLACE STRING
MOV DL,lenEnd1 ; start after part2 string length 
add dl,1       ;for space
INT 10H

;third part
MOV BP, OFFSET messageEnd2 ; ES: BP POINTS TO THE TEXT
MOV CX, lenEnd2 ; LENGTH OF THE STRING
MOV DH,24 ;ROW TO PLACE STRING
MOV DL,lenEnd1 ; start after part1 string length 
add dl,lenp2       ;after part2
add dl,1           ;space
INT 10H

ret
PageEnd endp

end main