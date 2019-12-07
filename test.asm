                   .MODEL small                  
;------------------------------------------------------
                    .STACK         
;------------------------------------------------------                    
                    .DATA
canMove db 1 
checkDir db ? ; 0 check up , 1 check down , 2 check left ,3 check right 

;coordinates of bonus and bombs

;bomb of the first player
Bomb1Drawn          db             0     ;a boolean variable to check if the bomb is drawn or not
Bomb1X              dw             20
Bomb1Y              dw             100

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
;--------------------------------------------------------
                    .CODE                                                 
MAIN                PROC FAR
                    MOV AX,@DATA
                    MOV DS,AX
					
					call initProg
                    CALL drawBomb1
                    CALL drawBomb2 
                check:
                    mov ah,1
                    int 16h
                    JMP check
 

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


drawBomb1 proc near
               
               ; if there is a drawn bomb return
               ; CMP Bomb1Drawn, 1
               ; JZ tempReturn

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
               ; CMP Bomb2Drawn, 1
               ; JZ tempReturn2
               
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


END MAIN