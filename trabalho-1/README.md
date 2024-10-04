# Trabalho 1 - Jogo em Assembly

Este trabalho consiste no jogo de quebrar blocos com uma esfera. Desenvolvido em Assembly no simulador DosBox.

## Arquivos

 O arquivo MAKE.BAT, as pastas e os códigos foram desenvolvidos para este trabalho.

 Os demais arquivos e alguns dos .ASM foram disponibilizados pelo professor para a realização do projeto.

## Controles

- Usa-se `[A]` e `[D]` para mover
- `[P]` e `[Enter]` para iniciar/despausar;
- `[P]` para pause.
- `[Q]` para fechar o jogo.

## Níveis

A cada vitória, passa-se para o próximo nível.

No nível um há apenas uma linha de blocos com uma velocidade lenta. A cada nível seguinte, é aumentado o número de linhas de blocos e o movimento da esfera fica mais rápido.

A partir do nível 4, não há novas linhas mas a velocidade sempre aumenta.

O nível atual é controlado pela variável NLinhasblocos, definida no arquivo data.asm, como os blocos são desenhados dentro de um loop, o loop fará NLinhasblocos iterações. Caso se queira ir para determinado nível sem q precise passar por todas as fazes, basta modificar essa variável (porém, recomendamos o nível máximo de 4 mas o jogo tem segurança para o nível 5 também).

## Executando

Instale o simulador DosBox, disponível em: <a href="https://www.dosbox.com/download.php?main=1">DosBox Download</a>.

E, dentro do simulador, execute os comandos:

```shell
mount C <path>
C:
make
game
```

`mount` e `C:` direcionará o simulador para a pasta com os arquivos.

`make` irá compilar o código binário.

`game` irá rodar o arquivo executavel do jogo.

## Problemas e Soluções

O maior problema era quanto a dinamicidade do jogo, pois com um movimento padrão pré determinado, a bolinha tendia a um movimento padrão simples onde não acertava alguns blocos nunca, uma solução para isso foi, sempre que houver contato com as laterias, a bolinha subir 1 pixel de altura, assim, ocorrendo maior variação e padrão mais complexo nos movimentos.

Outra foi sobre o movimento da esfera e principalmente da plataform. O movimento da bolinha consiste em apagar na posição atual, recalcular a posição com o deslocamento e desenhar novamente a bolinha, já o da plataforma, consiste em apagar a ponta oposta ao movimento e desenhar um pedaço da plataforma no lado a favor do movimento, redesenhando apenas as laterais em vez de toda a plataforma, pois assim o movimento ficou bem mais eficiente e rápido. 

<h6 align="center">by David Propato <a href="https://github.com/Propato">@Propato</a></h6>