;-----------------------------------------------------------------------------
;    funções init_platform e mover_plataforma
; cor definida na variavel cor					  
global write_init, write_game_win, write_game_over, arase
extern cor, mens, mens_game_win, mens_game_over, cursor, caracter, line

write_init:
    PUSHF
    PUSH 	AX
    PUSH 	BX
    PUSH	CX
    PUSH	DX

	MOV		byte[cor], 7 		; branco    
    CALL    empty_block

	MOV		AX, 20
	PUSH	AX
    MOV		AX, 31
	PUSH	AX
	MOV		AX, 31
	PUSH	AX

	; escreve mensagem de inicio
	MOV     CX, 12            	; namero de caracteres
	MOV     BX, 0
	MOV     DH, 11            	; linha 0-29
	MOV     DL, 35           	; coluna 0-79
	MOV		byte[cor], 12 		; rosa
lpMens_Inicio:
	CALL    cursor
	MOV     AL, [BX+mens]
	CALL    caracter
	INC     BX            		; proximo caracter
	INC     DL            		; avanca a coluna
	LOOP    lpMens_Inicio	

	ADD 	DH, 2
	MOV		DL, 24
	POP		CX
	MOV		byte[cor], 7 		; branco

	CMP		DH, 15
	JBE		lpMens_Inicio

	MOV     DL, 30           	; coluna 0-79
	MOV		byte[cor], 12 		; rosa
lpMens_Enter:
	CALL    cursor
	MOV     AL, [BX+mens]
	CALL    caracter
	INC     BX            		; proximo caracter
	INC     DL            		; avanca a coluna
	LOOP    lpMens_Enter
    
    POP     DX
    POP     CX
    POP     BX
    POP     AX
    POPF

    RET

;Apaga mensagem de início
arase:
    PUSHF
    PUSH 	AX
    PUSH 	BX
    PUSH	CX
    PUSH	DX

    MOV		byte[cor], 0 		; preto    
    CALL    empty_block

	MOV		AX, 20
	PUSH	AX
    MOV		AX, 31
	PUSH	AX
	MOV		AX, 31
	PUSH	AX

	MOV		byte[cor], 0 		; preto
	MOV     CX, 12            	; namero de caracteres
	MOV     BX, 0
	MOV     DH, 11            	; linha 0-29
	MOV     DL, 35           	; coluna 0-79
lpMens_Apaga:
	CALL    cursor
	MOV     AL, [BX+mens]
	CALL    caracter
	INC     BX            		; proximo caracter
	INC     DL            		; avanca a coluna
	LOOP    lpMens_Apaga	

	ADD 	DH, 2
	MOV		DL, 24
	POP		CX

	CMP		DH, 15
	JBE		lpMens_Apaga

	MOV     DL, 30           	; coluna 0-79
lpApaga_Enter:
	CALL    cursor
	MOV     AL, [BX+mens]
	CALL    caracter
	INC     BX            		; proximo caracter
	INC     DL            		; avanca a coluna
	LOOP    lpMens_Enter
    
    POP     DX
    POP     CX
    POP     BX
    POP     AX
    POPF

    RET

write_game_win:
    PUSHF
    PUSH 	AX
    PUSH 	BX
    PUSH	CX
    PUSH	DX

    MOV		byte[cor], 7 		; branco    
    CALL    empty_block
    
	; escreve mensagem de Game Over
	MOV     CX, 9            	; namero de caracteres
	MOV     BX, 0
	MOV     DH, 11            	; linha 0-29
	MOV     DL, 35           	; coluna 0-79
	MOV		byte[cor], 12 		; rosa
lpMens_Vitoria_de_Jogo:
	CALL    cursor
	MOV     AL, [BX+mens_game_win]
	CALL    caracter
	INC     BX            		; proximo caracter
	INC     DL            		; avanca a coluna
	LOOP    lpMens_Vitoria_de_Jogo	

	ADD 	DH, 2
	MOV		DL, 32
	MOV		CX, 18
	MOV		byte[cor], 7 		; branco

	CMP		DH, 15
	JBE		lpMens_Vitoria_de_Jogo

    POP     DX
    POP     CX
    POP     BX
    POP     AX
    POPF

    RET

write_game_over:
    PUSHF
    PUSH 	AX
    PUSH 	BX
    PUSH	CX
    PUSH	DX

    MOV		byte[cor], 7 		; branco    
    CALL    empty_block
    
    MOV		AX, 18
	PUSH	AX
	MOV		AX, 16
	PUSH	AX

	; escreve mensagem de Game Over
	MOV     CX, 11            	; namero de caracteres
	MOV     BX, 0
	MOV     DH, 11            	; linha 0-29
	MOV     DL, 35           	; coluna 0-79
	MOV		byte[cor], 12 		; rosa
lpMens_Fim_de_Jogo:
	CALL    cursor
	MOV     AL, [BX+mens_game_over]
	CALL    caracter
	INC     BX            		; proximo caracter
	INC     DL            		; avança a coluna
	LOOP    lpMens_Fim_de_Jogo	

	ADD 	DH, 2
	MOV		DL, 32
	POP		CX
	MOV		byte[cor], 7 		; branco

	CMP		DH, 15
	JBE		lpMens_Fim_de_Jogo

    MOV     DX, CX
    POP     CX
    POP     BX
    POP     AX
    POPF

    RET

;Desenha linhas brancas em volta das mensagens
empty_block:
    ; top
	MOV		AX, 159
	PUSH    AX
	MOV     AX, 319
	PUSH    AX
	MOV     AX, 479
	PUSH    AX
	MOV     AX, 319
	PUSH    AX
	call    line
	
	; left
	MOV     AX, 159
	PUSH    AX
	MOV     AX, 319
	PUSH    AX
	MOV     AX, 159
	PUSH    AX
	MOV     AX, 159
	PUSH    AX
	call    line
	
	; right
	MOV     AX, 479
	PUSH    AX
	MOV     AX, 319
	PUSH    AX
	MOV     AX, 479
	PUSH    AX
	MOV     AX, 159
	PUSH    AX
	CALL    line

    ; bottom
	MOV		AX, 159
	PUSH    AX
	MOV     AX, 159
	PUSH    AX
	MOV     AX, 479
	PUSH    AX
	MOV     AX, 159
	PUSH    AX
	call    line

    RET
