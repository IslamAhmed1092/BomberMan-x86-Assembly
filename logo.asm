public DrawLogo

extrn Delay1s:near
.Model compact
.Stack 64
.Data

chickenWidth EQU 120
chickenHeight EQU 120

chickenFilename DB 'f.bin', 0

chickenFilehandle DW ?

chickenData DB chickenWidth*chickenHeight dup(0)

.Code
DrawLogo PROC FAR
    
    MOV AH, 0
    MOV AL, 13h
    INT 10h
	
    CALL OpenFile
    CALL ReadData
	
    LEA BX , chickenData ; BL contains index at the current drawn pixel
	
    MOV CX,95
    MOV DX,50
    MOV AH,0ch
	
; Drawing loop
drawLoop:
    MOV AL,[BX]
    INT 10h 
    INC CX
    INC BX
    CMP CX,chickenWidth+95
JNE drawLoop 
	
    MOV CX ,95
    INC DX
    CMP DX , chickenHeight+50
JNE drawLoop

mov cx,5
delay5s:
call Delay1s
loop delay5s

	
    
    call CloseFile
    
ret    
DrawLogo ENDP




OpenFile PROC 

    ; Open file

    MOV AH, 3Dh
    MOV AL, 0 ; read only
    LEA DX, chickenFilename
    INT 21h
    MOV [chickenFilehandle], AX
    RET

OpenFile ENDP

ReadData PROC

    MOV AH,3Fh
    MOV BX, [chickenFilehandle]
    MOV CX,chickenWidth*chickenHeight ; number of bytes to read
    LEA DX, chickenData
    INT 21h
    RET
ReadData ENDP 


CloseFile PROC
	MOV AH, 3Eh
	MOV BX, [chickenFilehandle]

	INT 21h
	RET
CloseFile ENDP

END 