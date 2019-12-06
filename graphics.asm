
PUBLIC drawBomb, drawBonus1, drawBonus2, DrawPlayer1, DrawPlayer2, DrawWalls, moveMan, ClearBlock,InGameChat,drawp2sc,drawp2sc2,drawp1sc2,drawp1sc

extrn P1Name:Byte
extrn LenUSNAME:Byte

.model compact
.stack 64
.data
canMove db 1 
checkDir db ? ; 0 check up , 1 check down , 2 check left ,3 check right 

;coordinates of bonus and bombs
xBomb dw 100
yBomb dw 100
xBonus1 dw 150
yBonus1 dw 150
xBonus2 dw 150
yBonus2 dw 100

;colors
RED                 EQU         04h
WHITE               EQU         0Fh
BLACK               EQU         00h
BROWN               EQU         06h
BGC                 EQU         BLACK
BLUE                EQU         01h
OBJECT_SIZE         EQU         20

ObjectSize          db          20    ;size of any object
;player1 coordinates (variables)
Player1X            dw          0
Player1Y            dw          0
ClearX              dw          0
ClearY              dw          0
;player2 coordinates (variables)
Player2X            dw          300
Player2Y            dw          120

;array of coordinates for walls(const)
WallsX              dw          20, 60, 100, 140,180,220, 260, 280
                    dw          20, 60, 100, 140,180,220, 260
                    dw          160
                    dw          20, 60, 100, 140,180,220, 260, 280

WallsY              dw          20, 20, 20, 20, 20, 20, 20, 40
                    dw          60, 60, 60, 60, 60, 60, 60
                    dw          80
                    dw          100, 100, 100, 100, 100, 100, 100, 80

WallsNo             EQU         24   ;number of walls in game


;colors of 20*20 bomb
bombColors          db 0,0,0,0,0,0,0,0,0,0,0,4,4,0,0,0,0,0,0,0
                    db 0,0,0,0,0,0,0,0,0,0,4,4,0,0,0,0,0,0,0,0
                    db 0,0,0,0,0,0,0,0,0,4,4,4,0,0,0,0,0,0,0,0
                    db 0,0,0,0,4,4,4,4,4,4,4,4,4,4,4,0,0,0,0,0
                    db 0,0,0,4,4,4,4,4,4,4,4,4,4,4,4,4,4,0,0,0 
                    db 0,0,0,4,4,4,4,4,4,4,4,4,4,4,4,4,4,0,0,0
                    db 0,0,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,0,0
                    db 0,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,0
                    db 0,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,0
                    db 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
                    db 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
                    db 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
                    db 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
                    db 0,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,0
                    db 0,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,0
                    db 0,0,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,0,0
                    db 0,0,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,0,0
                    db 0,0,0,4,4,4,4,4,4,4,4,4,4,4,4,4,4,0,0,0
                    db 0,0,0,0,4,4,4,4,4,4,4,4,4,4,4,4,0,0,0,0
                    db 0,0,0,0,0,0,4,4,4,4,4,4,4,4,0,0,0,0,0,0

;colors of 20*20 Heart (bonus1)
bonus1Colors        db 0,4,4,4,4,4,4,0,0,0,0,0,0,4,4,4,4,4,4,0
                    db 0,4,4,4,4,4,4,0,0,0,0,0,0,4,4,4,4,4,4,0 
                    db 4,4,4,4,4,4,4,4,0,0,0,0,4,4,4,4,4,4,4,4
                    db 4,4,4,4,4,4,4,4,4,0,0,4,4,4,4,4,4,4,4,4
                    db 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4 
                    db 0,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,0
                    db 0,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,0
                    db 0,0,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,0,0
                    db 0,0,0,4,4,4,4,4,4,4,4,4,4,4,4,4,4,0,0,0
                    db 0,0,0,4,4,4,4,4,4,4,4,4,4,4,4,4,4,0,0,0
                    db 0,0,0,0,4,4,4,4,4,4,4,4,4,4,4,4,0,0,0,0
                    db 0,0,0,0,4,4,4,4,4,4,4,4,4,4,4,4,0,0,0,0
                    db 0,0,0,0,0,4,4,4,4,4,4,4,4,4,4,0,0,0,0,0
                    db 0,0,0,0,0,4,4,4,4,4,4,4,4,4,4,0,0,0,0,0
                    db 0,0,0,0,0,0,4,4,4,4,4,4,4,4,0,0,0,0,0,0
                    db 0,0,0,0,0,0,4,4,4,4,4,4,4,4,0,0,0,0,0,0
                    db 0,0,0,0,0,0,0,4,4,4,4,4,4,0,0,0,0,0,0,0
                    db 0,0,0,0,0,0,0,0,4,4,4,4,0,0,0,0,0,0,0,0
                    db 0,0,0,0,0,0,0,0,0,4,4,0,0,0,0,0,0,0,0,0
                    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

