global step_platform, plataforma_x1, plataforma_x2, plataforma_y1, plataforma_y2, direcao_plataforma
global x, y, direction_x, direction_y, step, raio 
global cor, over, vitoria, mens, mens_game_win, mens_game_over, velocidade, deltaX, deltaY, NLinhasblocos, blocos, blocos_enable

extern cursor, write_init, write_game_over, arase, mover_plataforma, caracter, init_structure, init_block, init_platform, init_ball, draw_ball, full_circle, draw_block, write_game_win

segment data

cor		db		branco_intenso

;	I R G B COR
;	0 0 0 0 preto
;	0 0 0 1 azul
;	0 0 1 0 verde
;	0 0 1 1 cyan
;	0 1 0 0 vermelho
;	0 1 0 1 magenta
;	0 1 1 0 marrom
;	0 1 1 1 branco
;	1 0 0 0 cinza
;	1 0 0 1 azul claro
;	1 0 1 0 verde claro
;	1 0 1 1 cyan claro
;	1 1 0 0 rosa
;	1 1 0 1 magenta claro
;	1 1 1 0 amarelo
;	1 1 1 1 branco intenso


;Define cores
preto		    equ		0
azul		    equ		1
verde		    equ		2
cyan		    equ		3
vermelho	    equ		4
magenta		    equ		5
marrom		    equ		6
branco		    equ		7
cinza		    equ		8
azul_claro	    equ		9
verde_claro	    equ		10
cyan_claro	    equ		11
rosa		    equ		12
magenta_claro	equ		13
amarelo		    equ		14
branco_intenso	equ		15

;Variáveis
step 		    dw	    14              ; se o step for mt grande, a bolinha pode 'atravessar' os blocos
step_platform   EQU     25
velocidade  	EQU		90	            ; quanto menor, mais rápido
raio		    EQU	    14

plataforma_x1   dw      264
plataforma_y1   dw      45                     ;Comprimento Superior
plataforma_x2   dw      374
plataforma_y2   dw      30                     ;Comprimento Inferior
direcao_plataforma  db  1

over    	    db		0
vitoria         db      0

modo_anterior	db		0
linha		    dw		0
coluna      	dw		0
deltaX      	dw		0
deltaY	    	dw		0

x           	dw      320
y		        dw      70    
direction_x	    db		1
direction_y	    db		1


NLinhasblocos   db      1       ; equivalente a fase
blocos          resw    60      ; 6*5*2 -> NBlocos * MaxNLinhas * NVariaveis (x e y)
blocos_enable   resb    30      ; 6*5   -> NBlocos * MaxNLinhas

;Variáveis para texto
mens    	    db  	'PING PONG   [a] e [d] para mover plataforma[q] para sair e [p] para pausar[Enter] para comecar'     ; size = 12, 31, 31 e 20
mens_game_win  db      '  VitoriaContinuar jogando?s (sim) e n (nao) '     ; size = 9, 18 e 18
mens_game_over  db      'Fim de JogoJogar novamente?s (sim) e n (nao)'     ; size = 11, 16 e 18