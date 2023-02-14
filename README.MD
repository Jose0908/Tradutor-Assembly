# Trabalho da Disciplina de Software Básico - UnB 
# Data: 01/01/2023

## Alunos
- José Roberto Interaminense Soares - 190130008
- Camila Frealdo Fraga - 170007561

## Sistema Operacional e Compilador

Como sistema operacional, foi utilizado o Ubuntu 22.04 1 LTS 64 bits

Com a seguinte versão do G++: g++ (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0

## Como compilar o programa?

Para compilar, utilizar a seguinte linha de comando: 

g++ -o montador main.cpp preprocess.cpp auxiliares.cpp macro.cpp objeto.cpp

## Como rodar o programa?
Para rodar o programa, deve-se escrever ./montador <-o> <arquivo.asm>

O programa apresenta três modos de operação: 

- Pre Processamento: **-p**

É gerado arquivo .pre, com a etapa de pre-processamento feita.

- Processamento de macros: **-m**

É gerado arquivo .mcr, com todas as macros resolvidas.

- Saída do arquivo Objeto: **-o**

É gerado arquivo .o, com o arquivo objeto.