;colors of 20*20 Diamnond (bonus2)
bonus2Colors        db 0,0,0,0,0,0,0,0,0,2,2,0,0,0,0,0,0,0,0,0
                    db 0,0,0,0,0,0,0,0,2,2,2,2,0,0,0,0,0,0,0,0 
                    db 0,0,0,0,0,0,0,2,2,2,2,2,2,0,0,0,0,0,0,0
                    db 0,0,0,0,0,0,2,2,2,2,2,2,2,2,0,0,0,0,0,0
                    db 0,0,0,0,0,2,2,2,2,2,2,2,2,2,2,0,0,0,0,0 
                    db 0,0,0,0,2,2,2,2,2,2,2,2,2,2,2,2,0,0,0,0
                    db 0,0,0,2,2,2,2,2,2,2,2,2,2,2,2,2,2,0,0,0 
                    db 0,0,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,0,0 
                    db 0,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,0 
                    db 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
                    db 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
                    db 0,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,0
                    db 0,0,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,0,0
                    db 0,0,0,2,2,2,2,2,2,2,2,2,2,2,2,2,2,0,0,0
                    db 0,0,0,0,2,2,2,2,2,2,2,2,2,2,2,2,0,0,0,0
                    db 0,0,0,0,0,2,2,2,2,2,2,2,2,2,2,0,0,0,0,0
                    db 0,0,0,0,0,0,2,2,2,2,2,2,2,2,0,0,0,0,0,0
                    db 0,0,0,0,0,0,0,2,2,2,2,2,2,0,0,0,0,0,0,0
                    db 0,0,0,0,0,0,0,0,2,2,2,2,0,0,0,0,0,0,0,0
                    db 0,0,0,0,0,0,0,0,0,2,2,0,0,0,0,0,0,0,0,0

;player1 colors
Player1             db       BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
                    db       BGC, BGC, BGC, BLACK, BLACK, BLACK, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
                    db       BGC, BGC, BLACK, RED, RED, RED, BLACK, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
                    db       BGC, BLACK, RED, RED, RED, RED, RED, BLACK, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
                    db       BGC, BLACK, RED, RED, BLACK, BLACK, RED, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BGC, BGC, BGC, BGC, BGC
                    db       BGC, BLACK, RED, RED, BLACK, WHITE, BLACK, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, BLACK, BGC, BGC, BGC, BGC
                    db       BGC, BGC, BLACK, RED, RED, BLACK, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, BLACK, BGC, BGC, BGC
                    db       BGC, BGC, BGC, BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, BLACK, BGC, BGC
                    db       BGC, BGC, BGC, BGC, BLACK, WHITE, WHITE, WHITE, BLACK, BLACK, BLACK, WHITE, WHITE, WHITE, BLACK, BLACK, BLACK, WHITE, BLACK, BGC
                    db       BGC, BGC, BGC, BLACK, WHITE, WHITE, WHITE, BLACK, BROWN, BROWN, BROWN, BLACK, BLACK, BLACK, BROWN, BROWN, BROWN, WHITE, BLACK, BGC
                    db       BGC, BGC, BGC, BLACK, WHITE, WHITE, BLACK, BROWN, BROWN, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BROWN, WHITE, BLACK, BGC
                    db       BGC, BGC, BGC, BLACK, WHITE, WHITE, BLACK, BROWN, BROWN, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BROWN, WHITE, BLACK, BGC
                    db       BGC, BGC, BGC, BLACK, WHITE, WHITE, BLACK, BROWN, BROWN, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BROWN, WHITE, BLACK, BGC
                    db       BGC, BGC, BGC, BLACK, WHITE, WHITE, BLACK, BROWN, BROWN, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BROWN, WHITE, BLACK, BGC
                    db       BGC, BGC, BGC, BGC, BLACK, WHITE, BLACK, BROWN, BROWN, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BROWN, WHITE, BLACK,BGC
                    db       BGC, BGC, BGC, BGC, BLACK, WHITE, WHITE, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, WHITE, BLACK, BGC, BGC
                    db       BGC, BGC, BGC, BGC, BGC, BLACK, WHITE, WHITE, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, WHITE, WHITE, BLACK, BGC, BGC, BGC
                    db       BGC, BGC, BGC, BGC, BGC, BGC, BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK, BGC, BGC, BGC, BGC
                    db       BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BGC, BGC, BGC, BGC, BGC, BGC
                    db       BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC

