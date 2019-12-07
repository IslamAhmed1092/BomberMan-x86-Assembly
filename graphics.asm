
PUBLIC drawBonus1, drawBonus2,drawBonus3, DrawPlayer1, DrawPlayer2, DrawWalls, drawBomb1, drawBomb2
PUBLIC keyPressed, ClearBlock,InGameChat,drawp2sc,drawp2sc2,drawp1sc2,drawp1sc,NamePlayer2

extrn P1Name:Byte
extrn LenUSNAME:Byte

.model compact
.stack 64
.data
canMove db 1 
checkDir db ? ; 0 check up , 1 check down , 2 check left ,3 check right 

;coordinates of bonus and bombs

;bomb of the first player
Bomb1Drawn          db             0     ;a boolean variable to check if the bomb is drawn or not
Bomb1X              dw             100
Bomb1Y              dw             0

;bomb of the second player
Bomb2Drawn          db             0
Bomb2X              dw             200
Bomb2Y              dw             0

xBonus dw 150
yBonus dw 150

;movement helpers
NoWAll db 1
NoMan  db 1
xMovingMan dw ?
yMovingMan dw ?
xStandMan dw ?
yStandMan dw ?
KeyScancode db ?
keyAscii   db ?
playerMoved db ? 

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
bombColors          db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0eh, 00h, 0eh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 0eh, 2ah, 0eh, 2ah, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0eh, 2ah, 28h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 0eh, 2ah, 28h, 07h, 07h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 07h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 28h, 28h, 28h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 28h, 28h, 28h, 28h, 28h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 28h, 0fh, 28h, 28h, 28h, 28h, 28h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 28h, 0fh, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 28h, 0fh, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 28h, 28h, 28h, 28h, 28h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 28h, 28h, 28h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h

bonus1Colors		db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
			db 00h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 28h, 28h, 28h, 02h, 02h, 02h, 02h, 28h, 28h, 28h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 28h, 0fh, 0fh, 28h, 28h, 02h, 02h, 28h, 28h, 28h, 28h, 28h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 28h, 0fh, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 28h, 28h, 28h, 28h, 28h, 28h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 28h, 28h, 28h, 28h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 28h, 28h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 00h
			db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h

bonus2Colors		db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h 
			db 00h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h 
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h 
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 00h, 00h, 00h, 00h, 02h, 00h, 00h, 02h, 02h, 02h, 29h, 00h 
			db 00h, 29h, 02h, 02h, 02h, 02h, 00h, 00h, 00h, 00h, 95h, 4eh, 00h, 4eh, 00h, 02h, 02h, 02h, 29h, 00h 
			db 00h, 29h, 02h, 02h, 02h, 00h, 0dfh, 0dfh, 0dfh, 00h, 1eh, 00h, 4eh, 00h, 00h, 02h, 02h, 02h,29h,00h 
			db 00h, 29h, 02h, 02h, 02h, 00h, 95h, 95h, 95h, 00h, 1eh, 00h, 00h, 95h, 00h, 02h, 02h, 02h, 29h, 00h 
			db 00h, 29h, 02h, 02h, 00h, 7ch, 4eh, 4eh, 7ch, 00h, 4eh, 4eh, 95h, 95h, 00h, 00h, 02h, 02h, 29h, 00h 
			db 00h, 29h, 02h, 02h, 00h, 7ch, 4eh, 4eh, 7ch, 95h, 00h, 95h, 95h, 00h, 00h, 00h, 02h, 02h, 29h, 00h 
			db 00h, 29h, 02h, 02h, 00h, 7ch, 7ch, 7ch, 7ch, 95h, 95h, 00h, 00h, 00h, 0dfh, 00h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 00h, 95h, 95h, 95h, 95h, 95h, 95h, 0dfh, 0dfh, 0dfh, 0dfh, 00h, 02h, 02h, 29h, 00h 
			db 00h, 29h, 02h, 02h, 02h, 00h, 95h, 95h, 95h, 95h, 0dfh, 0dfh, 0dfh, 0dfh, 00h, 02h, 02h, 02h, 29h, 00h 
			db 00h, 29h, 02h, 02h, 02h, 00h, 0dfh, 0dfh, 0dfh, 0dfh, 0dfh, 0dfh, 0dfh, 0dfh, 00h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 00h, 00h, 0dfh, 0dfh, 0dfh, 0dfh, 00h, 00h, 02h, 02h,02h,02h,29h,00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 00h, 00h, 00h, 00h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 00h
			db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h 

