
;Bruno e David - Semestre 2024/1 - Engenharia Elétrica/Computação - UFES
;------------------------------------------------------------------------------------------------
segment code
_start:
    MOV     AX,data			;Inicializa os registradores
	MOV 	DS,AX
	MOV 	AX,stack
	MOV 	SS,AX
	MOV 	SP,stacktop

; Salvar modo corrente de video(vendo como esta o modo de video da maquina)
	MOV  	AH,0Fh
	INT  	10h
	MOV  	[modo_anterior],AL   

; Alterar modo de video para grafico 640x480 16 cores
	MOV     AL,12h
	MOV     AH,0
	INT     10h

	CALL 	init_structure
inicio:
; Desenha_estruturas
	CALL 	init_block
	CALL 	init_platform
	CALL 	init_ball

; Inicia jogo
InicioPause:
	CALL 	write_init
	MOV		AH, 08h     ; Ler caracter da STDIN
	INT		21H

	CMP		AL, 13     ; Verifica se Enter foi pessionada. Se foi, inicia/despausa o jogo.
	JE		continue
	CMP		AL, 112     ; Verifica se p foi pessionada. Se foi, inicia/despausa o jogo.
	JE		continue
	CMP		AL, 'q'     ; Verifica se q foi pressionada. Se foi, encerra o jogo
	JNE		InicioPause
	JMP		end

continue:
	CALL arase		; apaga a mensagem inicial
game:
    MOV 	AH, 0bh
    INT 	21h         	; Le buffer de teclado
    
	CMP 	AL, 0         	; Se AL =0 nada foi digitado. Se AL =255 então há algum caracter na STDIN
    JNE 	ler_entradas

segue:
	MOV		AX, 0C00h
	INT 	21h 			; clean buff

	CALL 	draw_ball ; desenha esfera
    CALL	delay
	CMP		BYTE [over], 0		; checa se foi game over
	JNE		restart
	CMP		BYTE [vitoria], 0	; checa se foi vitoria
	JNE		game
	JMP 	fim_vitoria

; Função para ler a entrada do usuário
ler_entradas:
    MOV		AH, 08H     ; Ler caracter da STDIN
	INT		21H

	CMP		AL, 'p'	    ; Verifica se foi 'p'. Se foi, pausa o programa
	JE		InicioPause
	
    CMP		AL, 'd'				;Verifica se é a tecla 'd' (para direita)
	JE		platform_direita
  
    CMP		AL, 'a'				  ; Verifica se é a tecla 'a' (para esquerda)
	JE 		platform_esquerda
	
	CMP		AL, 'q'     ; Verifica se foi 'q'. Se foi, finaliza o programa
	JNE		segue
	JMP 	end


platform_direita:
	MOV 	byte[direcao_plataforma], 1
	CALL 	mover_plataforma
	JMP 	segue

platform_esquerda:
	MOV 	byte[direcao_plataforma], 0
	CALL 	mover_plataforma
	JMP 	segue

delay:
    PUSH	CX
    MOV		CX, velocidade
del2:
    PUSH 	CX         ; Coloca CX na pilha para usa-lo em outro loop
    MOV 	CX, 0800h     ; Teste modificando este valor
del1:
    LOOP	del1         ; No loop del1, CX é decrementado até que volte a ser zero
    POP 	CX             ; Recupera CX da pilha
    LOOP 	del2         ; No loop del2, CX é decrementado até que seja zero
    POP 	CX
	RET

fim_vitoria:
	CALL 	write_game_win		; escreve mensagem de vitoria
	JMP		Ler_S_ou_N
restart:
	CALL	write_game_over		; escreve mensagem de game over
Ler_S_ou_N:
	MOV		AH, 08H     ; Ler caracter da STDIN
	INT		21H

	CMP		AL, 'n'     ; Verifica se foi 'n'. Se foi, finaliza o programa
	JE		end

	CMP		AL, 'q'	    ; Verifica se foi 'q'. Se foi, encerra o jogo
	JE		end

	CMP		AL, 's'	    ; Verifica se foi 's'. Se foi, reinicia o jogo
	JE		reset_valores
	
	JMP		Ler_S_ou_N

end:		; encerra_programa
	MOV  	AH, 0   						; set video mode
	MOV  	AL, [modo_anterior]   		; modo anterior
	INT  	10h

	MOV     AX, 4c00h
	INT     21h

;Renicia todas as variáveis para jogar novamente ou passar de fase
reset_valores:

	MOV		byte[cor], 0    ; preto
	MOV     AX, [x]
	PUSH    AX
	MOV     AX, [y]
	PUSH    AX
	MOV     AX, raio
	PUSH    AX
	CALL    full_circle

	MOV		byte[cor], 0
	MOV		AX, [plataforma_x1]
	PUSH	AX
	MOV		AX, [plataforma_y1]
	PUSH	AX
	MOV		AX, [plataforma_x2]
	PUSH	AX
	MOV		AX, [plataforma_y2]
	PUSH	AX
	CALL	draw_block

    MOV 	WORD[plataforma_x1], 264
    MOV 	WORD[plataforma_x2], 374
    MOV 	BYTE[direcao_plataforma], 1

    MOV 	WORD[x], 320
    MOV 	WORD[y], 70    
    MOV 	BYTE[direction_y], 1	            

	MOV		WORD[linha], 0
	MOV 	WORD[coluna], 0
	MOV 	WORD[deltaY], 0
	MOV 	WORD[deltaX], 0

	CMP 	BYTE [vitoria], 0
	JNE		minLinhas
	CMP		BYTE [NLinhasblocos], 4
	JE		maxLinhas

	INC 	BYTE [NLinhasblocos]
	JMP		maxLinhas
minLinhas:
	MOV		BYTE [NLinhasblocos], 1
maxLinhas:
		
	CMP		BYTE[over], 1
	JNE		blocos_limpos
	MOV 	WORD[step], 10
	; APAGA BLOCOS RESTANTES
	MOV 	AX, 10
	PUSH	AX
	MOV 	AX, 427
	PUSH	AX
	MOV 	AX, 630
	PUSH	AX
	MOV 	AX, 355
	PUSH	AX
	MOV		byte [cor], 0
	CALL 	draw_block
blocos_limpos:
	ADD 	WORD[step], 4
	MOV		BYTE[over], 0
	MOV 	SP,stacktop
    JMP 	inicio				

;*******************************************************************

%include "asm/data.asm"

;*************************************************************************
segment stack stack
	DW 		1125
stacktop:

