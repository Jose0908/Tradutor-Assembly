# Trabalho da Disciplina de Software Básico - UnB 
# Data: 14/02/2023
## Alunos
- José Roberto Interaminense Soares - 190130008
- Camila Frealdo Fraga - 170007561

## Sistema Operacional e Compilador

Como sistema operacional, foi utilizado o Ubuntu 22.04 1 LTS 64 bits

Com a seguinte versão do G++: g++ (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0

## Como compilar o programa?

Para compilar, utilizar a seguinte linha de comando: 

g++ -o tradutor main.cpp preprocess.cpp auxiliares.cpp tradutor.cpp

## Como rodar o programa?
Para rodar o programa, deve-se escrever ./tradutor <arquivo.asm>
exemplo:
./tradutor  teste.asm

Após este passo, será gerado um arquivo .s, que é a tradução do arquivo.asm.

## Como rodar o programa feito em assembly?

Para rodar, foi utilizado o NASM version 2.15.05, e o GNU ld (GNU Binutils for Ubuntu) 2.38.

O comando é:
nasm -f elf32 <arquivo.s> -o <arquivo.o> && ld -m elf_i386 <arquivo.o> -o <arquivo> && ./<arquivo>
exemplo:
nasm -f elf32 teste.s -o teste.o && ld -m elf_i386 teste.o -o teste && ./teste


## Funcionamento do programa

Basicamente o programa traduz instrução a instrução do assembly inventado para o assembly x86. A dificuldade maior está nas funções de INPUT
e OUTPUT, que comportam inteiros, char e strings. Para tais funções, foram feitas chamadas à outras funções feitas no próprio assembly x86.

As sessões (texto data e bss) foram separadas e tratadas individualmente no arquivo <tradutor.cpp.> Ele basicamente junta as sessões e junta com o
código feito em assembly, guardado no arquivo <funcoes.asm>.

Por fim, a função main lê o arquivo em assembly inventado, faz a sua pré-compilação e traduz para assembly x86.

Diversas bibliotecas foram utilizadas, principalmente a de strings.