bonus3		db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
			db 00h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 00h, 00h, 00h, 00h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 00h, 00h, 0fh, 0fh, 0fh, 0fh, 00h, 00h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 00h, 4eh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 4eh, 00h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 00h, 4eh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 4eh, 00h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 00h, 4eh, 00h, 00h, 0fh, 0fh, 0fh, 0fh, 00h, 00h, 4eh, 00h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 00h, 4eh, 00h, 28h, 00h, 00h, 0fh, 0fh, 00h, 28h, 00h, 00h, 4eh, 00h, 02h, 29h, 00h
			db 00h, 29h, 02h, 00h, 4eh, 00h, 11h, 00h, 00h, 0fh, 0fh, 00h, 00h, 00h, 00h, 4eh, 00h, 02h, 29h, 00h
			db 00h, 29h, 02h, 00h, 4eh, 00h, 00h, 00h, 19h, 4eh, 4eh, 07h, 00h, 00h, 00h, 4eh, 00h, 02h, 29h, 00h
			db 00h, 29h, 02h, 00h, 4eh, 0fh, 0fh, 0fh, 0fh, 00h, 00h, 0fh, 0fh, 0fh, 0fh, 4eh, 00h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 00h, 00h, 0fh, 0fh, 4eh, 00h, 00h, 4eh, 0fh, 0fh, 00h, 00h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 00h, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 00h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 00h, 0fh, 00h, 0fh, 00h, 00h, 0fh, 00h, 0fh, 00h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 00h, 4eh, 00h, 4eh, 00h, 00h, 4eh, 00h, 4eh, 00h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 00h
			db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h   

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


Nameplayer2 db 'Youssef','$'
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
bombSmall           db 00h, 00h, 00h, 0eh, 2ah, 0eh, 00h, 00h
                    db 00h, 00h, 00h, 00h, 07h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 28h, 28h, 28h, 00h, 00h
                    db 00h, 00h, 28h, 0fh, 28h, 28h, 28h, 00h
                    db 00h, 28h, 28h, 28h, 28h, 28h, 28h, 28h
                    db 00h, 28h, 28h, 28h, 28h, 28h, 28h, 28h
                    db 00h, 00h, 28h, 28h, 28h, 28h, 28h, 00h
                    db 00h, 00h, 00h, 28h, 28h, 28h, 00h, 00h


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

; check if the bomb can be drawn or not and draw it
drawBomb1 proc near
               
               ; if there is a drawn bomb return
               CMP Bomb1Drawn, 1
               JZ tempReturn

               ; check if the place is not in the screen
               CMP Bomb1X, 0
               JL tempReturn
               CMP Bomb1X, 300
               JG tempReturn
               CMP Bomb1Y, 0
               JL tempReturn
               CMP Bomb1Y, 120
               JG tempReturn

               ; check for any wall
               mov si, -2
               mov ax, Bomb1X
               mov bx, Bomb1Y
          LoopWalls:
               add si, 2
               CMP si, WallsNo*2
               JZ nextCheck
               CMP ax, WallsX[si]
               JNZ LoopWalls
               CMP bx, WallsY[si]
               JZ tempReturn
               JMP LoopWalls
               
               ; check for players
          nextCheck:
               CMP ax, player1x
               JNZ Check3
               CMP bx, player1y
               JZ tempReturn

                    
          Check3:
               CMP ax, player2x
               JNZ Draw5
               CMP bx, Player2Y
               JZ tempReturn
               JMP Draw5

          tempReturn:
               JMP toReturn3

               ; draw the bomb     
          Draw5:    
               mov Bomb1Drawn, 1
               mov di,offset bombColors    
               mov cx, Bomb1X
               mov dx, Bomb1Y
               mov bx, OBJECT_SIZE
               nxtline2:
               line2:
               mov al, [di]
               inc di
               mov ah,0ch
               int 10h
               inc cx
               push bx
               mov bx, Bomb1X
               add bx,OBJECT_SIZE
               cmp cx,bx
               pop bx
               jnz line2
               inc dx
               mov cx,Bomb1X
               dec bx
               and bx,bx
               jnz nxtline2

          toReturn3:  
               ret