;player2 colors
Player2             db      BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
                    db      BGC, BGC, BGC, BLACK, BLACK, BLACK, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
                    db      BGC, BGC, BLACK, RED, RED, RED, BLACK, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
                    db      BGC, BLACK, RED, RED, RED, RED, RED, BLACK, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
                    db      BGC, BLACK, RED, RED, BLACK, BLACK, RED, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BGC, BGC, BGC, BGC, BGC
                    db      BGC, BLACK, RED, RED, BLACK, BLUE, BLACK, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLACK, BGC, BGC, BGC, BGC
                    db      BGC, BGC, BLACK, RED, RED, BLACK, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLACK, BGC, BGC, BGC
                    db      BGC, BGC, BGC, BLACK, BLACK, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLACK, BGC, BGC
                    db      BGC, BGC, BGC, BGC, BLACK, BLUE, BLUE, BLUE, BLACK, BLACK, BLACK, BLUE, BLUE, BLUE, BLACK, BLACK, BLACK, BLUE, BLACK, BGC
                    db      BGC, BGC, BGC, BLACK, BLUE, BLUE, BLUE, BLACK, BROWN, BROWN, BROWN, BLACK, BLACK, BLACK, BROWN, BROWN, BROWN, BLUE, BLACK, BGC
                    db      BGC, BGC, BGC, BLACK, BLUE, BLUE, BLACK, BROWN, BROWN, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BROWN, BLUE, BLACK, BGC
                    db      BGC, BGC, BGC, BLACK, BLUE, BLUE, BLACK, BROWN, BROWN, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BROWN, BLUE, BLACK, BGC
                    db      BGC, BGC, BGC, BLACK, BLUE, BLUE, BLACK, BROWN, BROWN, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BROWN, BLUE, BLACK, BGC
                    db      BGC, BGC, BGC, BLACK, BLUE, BLUE, BLACK, BROWN, BROWN, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BROWN, BLUE, BLACK, BGC
                    db      BGC, BGC, BGC, BGC, BLACK, BLUE, BLACK, BROWN, BROWN, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BROWN, BLUE, BLACK, BGC
                    db      BGC, BGC, BGC, BGC, BLACK, BLUE, BLUE, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLUE, BLACK, BGC, BGC
                    db      BGC, BGC, BGC, BGC, BGC, BLACK, BLUE, BLUE, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLUE, BLUE, BLACK, BGC, BGC, BGC
                    db      BGC, BGC, BGC, BGC, BGC, BGC, BLACK, BLACK, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLACK, BLACK, BGC, BGC, BGC, BGC
                    db      BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BGC, BGC, BGC, BGC, BGC, BGC
                    db      BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC

;colors of wall
WALL                db      BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
                    db      BGC, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BGC
                    db      BGC, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BGC
                    db      BGC, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BGC
                    db      BGC, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BGC
                    db      BGC, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BGC
                    db      BGC, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BGC
                    db      BGC, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BGC
                    db      BGC, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BGC
                    db      BGC, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BGC
                    db      BGC, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BGC
                    db      BGC, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BGC
                    db      BGC, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BGC
                    db      BGC, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BGC
                    db      BGC, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BGC
                    db      BGC, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BGC
                    db      BGC, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BGC
                    db      BGC, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BGC
                    db      BGC, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BGC
                    db      BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC


;----------------------------------
;2 lines Y-position of score bar(const)
line1score dw 141
line2score dw 155


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
drawBomb proc near
               mov di,offset bombColors    
               mov cx,xBomb
               mov dx,yBomb
               mov bx,OBJECT_SIZE
               nxtline2:
               line2:
               mov al,[di]
               inc di
               mov ah,0ch
               int 10h
               inc cx
               push bx
               mov bx,xBomb
               add bx,OBJECT_SIZE
               cmp cx,bx
               pop bx
               jnz line2
               inc dx
               mov cx,xBomb
               dec bx
               and bx,bx
               jnz nxtline2
               ret
drawBomb endp    

;--------------------------------------------------

