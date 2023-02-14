section .bss
inteiro:         resd      1
inteiro2:        resd      1
resultado:       resd      1

section .data
menos:          db      '-'

section .text
global _start
_start:
    push    inteiro             ; inteiro = read_int()
    call    read_int    
    mov     edx, [inteiro]

    mov     [resultado],edx

    push    inteiro2
    call    read_int
    mov     edx, [inteiro2]


    add    [resultado],edx

    push    resultado
    call    write_int
Fim:
    ;return 0
    mov     EAX,1
    mov     EBX,0
    int     80h


; AUXILIAR FUNCTIONS (INPUT/OUTPUT)

; ------------ INT FUNCTIONS ------------

read_int:
    enter   2,0                     ;Cria um espaço para armazenar char lido e um para flag de negativo
    push    EBX                     ;Registradores Utilizados (EAX = return) 
    push    ECX
    push    EDX  
    mov     EAX,0                   ;Contador de digitos lidos
    push    EAX             
read_digit:                       
    mov     EAX,3                   ;Leitura syscall: EAX = 3, EBX = 0, ECX = endereço, EDX = Tamanho (1)
    mov     EBX,0
    mov     ECX,EBP                 ;Quero guardar digito em EBP-1 (reservei com enter)
    dec     ECX                
    mov     EDX,1
    int     80h          
    mov     BL,[EBP-1]              ;Verifico se é negativo
    cmp     BL,45                   ;45 = '-'            
    je      read_negative
    ;chars lidos
    pop     EAX             
    inc     EAX
    push    EAX                     ; conta char ++
    cmp     BL,0x0A                 ; Verifico se é enter: 0x0A = ENTER
    je      FIM                     ; Se for enter, fim  
    sub     BL,0x30                 ; Se não for enter, converte para int
    mov     EDX,[EBP+8]     ; EDX = ENDEREÇO PRA INTEIRO
    mov     EAX,[EDX]       ; EAX = INTEIRO
    mov     ECX,10          ; ECX = 10
    mul     ECX             ; EAX = ECX * EAX = 10*INTEIRO
    ;soma o digito com o INTEIROx10 e armazena no INTEIRO
    add     EBX,EAX         ; EBX = INTEIRO * 10 + DIGITO
    mov     EAX,[EBP+8]     ; EAX = ENDEREÇO PRA INTEIRO
    mov     [EAX],EBX       ; INTEIRO = EBX
    ;Vejo se chegou no limite de 11 digitos
    pop     EAX
    push    EAX
    cmp     EAX,11 
    jne     read_digit  ; Se não chegou, continua
    jmp     FIM         ; Se chegou no limite, fim
read_negative:
    mov     ECX,EBP
    dec     ECX
    dec     ECX
    mov     BYTE[ECX],1
    jmp     read_digit          ; continua lendo
   
to_negative:
    mov     ECX,[EBP+8]
    neg     DWORD [ECX]
    ;chars lidos 
    pop     EAX    
    ;registradores utilizados
    pop     EDX
    pop     ECX
    pop     EBX
    leave
    ret  
FIM: 
    ;ve se o numero eh negativo
    mov     AL,[EBP-2]  ; flag negativo     
    cmp     AL,1  
    je      to_negative
    ;chars lidos 
    pop     EAX    
    ;registradores utilizados
    pop     EDX
    pop     ECX
    pop     EBX
    
    leave
    ret       
    
write_int:
    ;cria frame de pilha
    ;Cria 3 variaveis locais
    enter 16,0
    ;registradores utilizados
    push    EBX
    push    ECX
    push    EDX
    
    ; Valor = Inteiro
    mov EDX, [EBP+8]
    mov EDX, [EDX]              ; EDX = NUMERO
    mov DWORD [EBP-16],EDX      ; 
    ;imprime o -, se existir    
    and     EDX,0x80000000          ;  Vejo se o primeiro número é 1 (negativo)
    cmp     EDX,0x80000000          
    jne     EI_inicio           
    ; Número Negativo    
    neg     DWORD [EBP-16]
    mov     EAX,4
    mov     EBX,1
    mov     ECX, menos
    mov     EDX,1
    int     80h
EI_inicio:    
    sub     ECX,ECX
EI_string:
    sub     EDX,EDX
    mov     EAX, [EBP-16]
    mov     EBX,10
    div     EBX                 ; num / 10
    mov     [EBP-16],EAX        
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
    mov     EAX,[EBP-16]
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