drawBomb1 endp

; similar to the above one but for the second player bomb
drawBomb2 proc near
               
               ; if there is a drawn bomb return
               CMP Bomb2Drawn, 1
               JZ tempReturn2
               
                ; check if the place is not in the screen
               CMP Bomb2X, 0
               JL tempReturn2
               CMP Bomb2X, 300
               JG tempReturn2
               CMP Bomb2Y, 0
               JL tempReturn2
               CMP Bomb2Y, 120
               JG tempReturn2

               ; check for any wall
               mov si, -2
               mov ax, Bomb2X
               mov bx, Bomb2Y
          LoopWalls2:
               add si, 2
               CMP si, WallsNo*2
               JZ nextCheck2
               CMP ax, WallsX[si]
               JNZ LoopWalls2
               CMP bx, WallsY[si]
               JZ tempReturn2
               
               JMP LoopWalls2
          
               ; check for players
          nextCheck2:
               CMP ax, player1x
               JNZ Check2
               CMP bx, player1y
               JZ toReturn4
          Check2:
               CMP ax, player2x
               JNZ Draw6
               CMP bx, Player2Y
               JZ tempReturn2
               JMP Draw6

          tempReturn2:
               JMP toReturn4

               ; draw the bomb     
          Draw6:     
               mov Bomb2Drawn, 1
               mov di,offset bombColors    
               mov cx, Bomb2X
               mov dx, Bomb2Y
               mov bx, OBJECT_SIZE
               nxtline100:
               line100:
               mov al, [di]
               inc di
               mov ah,0ch
               int 10h
               inc cx
               push bx
               mov bx, Bomb2X
               add bx,OBJECT_SIZE
               cmp cx,bx
               pop bx
               jnz line100
               inc dx
               mov cx,Bomb2X
               dec bx
               and bx,bx
               jnz nxtline100

          toReturn4:  
               ret
drawBomb2 endp


;--------------------------------------------------

drawBonus1          proc FAR
               mov di,offset bonus1Colors    
               mov cx,xBonus
               mov dx,yBonus
               mov bx,OBJECT_SIZE
               nxtline3:
               line3:
               mov al,[di]
               inc di
               mov ah,0ch
               int 10h
               inc cx
               push bx
               mov bx,xBonus
               add bx,OBJECT_SIZE
               cmp cx,bx
               pop bx
               jnz line3
               inc dx
               mov cx,xBonus
               dec bx
               and bx,bx
               jnz nxtline3

               ret
drawBonus1 endp    


;--------------------------------------------------


drawBonus2          proc FAR
                    mov di,offset bonus2Colors    
                    mov cx,xBonus
                    mov dx,yBonus
                    mov bx,OBJECT_SIZE
                    nxtline4:
                    line4:
                    mov al,[di]
                    inc di
                    mov ah,0ch
                    int 10h
                    inc cx
                    push bx
                    mov bx,xBonus
                    add bx,OBJECT_SIZE
                    cmp cx,bx
                    pop bx
                    jnz line4
                    inc dx
                    mov cx,xBonus
                    dec bx
                    and bx,bx
                    jnz nxtline4
                    ret
drawBonus2 endp    

drawBonus3          proc FAR
                    mov di,offset bonus3    
                    mov cx,xBonus
                    mov dx,yBonus
                    mov bx,OBJECT_SIZE
                    nxtlinea:
                    linea:
                    mov al,[di]
                    inc di
                    mov ah,0ch
                    int 10h
                    inc cx
                    push bx
                    mov bx,xBonus
                    add bx,OBJECT_SIZE
                    cmp cx,bx
                    pop bx
                    jnz linea
                    inc dx
                    mov cx,xBonus
                    dec bx
                    and bx,bx
                    jnz nxtlinea
                    ret