drawBonus1          proc FAR
               mov di,offset bonus1Colors    
               mov cx,xBonus1
               mov dx,yBonus1
               mov bx,OBJECT_SIZE
               nxtline3:
               line3:
               mov al,[di]
               inc di
               mov ah,0ch
               int 10h
               inc cx
               push bx
               mov bx,xBonus1
               add bx,OBJECT_SIZE
               cmp cx,bx
               pop bx
               jnz line3
               inc dx
               mov cx,xBonus1
               dec bx
               and bx,bx
               jnz nxtline3

               ret
drawBonus1 endp    


;--------------------------------------------------


drawBonus2          proc FAR
                    mov di,offset bonus2Colors    
                    mov cx,xBonus2
                    mov dx,yBonus2
                    mov bx,OBJECT_SIZE
                    nxtline4:
                    line4:
                    mov al,[di]
                    inc di
                    mov ah,0ch
                    int 10h
                    inc cx
                    push bx
                    mov bx,xBonus2
                    add bx,OBJECT_SIZE
                    cmp cx,bx
                    pop bx
                    jnz line4
                    inc dx
                    mov cx,xBonus2
                    dec bx
                    and bx,bx
                    jnz nxtline4
                    ret
drawBonus2 endp    


;--------------------------------------------------
DrawPlayer1         PROC FAR
                    MOV SI, 0

                    mov cx,Player1X ;x
                    mov dx,Player1Y ;y
               Draw:               
                    CMP SI, 0
                    JZ No
                    MOV AX, SI
                    DIV ObjectSize
                    CMP AH, 0
                    JNZ No
                    MOV CX, Player1X
                    INC dx
               No:  
                    mov al,Player1[SI] ;Pixel color
                    mov ah,0ch ;Draw Pixel Command
                    int 10h
                    INC CX
                    INC SI
                    MOV AL, ObjectSize
                    MUL ObjectSize
                    CMP SI, AX
                    JNZ Draw
                    ret
DrawPlayer1         ENDP
;-----------------------

DrawPlayer2         PROC FAR
                    MOV SI, 0


                    mov cx,Player2X ;x
                    mov dx,Player2Y ;y
               Draw2:              
                    CMP SI, 0
                    JZ No2
                    MOV AX, SI
                    DIV ObjectSize
                    CMP AH, 0
                    JNZ No2
                    MOV CX, Player2X
                    INC dx
               No2:                
                    mov al,Player2[SI] ;Pixel color
                    mov ah,0ch ;Draw Pixel Command
                    int 10h
                    INC CX
                    INC SI
                    MOV AL, ObjectSize
                    MUL ObjectSize
                    CMP SI, AX
                    JNZ Draw2
                    ret
DrawPlayer2         ENDP


DrawWalls           PROC FAR
                   
                    MOV DI, 0
               ALL:
                    MOV SI, 0
                    mov cx,WallsX[DI] ;x
                    mov dx,WallsY[DI] ;y
               Draw3:              
                    CMP SI, 0
                    JZ No3
                    MOV AX, SI
                    DIV ObjectSize
                    CMP AH, 0
                    JNZ No3
                    MOV CX, WallsX[DI]
                    INC dx
               No3: 
                    mov al,WALL[SI] ;Pixel color
                    mov ah,0ch ;Draw Pixel Command
                    int 10h
                    INC CX
                    INC SI
                    MOV AL, ObjectSize
                    MUL ObjectSize
                    CMP SI, AX
                    JNZ Draw3
                    ADD DI,2
                    CMP DI, WallsNo*2
                    JNZ ALL
                    ret
DrawWalls           ENDP


ClearBlock          PROC FAR
                    MOV SI, 0


                    mov cx,ClearX ;x
                    mov dx,ClearY ;y
               Clear:
                    CMP SI, 0
                    JZ No4
                    MOV AX, SI
                    DIV ObjectSize
                    CMP AH, 0
                    JNZ No4
                    MOV CX, ClearX
                    INC dx
               No4:  
                    mov al,BGC ;Pixel color
                    mov ah,0ch ;Draw Pixel Command
                    int 10h
                    INC CX
                    INC SI
                    MOV AL, ObjectSize
                    MUL ObjectSize
                    CMP SI, AX
                    JNZ Clear
                    ret
ClearBlock          ENDP

