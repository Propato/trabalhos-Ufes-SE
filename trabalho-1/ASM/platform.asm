;-----------------------------------------------------------------------------
;    funções init_platform e mover_plataforma
; cor definida na variavel cor					  
global init_platform, mover_plataforma
extern draw_block, cor, x, y, raio, direction_x, direction_y, plataforma_x1, plataforma_x2, plataforma_y1, plataforma_y2, direcao_plataforma, step_platform

init_platform:
    ; Salva o contexto, empilhando registradores
    PUSHF
    PUSH    AX
; Desenha a plataforma na posição inicial
	MOV		byte[cor], 1
	MOV		AX, [plataforma_x1]
	PUSH	AX
	MOV		AX, [plataforma_y1]
	PUSH	AX
	MOV		AX, [plataforma_x2]
	PUSH	AX
	MOV		AX, [plataforma_y2]
	PUSH	AX
	CALL	draw_block

	POP		AX
	POPF
	RET

mover_plataforma:
	PUSHF
    PUSH    AX
	PUSH 	BX

	MOV 	BX, step_platform

	CMP 	byte[direcao_plataforma], 1
	JNE 	move_esquerda

	MOV		AX, WORD [plataforma_x2]
	ADD 	AX, BX
	; verificando o limite à direita
	CMP 	AX, 635
	JBE 		Move_direita

	SUB		AX, 635
	SUB		BX, AX
Move_direita:
	MOV		byte [cor], 0	; pinta de preto
	MOV		AX, [plataforma_x1]
	PUSH	AX
	MOV		AX, [plataforma_y1]
	PUSH	AX
	ADD		WORD [plataforma_x1], BX
	MOV		AX, [plataforma_x1]
	PUSH	AX
	MOV		AX, [plataforma_y2]
	PUSH	AX
	CALL 	draw_block
; Desenhando a nova plataforma
	MOV		byte [cor], 1	; pinta de azul
	MOV		AX, [plataforma_x2]
	PUSH	AX
	MOV		AX, [plataforma_y1]
	PUSH	AX
	ADD		WORD [plataforma_x2], BX
	MOV		AX, [plataforma_x2]
	PUSH	AX
	MOV		AX, [plataforma_y2]
	PUSH	AX
	CALL 	draw_block

	JMP fim_mover_plataforma

move_esquerda:
	MOV		AX, WORD [plataforma_x1]
	; verificando o limite à esquerda
	ADD 	BX, 4
	CMP 	AX, BX
	JAE		desenha_esquerda

	SUB		AX, 4
	MOV		BX, AX
desenha_esquerda:
	MOV		byte [cor], 0	; pinta de preto
	MOV		AX, [plataforma_x2]
	PUSH	AX
	MOV		AX, [plataforma_y1]
	PUSH	AX
	SUB		WORD [plataforma_x2], BX
	MOV		AX, [plataforma_x2]
	PUSH	AX
	MOV		AX, [plataforma_y2]
	PUSH	AX
	CALL 	draw_block
; Desenhando a nova plataforma
	MOV		byte [cor], 1	; pinta de azul
	MOV		AX, [plataforma_x1]
	PUSH	AX
	MOV		AX, [plataforma_y1]
	PUSH	AX
	SUB		WORD [plataforma_x1], BX
	MOV		AX, [plataforma_x1]
	PUSH	AX
	MOV		AX, [plataforma_y2]
	PUSH	AX
	CALL 	draw_block

fim_mover_plataforma:
	POP 	BX
	POP 	AX
	POPF
	RET