drawBonus3 endp    


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
checkNoMan proc far
      mov dx,xStandMan
      mov cx,yStandMan
      ;check direction of movement 
      cmp checkDir,0
        JE isManUp
      cmp checkDir,1
        JE isManDown
      cmp checkDir,2
        JE isManLeft
      cmp checkDir,3
        JE isManRight   
    isManUp:
      ;check if both at same column 
      cmp xMovingMan,dx
          ;if not, no player above 
          JNE endNoMan
      ;else check if when it moves up it will be over another player 
      mov bx,yMovingMan
      sub bx,OBJECT_SIZE
      cmp bx,yStandMan 
          ;if yes then there is a player above him, return 
          JE endYesMan
      jmp endNoMan 
    isManDown:
      ;check if both at same column
      cmp xMovingMan,dx
          JNE endNoMan 
          ;else check if when it moves down it will be over another player
      mov bx,yMovingMan
      add bx,OBJECT_SIZE
      cmp bx,yStandMan 
           ;if yes then there is a player below him, return
          JE endYesMan
      jmp endNoMan 
    ;same concept for moving left and right 
    isManRight:
      cmp yMovingMan,cx
          JNE endNoMan
      mov bx,xMovingMan
      add bx,OBJECT_SIZE
      cmp bx,xStandMan
          JE endYesMan
      jmp endNoMan        
    isManLeft:
      cmp yMovingMan,cx
          JNE endNoMan
      mov bx,xMovingMan
      sub bx,OBJECT_SIZE
      cmp bx,xStandMan
          JE endYesMan
      jmp endNoMan         
  endNoMan:
      ;noMan=1 means there is no man so i can move
      mov NoMan,1
      ret
  endYesMan:
      ;noMan=0 means there is a man so i can't move 
      mov NoMan,0         
      ret
checkNoMan endp 

seeCanMove1 proc far
        ;check the direction of movment and act proparly
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
         ;same concep as checking for a man but loops on walls position instead
         mov dx,xMovingMan
         cmp dx,wallsx[bx]
         JNE getNextU
         mov dx,yMovingMan
         sub dx,OBJECT_SIZE
         cmp dx,wallsy[bx]
         JE  returnCanTMove
        getnextU: 
         add bx,2
         cmp bx,48                        
         JB checkwallU
    ;check cam move down
    checkwallD:
         mov dx,xMovingMan
         cmp dx,wallsx[bx]
         JNE getNextD
         mov dx,yMovingMan
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
         mov dx,xMovingMan
         sub dx,OBJECT_SIZE
         cmp dx,wallsx[bx]
         JNE getNextL
         mov dx,yMovingMan  
         cmp dx,wallsy[bx]
         JE returnCanTMove
        getnextL: 
         add bx,2
         cmp bx,48                        
         JB checkwallL
       jmp returnCanMove
    ;check can move Right
       checkwallR:
         mov dx,xMovingMan
         add dx,OBJECT_SIZE
         cmp dx,wallsx[bx]
         JNE getNextR
         mov dx,yMovingMan  
         cmp dx,wallsy[bx]
         JE returnCanTMove
        getnextR: 
         add bx,2
         cmp bx,48                        
         JB checkwallR  
       jmp returnCanMove
      ;set NoWall to 0 means there is a wall you can't move               
      returnCanTMove:
        Mov NoWall,0
        jmp goToEnd
      ;set NoWall to 1 means there is Not a wall, you can move   
      returnCanMove:   
        MOV NoWall,1
      goToEnd:
        call checkNoMan
        ret
