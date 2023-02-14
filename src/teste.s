section .data
menos           db      '-'
inteiro         dd      0
inteiro2        dd      0
resultado       dd      0

section .bss
section .text
global _start
_start:
    push    inteiro 
    call    read_int    

    push    inteiro2
    call    read_int

    mov  DWORD   ECX,[inteiro]
    add  DWORD   ECX,[inteiro2]

    mov DWORD   [resultado],ECX

    push    ECX     
    call    write_int
Fim:
    ;return 0
    mov     EAX,1
    mov     EBX,0
    int     80h

; AUXILIAR FUNCTIONS (INPUT/OUTPUT)

; ------------ INT FUNCTIONS ------------

read_int:
    ;cria frame de pilha
    ;Cria 2 espacos pra variavel local
    enter 2,0
    ;registradores utilizados
    push    EBX
    push    ECX
    push    EDX
    ;Contador de -
    mov     ECX,0
    push    ECX       
    ;Contador de chars lidos
    mov     EAX,0
    push    EAX             
LI_leitura:
    ;le um DIGITO do teclado
    mov     EAX,3
    mov     EBX,0
    ;[EBP-2]
    mov     ECX,EBP
    sub     ECX,2
    mov     EDX,1
    int     80h          
    ;verifica se o primeiro DIGITO eh -
    mov     BL,[EBP-2] 
    cmp     BL,0x2D
    je      LI_negativo
    ;chars lidos
    pop     EAX
    inc     EAX
    push    EAX 
    ;verifica se o DIGITO eh enter
    cmp     BL,0x0A
    je      LI_final
    ;subtrai 30 do DIGITO
    sub     BL,0x30
    ;verifica se o DIGITO esta entre 0 e 9, senao termina
    cmp     BL,0
    jb      LI_erro
    cmp     BL,9
    ja      LI_erro
    ;multiplica o INTEIRO por 10
    mov     EDX,[EBP+8]
    mov     EAX,[EDX]
    mov     ECX,10
    mul     ECX    
    ;soma o digito com o INTEIROx10 e armazena no INTEIRO
    add     EBX,EAX
    mov     EAX,[EBP+8]
    mov     [EAX],EBX
    ;le proximo DIGITO
    mov     EAX, EBP
    sub     EAX,2
    inc     BYTE AL
    mov     ECX,EAX     
    pop     EAX
    push    EAX
    cmp     EAX,11 
    jne     LI_leitura
LI_negativo:
    ;chars lidos
    pop     EAX
    ;tratando o sinal de -      
    pop     ECX
    inc     ECX
    push    ECX
    ;chars lidos    
    push    EAX
    mov     EAX,ECX
    and     EAX,1
    cmp     EAX,1
    jne     LI_negativo_par
LI_negativo_impar:
    ;numero impar de -, numero eh negativo
    ; EBP - 1
    mov     EAX,EBP
    dec     EAX
    mov     BYTE [EAX],0x2D  
    jmp     LI_negativo_fim
LI_negativo_par:
    ;numero par de -, numero eh positivo
    mov     EAX,EBP
    dec     EAX
    mov     BYTE [EAX],0
LI_negativo_fim:
    ;fim
    mov     EBX, EBP
    dec     EBX
    ;inc     BYTE [EBP+12] 
    mov     ECX,EBX
    pop     EAX
    push    EAX
    cmp     EAX,11 
    jne     LI_leitura
LI_nega:  
    ;negando o numero se ele for negativo
    mov     EDX,[EBP+8]
    neg     DWORD [EDX]
    ;chars lidos 
    pop     EAX
    ;registradores utilizados
    pop     EDX
    pop     ECX
    pop     EBX
    ;limpa frame de pilha
    ;mov     ESP,EBP
    ;pop     EBP
    
    leave
    ret     
LI_erro:
LI_final: 
    ;ve se o numero eh negativo
    mov     AL,[EBP-1]  ; flag negativo     
    cmp     AL,0x2D  
    je      LI_nega
    ;chars lidos 
    pop     EAX    
    ;registradores utilizados
    pop     EDX
    pop     ECX
    pop     EBX
    ;limpa frame de pilha
    ;mov     ESP,EBP
    ;pop     EBP
    
    leave
    ret       
    
    %define VALOR  DWORD [EBP-16]
    %define DIGITO BYTE  [EBP-1]
    %define STRING BYTE  [EBP-12]
write_int:
    ;cria frame de pilha
    ;push    EBP
    ;mov     EBP,ESP
    ;Cria 3 variaveis locai
    enter 16,0
    ;registradores utilizados
    push    EBX
    push    ECX
    push    EDX
    
    ; Valor = Inteiro
    mov EDX, [EBP+8]
    mov EDX, [EDX]
    mov DWORD VALOR,EDX
    ;imprime o -, se existir    
    mov     EAX,[EBP+8]
    mov     EAX,[EAX]
    and     EAX,0x80000000
    cmp     EAX,0x80000000
    jne     EI_inicio
EI_menos:    
    neg     DWORD VALOR
    mov     EAX,4
    mov     EBX,1
    mov     ECX,menos
    mov     EDX,1
    int     80h
EI_inicio:    
    ;ECX = i = 0
    xor     ECX,ECX
EI_string:
    ;Valor = (int) (Valor / 10);
    ;str[i] = (char)((Valor % 10) + 0x30);
    xor     EDX,EDX
    mov     EAX,VALOR
    mov     EBX,10
    div     EBX
    ;EAX = Valor
    mov     VALOR,EAX
    ;EDX = str[i]
    ; Digito = EBP-1
    mov     EBX,EBP
    sub     EBX, 1
    mov     [EBX],EDX
    add     BYTE [EBX],0x30
    push    ECX
    ;str[i+1] = str[i]    
    jmp     EI_armazena
EI_laco:
    ;i++   
    pop     ECX
    inc     ECX
    ;} while (Valor != 0)
    mov     EAX,VALOR
    cmp     EAX,0
    jne     EI_string
    ;chars impressos
    mov     EAX,ECX
    push    EAX    
    jmp     EI_imprime
EI_armazena:
    ;str[i+1] = str[i] 
    ;string = EBP -12
    mov     EDX,EBP
    sub     EDX,12
    inc     ECX
    mov     EBX,[EBX]
    mov     [EDX+ECX],EBX
    jmp     EI_laco
EI_imprime:
    mov     EDX,EBP
    sub     EDX,12
    add     EDX,ECX
    push    ECX
    ;syscall impressao monitor  
    mov     EAX,4
    mov     EBX,1
    mov     ECX,EDX
    mov     EDX,1
    int     80h
    pop     ECX
    loop    EI_imprime
EI_final:    
    ;conta o -, se existir    
    mov     EAX,[EBP+8]
    mov     EAX,[EAX]
    and     EAX,0x80000000
    cmp     EAX,0x80000000    
    ;chars impressos
    pop     EAX
    jne     EI_nao_conta_menos  
EI_conta_menos:      
    inc     EAX
EI_nao_conta_menos:    
    ;registradores utilizados
    pop     EDX
    pop     ECX
    pop     EBX
    ;limpa frame de pilha
    ;mov     ESP,EBP
    ;pop     EBP
    
    leave
    ret