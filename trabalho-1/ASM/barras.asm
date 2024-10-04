;-----------------------------------------------------------------------------
;    funções init
; cor definida na variavel cor					  
global init_structure
extern line, full_circle, cursor, caracter, cor, mens

init_structure:	; desenha_estrutura
	
	; Salvando o contexto, empilhando registradores		
	PUSHF
	PUSH 	AX
	PUSH 	BX
	PUSH	CX
	PUSH	DX

	; esfera esquerda
	MOV     byte[cor], 4 		; vermelho	
	MOV     AX, 254
	PUSH    AX
	MOV     AX, 471
	PUSH    AX
	MOV     AX, 7
	PUSH    AX
	CALL    full_circle
	
	; esfera direita
	MOV     byte[cor], 4 		; vermelho 	
	MOV     AX, 385
	PUSH    AX
	MOV     AX, 471
	PUSH    AX
	MOV     AX, 7
	PUSH    AX
	CALL    full_circle
	
	; top
	MOV     byte[cor], 7 		; branco    
	MOV		AX, 0
	PUSH    AX
	MOV     AX, 463
	PUSH    AX
	MOV     AX, 639
	PUSH    AX
	MOV     AX, 463
	PUSH    AX
	call    line
	
	; left
	MOV		byte[cor], 7 		; branco    
	MOV     AX, 0
	PUSH    AX
	MOV     AX, 0
	PUSH    AX
	MOV     AX, 0
	PUSH    AX
	MOV     AX, 479
	PUSH    AX
	call    line
	
	; right
	MOV		byte[cor], 7 		; branco    
	MOV     AX, 639
	PUSH    AX
	MOV     AX, 0
	PUSH    AX
	MOV     AX, 639
	PUSH    AX
	MOV     AX, 479
	PUSH    AX
	CALL    line

; escrever palavra
	MOV     CX, 9            	; namero de caracteres
	MOV     BX, 0
	MOV     DH, 0            	; linha 0-29
	MOV     DL, 35           	; coluna 0-79
	MOV		byte[cor], 12 		; rosa
lpMens:
	CALL    cursor
	MOV     AL, [BX+mens]
	CALL    caracter
	INC     BX            		; proximo caracter
	INC     DL            		; avanca a coluna
	LOOP    lpMens

	POP		DX
	POP		CX
	POP		BX
	POP		AX
	POPF
	RET