seeCanMove2 proc far 
        mov bx,0 
        
        cmp checkDir,0
        JE checkwallU2
        cmp checkDir,1
        JE checkwallD2
        cmp checkDir,2
        JE checkWallL2
        cmp checkDir,3
        JE checkWallR2
        ret
        ; check can move up 
        checkwallU2:
             mov dx,player2X
             cmp dx,wallsx[bx]
             JNE getNextU2
             mov dx,player2Y
             sub dx,OBJECT_SIZE
             cmp dx,wallsy[bx]
             JE returnCanTMove2
            getnextU2: 
             add bx,2
             cmp bx,48                        
             JB checkwallU2
           jmp returnCanMove2
        ;check cam move down
        checkwallD2:
             mov dx,player2X
             cmp dx,wallsx[bx]
             JNE getNextD2
             mov dx,player2Y
             add dx,OBJECT_SIZE
             cmp dx,wallsy[bx]
             JE returnCanTMove2
            getnextD2: 
             add bx,2
             cmp bx,48                        
             JB checkwallD2
           jmp returnCanMove2
        ;check can move left
        checkwallL2:
             mov dx,player2X
             sub dx,OBJECT_SIZE
             cmp dx,wallsx[bx]
             JNE getNextL2
             mov dx,player2Y  
             cmp dx,wallsy[bx]
             JE returnCanTMove2
            getnextL2: 
             add bx,2
             cmp bx,48                        
             JB checkwallL2
           jmp returnCanMove2
        ;check can move Right
           checkwallR2:
             mov dx,player2X
             add dx,OBJECT_SIZE
             cmp dx,wallsx[bx]
             JNE getNextR2
             mov dx,player2Y  
             cmp dx,wallsy[bx]
             JE returnCanTMove2
            getnextR2: 
             add bx,2
             cmp bx,48                        
             JB checkwallR2
           jmp returnCanMove2
                  
    returnCanTMove2:
    Mov canMove,0
    ret
    returnCanMove2:
    MOV canMove,1
    ret
seeCanMove2 endp 
;------------------- 
seeCanMove1 proc far 
        mov bx,0 
        
        cmp checkDir,0
        JE checkwallU
        cmp checkDir,1
        JE checkwallD
        cmp checkDir,2
        JE checkWallL
        cmp checkDir,3
        JE checkWallR
        ret
        ; check can move up 
        checkwallU:
             mov dx,player1X
             cmp dx,wallsx[bx]
             JNE getNextU
             mov dx,player1Y
             sub dx,OBJECT_SIZE
             cmp dx,wallsy[bx]
             JE returnCanTMove
            getnextU: 
             add bx,2
             cmp bx,48                        
             JB checkwallU
           jmp returnCanMove
        ;check cam move down
        checkwallD:
             mov dx,player1X
             cmp dx,wallsx[bx]
             JNE getNextD
             mov dx,player1Y
             add dx,OBJECT_SIZE
             cmp dx,wallsy[bx]
             JE returnCanTMove
            getnextD: 
             add bx,2
             cmp bx,48                        
             JB checkwallD
           jmp returnCanMove
        ;check can move left
        checkwallL:
             mov dx,player1X
             sub dx,OBJECT_SIZE
             cmp dx,wallsx[bx]
             JNE getNextL
             mov dx,player1Y  
             cmp dx,wallsy[bx]
             JE returnCanTMove
            getnextL: 
             add bx,2
             cmp bx,48                        
             JB checkwallL
           jmp returnCanMove
        ;check can move Right
           checkwallR:
             mov dx,player1X
             add dx,OBJECT_SIZE
             cmp dx,wallsx[bx]
             JNE getNextR
             mov dx,player1Y  
             cmp dx,wallsy[bx]
             JE returnCanTMove
            getnextR: 
             add bx,2
             cmp bx,48                        
             JB checkwallR
           jmp returnCanMove
                  
    returnCanTMove:
    Mov canMove,0
    ret
    returnCanMove:
    MOV canMove,1
    ret
seeCanMove1 endp 

