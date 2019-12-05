
PUBLIC drawBomb, drawBonus1, drawBonus2, DrawPlayer1, DrawPlayer2, DrawWalls, moveMan, ClearBlock

.model compact
.stack 64
.data

xBomb dw 100
yBomb dw 100
xBonus1 dw 150
yBonus1 dw 150
xBonus2 dw 150
yBonus2 dw 100
RED                 EQU         04h
WHITE               EQU         0Fh
BLACK               EQU         00h
BROWN               EQU         06h
BGC                 EQU         BLACK
BLUE                EQU         01h
OBJECT_SIZE         EQU         20
ObjectSize          db          20
Player1X            dw          0
Player1Y            dw          0
ClearX              dw          0
ClearY              dw          0
Player2X            dw          300
Player2Y            dw          120
WallsX              dw          20, 60, 100, 140,180,220, 260, 280
                    dw          20, 60, 100, 140,180,220, 260
                    dw          160
                    dw          20, 60, 100, 140,180,220, 260, 280

WallsY              dw          20, 20, 20, 20, 20, 20, 20, 40
                    dw          60, 60, 60, 60, 60, 60, 60
                    dw          80
                    dw          100, 100, 100, 100, 100, 100, 100, 80

WallsNo             EQU         24



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

moveMan             PROC FAR
		    push ax
                    MOV AX, Player1X
                    MOV ClearX, AX
                    MOV AX, Player1Y
                    MOV ClearY, AX
                    pop ax
                    CMP AH,48h
                    JE moveUp
                    CMP AH,50h
                    JE moveDown 
                    CMP AH,4dh
                    JE moveRight
                    CMP AH,4bh
                    JE moveLeft
                    JMP return
               moveUp:
                    ;check if top edge
                    CMP Player1Y, 0
                    JZ return
                    ;else move
                    SUB Player1Y, OBJECT_SIZE
                    JMP draw4
               moveDown:
                    ;check if down edge 
                    CMP Player1Y, 120
                    JZ return
                    ;else move
                    ADD Player1Y, OBJECT_SIZE 
                    JMP draw4
               moveRight:
                    ;check if right edge  
                    CMP Player1X, 300
                    JZ return
                    ;else move
                    ADD Player1X, OBJECT_SIZE      
                    JMP draw4
               moveLeft:
                    ;check if left edge
                    CMP Player1X, 0
                    JZ return
                    ;else move
                    SUB Player1X, OBJECT_SIZE
               draw4:
                    CALL ClearBlock
                    CALL DrawPlayer1                    
               return:
                    ret    
moveMan             ENDP




END