seeCanMove1 endp   
movePlayer2 proc far 
        push bx
        ;claim moving is player 2 
        Mov bx,player2x
        Mov xMovingMan,bx
        Mov bx,player2y
        Mov yMovingMan,bx 
        ;claim standing is player 1 
        Mov bx,player1x
        Mov xStandMan,bx
        Mov bx,player1y
        Mov yStandMan,bx
        pop bx
        ;check direction of movement 
        CMP keyAscii,77h
        JE  moveUp2
        CMP keyAscii,73h
        JE  moveDown2 
        CMP keyAscii,64h
        JE  moveRight2
        CMP keyAscii,61h
        JE  moveLeft2  
        ;then one doesn't move prepare two to be cleared 
        JMP endPlayer2Proc
   moveUp2:
        ;check if top edge
        CMP  Player2Y,0
        JZ   toReturn2 
        ;check if new position is inside a wall 
        mov  checkdir,0
        call seeCanMove1  ;check if there is a wall or a man
        cmp  NoWall,0
        JE   toReturn2
        cmp  NoMan,0
        JE   toReturn2
        ;else move
        SUB Player2Y, OBJECT_SIZE
        JMP endPlayer2Moved
   moveDown2:
        ;check if down edge 
        CMP Player2Y, 120
        JZ  endPlayer2Proc
        ;check if new position is inside a wall  or a man
        mov checkdir,1
        call seeCanMove1
        cmp NoWall,0
        JE endPlayer2Proc
        cmp NoMan,0
        JE  endPlayer2Proc    
        ;else move
        ADD Player2Y,OBJECT_SIZE 
        JMP endPlayer2Moved
   toReturn2:
        jmp endPlayer2Proc
   moveRight2:
        ;check if right edge  
        CMP Player2X, 300
        JZ endPlayer2Proc
        ;check if new position is inside a wall or a man
        mov checkdir,3
        call seeCanMove1
        cmp NoWall,0
        JE endPlayer2Proc
        cmp NoMan,0
        JE  endPlayer2Proc
        ;else move
        ADD Player2X, OBJECT_SIZE      
        JMP endPlayer2Moved
   moveLeft2:
        ;check if left edge
        CMP Player2X, 0
        JZ endPlayer2Proc
        ;check if new position is inside a wall   or a man
        mov checkdir,2
        call seeCanMove1
        cmp NoWall,0
        JE endPlayer2Proc
        cmp NoMan,0
        JE  endPlayer2Proc
        sub Player2X, OBJECT_SIZE      
        JMP endPlayer2Moved
        ;else move
  endPlayer2Proc:
    mov playerMoved,0      
    ret
  endPlayer2Moved:
    Mov playerMoved,1  
     ret       
movePlayer2 endp 
movePlayer1 proc far
        push bx
        ;claim moving is player 1 
        Mov bx,player1x
        Mov xMovingMan,bx
        Mov bx,player1y
        Mov yMovingMan,bx 
        ;claim standing is player 2 
        Mov bx,player2x
        Mov xStandMan,bx
        Mov bx,player2y
        Mov yStandMan,bx
        pop bx
        ;check direction of movement 
        CMP KeyScancode,48h
        JE  moveUp
        CMP KeyScancode,50h
        JE  moveDown 
        CMP KeyScancode,4dh
        JE  moveRight
        CMP KeyScancode,4bh
        JE  moveLeft  
        ;then one doesn't move prepare two to be cleared 
        JMP endPlayer1Proc
   moveUp:
        ;check if top edge
        CMP  Player1Y, 0
        JZ   toReturn 
        ;check if new position is inside a wall 
        mov  checkdir,0
        call seeCanMove1  ;check if there is a wall or a man
        cmp  NoWall,0
        JE   toReturn
        cmp  NoMan,0
        JE   toReturn
        ;else move
        SUB Player1Y, OBJECT_SIZE
        JMP endPlayerOneMoved
   moveDown:
        ;check if down edge 
        CMP Player1Y, 120
        JZ  endPlayer1Proc
        ;check if new position is inside a wall  or a man
        mov checkdir,1
        call seeCanMove1
        cmp NoWall,0
        JE  toReturn
        cmp NoMan,0
        JE  toReturn    
        ;else move
        ADD Player1Y, OBJECT_SIZE 
        JMP endPlayerOneMoved
   moveRight:
        ;check if right edge  
        CMP Player1X, 300
        JZ endPlayer1Proc
        ;check if new position is inside a wall or a man
        mov checkdir,3
        call seeCanMove1
        cmp NoWall,0
        JE endPlayer1Proc
        cmp NoMan,0
        JE  endPlayer1Proc
        ;else move
        ADD Player1X, OBJECT_SIZE      
        JMP endPlayerOneMoved 
   toReturn:
        jmp endPlayer1Proc
   moveLeft:
        ;check if left edge
        CMP Player1X, 0
        JZ endPlayer1Proc
        ;check if new position is inside a wall   or a man
        mov checkdir,2
        call seeCanMove1
        cmp NoWall,0
        JE endPlayer1Proc
        cmp NoMan,0
        JE  endPlayer1Proc
        sub Player1X, OBJECT_SIZE      
        JMP endPlayerOneMoved
        ;else move
  endPlayer1Proc:
    mov playerMoved,0      
    ret
  endPlayerOneMoved:
    Mov playerMoved,1
    ret  
