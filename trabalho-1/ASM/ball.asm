;-----------------------------------------------------------------------------
;   funções init_ball, move_ball e touch_ball
;   cor definida na variavel cor					  
global init_ball, draw_ball
extern cor, over, raio, step, x, y, direction_x, direction_y, plataforma_x1, plataforma_x2, plataforma_y1, plataforma_y2, full_circle, contato_blocos, draw_block

init_ball:	; Desenha plataforma

    ;Salvando o contexto, empilhando registradores		
    PUSHF
    PUSH 	AX

	; DESENHA ESFERA NA POSICAO INICIAL
	MOV     byte[cor], 4    ; vermelho
	MOV     AX, [x]
	PUSH    AX
	MOV     AX, [y]
	PUSH    AX
	MOV     AX, raio
	PUSH    AX
	CALL    full_circle

	POP		AX
	POPF
	RET

draw_ball:	; desenha esfera

	; Salva o contexto, empilha registradores		
    PUSHF
    PUSH 	AX

	CALL	contato_blocos

	; APAGA ESFERA ANTERIOR
	MOV		byte[cor], 0    ; preto
	MOV     AX, [x]
	PUSH    AX
	MOV     AX, [y]
	PUSH    AX
	MOV     AX, raio
	PUSH    AX
	CALL    full_circle
	
	CALL    next_xy

	; DESENHA ESFERA NA NOVA POSICAO
	MOV		byte[cor], 4    ; vermelho
	MOV     AX, [x]
	PUSH    AX
	MOV     AX, [y]
	PUSH    AX
	MOV     AX, raio
	PUSH    AX
	CALL    full_circle

	POP		AX
	POPF

	RET

; Calcula próxima posição da esfera
next_xy:
	PUSH	DI
	PUSH	SI
	PUSH 	BX

	MOV		DI, 639
	MOV		SI, 462
	SUB		DI, raio	; define limite direito
	SUB		SI, raio	; define limite superior
					; raio é o limite inferior e esquerdo

	MOV 	BX, [step]	;Armazena o passo (step) da esfera em BX
	MOV 	AX, BX
	ADD		AX, raio
	CMP 	BYTE [direction_x], 1
	JNE 	left

;Movimento para a direita
right:
	ADD 	WORD [x], BX
	CMP 	WORD [x], DI
	JBE 	up

	MOV 	BYTE [direction_x], 0
	SUB 	WORD [x], BX

;Movimento para a esquerda
left:
	CMP		WORD [x], AX	
	JBE 	change_to_right

	SUB 	WORD [x], BX
	JMP	 	up

	ADD 	WORD [x], BX
change_to_right:						; Desvia para a direita
	MOV 	BYTE [direction_x], 1
	JMP 	right

;Movimento para cima
up:
	CMP 	BYTE [direction_y], 1
	JNE 	down

	ADD 	WORD [y], BX
	CMP 	WORD [y], SI
	JA 		invertUP
	JMP		return_next_xy
invertUP:
	MOV 	BYTE [direction_y], 0	
	SUB 	WORD [y], BX

;Movimento para baixo
down:
	CMP		WORD [y], AX			;Verifica se ultrapassou o limite inferior
	JAE		notOver
	JMP		game_over			
notOver:
	SUB 	WORD [y], BX			; Caso não tenha atingido o limite inferior, continua descendo
	
	MOV 	AX, [plataforma_y1]
	ADD 	AX, raio				; top da plataforma + raio (para chegar no pixel limite do centro da esfera)
	CMP 	WORD[y], AX				; Compara o limite inferior com o centro da esfera
	JAE		return_next_xy

	JMP 	checkColisao			; CHECA COLISÃO COM A PLATAFORMA

bellow:
	CMP 	WORD [y], raio
	JAE 	return_next_xy

;Renicia o jogo
game_over:
	MOV		BYTE [over], 1
	MOV 	WORD [y], raio

	MOV 	BYTE [cor], 1
	MOV		AX, [plataforma_x1]
	PUSH	AX
	MOV		AX, [plataforma_y1]
	PUSH	AX
	MOV		AX, [plataforma_x2]
	PUSH	AX
	MOV		AX, [plataforma_y2]
	PUSH	AX
	CALL 	draw_block


return_next_xy:						;Retorna para desenhar a plataforma na nova posição
	POP 	BX
	POP 	SI
	POP 	DI
	RET

checkColisao:
	MOV		AX, [plataforma_x2]
	CMP 	WORD[x], AX
	JA 		bellow
	MOV		AX, [plataforma_x1]
	CMP 	WORD[x], AX
	JB 		bellow

	MOV		AX, [plataforma_y2]
	CMP 	WORD[y], AX
	JBE		bellow

	MOV 	BYTE [direction_y], 1
	ADD 	WORD [y], BX

	MOV		AX, BX
	SHR		AX, 1
	ADD 	AX, [plataforma_y1]
	ADD 	AX, raio
	CMP 	WORD[y], AX
	JBE		emCima
	MOV		AX, [plataforma_y1]
	ADD 	AX, raio
	MOV		WORD [y], AX
	JMP 	return_next_xy
emCima:
	ADD 	WORD [y], BX
	JMP 	return_next_xy