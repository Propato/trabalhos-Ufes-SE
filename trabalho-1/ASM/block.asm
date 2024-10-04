;-----------------------------------------------------------------------------
;    funções init_block, draw_block
; cor definida na variavel cor					  
global init_block, contato_blocos, draw_block
extern line, cor, x, y, raio, direction_x, direction_y, NLinhasblocos, blocos, blocos_enable, vitoria

init_block:	; desenha_blocos

    ;Salvando o contexto, empilhando registradores		
    PUSHF
    PUSH 	AX
    PUSH 	BX
    PUSH	CX
    PUSH	DX
    PUSH	DI
	PUSH 	SI

	MOV		AL, 6					; Numero de blocos por linha
	MUL		BYTE [NLinhasblocos]

	MOV		CX, AX
	MOV		SI, 0
	MOV		BYTE [vitoria], CL

lpInitEnables:
	MOV		BYTE [blocos_enable+SI], 1
	INC		SI
	LOOP	lpInitEnables

	MOV		AH, 4
	MUL		AH
	MOV		SI, AX				; NA SEQUENCIA NA VARIAVEL blocos, OS ULTIMOS BYTES SAO OS VALORES DOS PRIMEIROS BLOCOS

	XOR		CX, CX
	ADD	    CL, BYTE[NLinhasblocos]		; NUMERO DE LINHAS PASSA PARA CX
	
	MOV	    BX, 453					; Y1, VARIA CONFORME A LINHA
	MOV	    DI, 435					; Y2, VARIA CONFORME A LINHA
	MOV     byte[cor], 2    		; verde

lpLinhaBlocos:
	PUSH	CX
	MOV     CX, 6					; 6 COLUNAS

	MOV     AX, 10					; X1, VARIA CONFORME A COLUNA
	MOV     DX, 105					; X2, VARIA CONFORME A COLUNA 

lpBlocos:
	; ARMAZENA PONTO ESQUERDO INFERIOR DO BLOCO
	SUB		SI, 2
	MOV		WORD[blocos+SI], DI		; Y1
	SUB		SI, 2
	MOV		WORD[blocos+SI], AX		; X1

	PUSH	AX
	PUSH	BX
	PUSH	DX
	PUSH	DI
	CALL	draw_block
	
	ADD	    AX, 105
	ADD	    DX, 105
	INC	    byte[cor]
	LOOP	lpBlocos

	POP	    CX
	SUB	    BX, 26
	SUB	    DI, 26

	LOOP    lpLinhaBlocos

	POP 	SI
	POP		DI
	POP		DX
	POP		CX
	POP		BX
	POP		AX
	POPF
	RET

contato_blocos:
	PUSH	BX
	PUSH	CX
	PUSH	SI
	PUSH	DI

; função de contato da esfera com os blocos
	MOV		AX, WORD [blocos+2]
	SUB		AX, raio
	CMP		WORD [y], AX
	JAE		contContato
	JMP		ret_contato
contContato:
	MOV		AL, 6					; Numero de blocos por linha
	MUL		BYTE [NLinhasblocos]	
	MOV		CX, AX					; CX = AX = N BLOCOS TOTAIS
	MOV		SI, 0					; ENABLE DO BLOCO
	MOV		DI, 0					; X1 E Y2 DO BLOCO (PONTO ESQUERDO INFERIOR)

lpBlocosCheck:
	CMP		BYTE [blocos_enable+SI], 1
	JE		vertical
	JMP		next_block
vertical:
	MOV		AX, WORD [blocos+DI]
	MOV		BX, WORD [blocos+DI+2]

;	contato por baixo ou por cima
	CMP 	WORD [x], AX
	JB		horizontal
	ADD		AX, 95
	CMP 	WORD [x], AX
	JA		horizontal

	SUB		BX, raio
	CMP 	WORD [y], BX
	JB		horizontal
	ADD		BX, raio
	ADD		BX, 18
	ADD		BX, raio
	CMP 	WORD [y], BX
	JA		horizontal
	
	XOR		BYTE [direction_y], 01h
	JMP		apaga_bloco