movePlayer1 endp 

moveMan             PROC FAR 
        ;see if move player one 
        push bx
        MOV  bX, Player1X
        MOV  ClearX, bX
        MOV  bX, Player1Y
        MOV  ClearY, bX
        pop bx
        call movePlayer1
        cmp playerMoved,1
        JNE callPlayer2ToMove   ; player can't move check the other one   
        jmp draw4
        ;see if move player one
   callPlayer2ToMove:
        push bx
        MOV  bX, Player2X
        MOV  ClearX, bX
        MOV  bX, Player2Y
        MOV  ClearY, bX
        pop bx
        call movePlayer2 
        cmp playerMoved,1
        JNE endMoveMan      ; player can't move too
        jmp draw4_2               
   draw4:
        CALL ClearBlock
        CALL DrawPlayer1
        ret
   draw4_2:
        CALL ClearBlock
        CALL DrawPlayer2             
   endMoveMan:
        ret    
moveMan ENDP  

keyPressed proc far    
          mov ah,0
          int 16h
          mov KeyScancode,ah
          mov keyAscii,al
          CMP keyAscii, 54        ;if the key is 6
          JNZ next    
               mov cx, Player1X
               mov dx, Player1Y
               add cx, 20
               MOV Bomb1X, cx
               MOV Bomb1Y, dx
               CALL drawBomb1
               JMP endProc
          next:
          CMP keyAscii, 56        ;if the key is 8
          JNZ next2
               mov cx, Player1X
               mov dx, Player1Y
               sub dx, 20
               MOV Bomb1X, cx
               MOV Bomb1Y, dx
               CALL drawBomb1
               JMP endProc
          next2:
          CMP keyAscii, 52        ;if the key is 4
          JNZ next3
               mov cx, Player1X
               mov dx, Player1Y
               sub cx, 20
               MOV Bomb1X, cx
               MOV Bomb1Y, dx
               CALL drawBomb1
               JMP endProc
          next3:
          CMP keyAscii, 50        ;if the key is 2
          JNZ next4
               mov cx, Player1X
               mov dx, Player1Y
               add dx, 20
               MOV Bomb1X, cx
               MOV Bomb1Y, dx
               CALL drawBomb1
               JMP endProc
          

          next4:
          CMP keyAscii, 104        ;if the key is h
          JNZ next5
               mov cx, Player2X
               mov dx, Player2Y
               add cx, 20
               MOV Bomb2X, cx
               MOV Bomb2Y, dx
               CALL drawBomb2
               JMP endProc
          next5:
          CMP keyAscii, 116       ;if the key is t
          JNZ next6
               mov cx, Player2X
               mov dx, Player2Y
               sub dx, 20
               MOV Bomb2X, cx
               MOV Bomb2Y, dx
               CALL drawBomb2
               JMP endProc
          next6:
          CMP keyAscii, 102       ;if the key is f
          JNZ next7
               mov cx, Player2X
               mov dx, Player2Y
               sub cx, 20
               MOV Bomb2X, cx
               MOV Bomb2Y, dx
               CALL drawBomb2
               JMP endProc
          next7:
          CMP keyAscii, 103       ;if the key is g
          JNZ next8
               mov cx, Player2X
               mov dx, Player2Y
               add dx, 20
               MOV Bomb2X, cx
               MOV Bomb2Y, dx
               CALL drawBomb2
               JMP endProc
          next8:
          CMP KeyScancode, 62        ;if the key is F4
          JNZ next9
               MOV AH,4CH 
               INT 21H
          next9:
          call moveMan          
     endProc:
          ret      
keyPressed endp

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