movePlayer2 proc far 
            push ax
            MOV  aX, Player2X
            MOV  ClearX, aX
            MOV  aX, Player2Y
            MOV  ClearY, aX
            pop  ax 
            ;check for player 2
            CMP Al,77h
            JE  moveUpPlayer2
            CMP Al,73h
            JE moveDownPlayer2
            CMP Al,64h
            JE moveRightPlayer2
            CMP Al,61h
            JE moveLeftPlayer2
            JMP return2           
       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;player 2 movement
       moveUpPlayer2:
         ;check if top edge
            CMP Player2Y, 0
            JZ toReturn2
            ;check if new position is inside a wall 
            mov checkdir,0
            call seeCanMove2
            cmp canMove,0
            JE Return2
            ;check if going to through another player
            ;else move
            SUB Player2Y, OBJECT_SIZE
            JMP draw4_2
       moveDownPlayer2:
            ;check if down edge 
            CMP Player2Y, 120
            JZ return2
            ;check if new position is inside a wall 
            mov checkdir,1
            call seeCanMove2
            cmp canMove,0
            JE return2
            ;else move
            ADD Player2Y, OBJECT_SIZE 
            JMP draw4_2
            toReturn2:
              jmp return2
       moveRightPlayer2:
            ;check if right edge  
            CMP Player2X, 300
            JZ return2
            ;check if new position is inside a wall 
            mov checkdir,3
            call seeCanMove2
            cmp canMove,0
            JE return2
            ;else move
            ADD Player2X, OBJECT_SIZE      
            JMP draw4_2
       moveLeftPlayer2:
            ;check if left edge
            CMP Player2X, 0
            JZ return2
            ;check if new position is inside a wall 
            mov checkdir,2
            call seeCanMove2
            cmp canMove,0
            JE return2
            ;else move
            SUB Player2X, OBJECT_SIZE
            JMP draw4_2  
    
     draw4_2:
            CALL ClearBlock
            CALL DrawPlayer2

   return2:
    ret
movePlayer2 endp 

moveMan             PROC FAR
		            push bx
                    MOV  bX, Player1X
                    MOV  ClearX, bX
                    MOV  bX, Player1Y
                    MOV  ClearY, bX
                    pop bx 
                    ;check for player 1
                    CMP AH,48h
                    JE  moveUp
                    CMP AH,50h
                    JE  moveDown 
                    CMP AH,4dh
                    JE  moveRight
                    CMP AH,4bh
                    JE  moveLeft  
                    ;then one doesn't move prepare two to be cleared 
                    JMP return
               moveUp:
                    ;check if top edge
                    CMP Player1Y, 0
                    JZ  toReturn 
                    ;check if new position is inside a wall 
                    mov checkdir,0
                    call seeCanMove1
                    cmp canMove,0
                    JE return
                    ;else move
                    SUB Player1Y, OBJECT_SIZE
                    JMP draw4
               moveDown:
                    ;check if down edge 
                    CMP Player1Y, 120
                    JZ  return
                    ;check if new position is inside a wall 
                    mov checkdir,1
                    call seeCanMove1
                    cmp canMove,0
                    JE return    
                    ;else move
                    ADD Player1Y, OBJECT_SIZE 
                    JMP draw4
                    toReturn:
                      jmp return
               moveRight:
                    ;check if right edge  
                    CMP Player1X, 300
                    JZ return
                    ;check if new position is inside a wall 
                    mov checkdir,3
                    call seeCanMove1
                    cmp canMove,0
                    JE return
                    ;else move
                    ADD Player1X, OBJECT_SIZE      
                    JMP draw4
               moveLeft:
                    ;check if left edge
                    CMP Player1X, 0
                    JZ return
                    ;check if new position is inside a wall 
                    mov checkdir,2
                    call seeCanMove1
                    cmp canMove,0
                    JE return
                    ;else move
                    SUB Player1X, OBJECT_SIZE
                 
               draw4:
                    CALL ClearBlock
                    CALL DrawPlayer1        
               return:
               call movePlayer2
                    ret    
moveMan             ENDP
;--------------------------------------------------------------------------
;this function to draw score bar,chat box

InGameChat proc far
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
ret
InGameChat endp

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
MOV BP, OFFSET P1Name ; ES: BP POINTS TO THE TEXT
MOV AH, 13H ; WRITE THE STRING
MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
XOR BH,BH ; VIDEO PAGE = 0
MOV BL, 0Fh ;GREEN
MOV Cl, LenUSNAME ; LENGTH OF THE STRING
mov ch,0
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
               mov al,LenUSNAME
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
mov dl,LenUSNAME
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

mov dl,LenUSNAME
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
MOV BP, OFFSET P1Name ; ES: BP POINTS TO THE TEXT
MOV AH, 13H ; WRITE THE STRING
MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
XOR BH,BH ; VIDEO PAGE = 0
MOV BL, 09h ;Light blue
MOV Cl, LenUSNAME ; LENGTH OF THE STRING
mov ch,0
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
MOV Cl, lenEnd1 ; LENGTH OF THE STRING
mov ch,0
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


END