;	contato pelos lados
horizontal:
	MOV		AX, WORD [blocos+DI]
	MOV		BX, raio
	SHR		BX, 1
	;MOV		BX, WORD [blocos+DI+2]

	SUB		AX, raio
	CMP 	WORD [x], AX
	JB		next_block
	ADD		AX, raio
	ADD		AX, 95
	ADD		AX, raio
	CMP 	WORD [x], AX
	JA		next_block

	ADD 	BX, WORD [blocos+DI+2]
	ADD 	BX, 18
	CMP 	WORD [y], BX
	JA		next_block
	SUB		BX, 18
	SUB		BX, raio
	CMP 	WORD [y], BX
	JB		next_block

	XOR		BYTE [direction_x], 01h
	JMP		apaga_bloco
	
next_block:
	INC		SI
	ADD		DI, 4
	DEC		CX
	CMP		CX, 0
	JE		ret_contato
	JMP		lpBlocosCheck

apaga_bloco:
	MOV 	BYTE [blocos_enable+SI], 0
	DEC		BYTE [vitoria]

	MOV		AX, WORD [blocos+DI]
	MOV		BX, WORD [blocos+DI+2]

	PUSH	AX
	ADD		BX, 18
	PUSH	BX
	ADD		AX, 95
	PUSH 	AX
	SUB		BX, 18
	PUSH	BX
	MOV		byte [cor], 0
	CALL 	draw_block

ret_contato:
	POP 	DI
	POP		SI
	POP		CX
	POP 	BX
	
	RET

;-----------------------------------------------------------------------------
;
;   função draw_block
;
; PUSH x1; PUSH y1; PUSH x2; PUSH y2; call block;  (x<639, y<479, y1>y2)
draw_block:
    PUSH    BP
    MOV     BP,SP
    PUSHF                        ;coloca os flags na pilha
    PUSH    AX
	PUSH    BX
	PUSH    CX
	PUSH	DX
	PUSH    DI
	PUSH	SI

	CMP		byte[cor], 15
	JB		init_draw
	MOV		BYTE[cor], 2

init_draw:
	MOV     AX,[BP+10]   ; resgata os valores das coordenadas
    MOV     BX,[BP+6]    ; resgata os valores das coordenadas
    MOV     DX,[BP+4]    ; resgata os valores das coordenadas
    MOV     DI,[BP+4]    ; resgata os valores das coordenadas

	MOV     CX, [BP+8]
	SUB     CX, DX

L1:
	PUSH    AX    ;
    PUSH    DI    ;
    PUSH    BX    ;
    PUSH    DI    ;

	CALL    line
	INC 	DI
	LOOP 	L1
	DEC		DI
	
	CMP		byte[cor], 0
	JE 		end_draw_block
	CMP		byte[cor], 1
	JE 		end_draw_block

	MOV		SI, [cor]
	PUSH	SI
	MOV		byte[cor], 7   ; branco 

	; BOTTOM
	PUSH	AX
	PUSH   	DX
	PUSH   	BX
	PUSH 	DX
	CALL 	line
	
	; TOP
	PUSH 	AX
	PUSH 	DI
	PUSH 	BX
	PUSH 	DI
	CALL 	line

	; LEFT
	PUSH 	AX
	PUSH 	DX
	PUSH 	AX
	PUSH 	DI
	CALL 	line

	; RIGHT
	PUSH 	BX
	PUSH 	DX
	PUSH 	BX
	PUSH 	DI
	CALL 	line

	POP		SI
	MOV		[cor], SI
	
end_draw_block:
	POP		SI
	POP     DI
    POP     DX
    POP     CX
    POP     BX
    POP     AX
    POPF
    POP     BP
    RET     8

