
; AUXILIAR FUNCTIONS (INPUT/OUTPUT)
; ------------ INT FUNCTIONS ------------
section .data
menos db '-'
output_msg db ' Quantidade de Bytes lidos/escritos = ',0x0
output_msg_size equ $ - output_msg

new_line db 0xa,0x0

section .bss
buffer_read:  resd  10

section .text        
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
    cmp     BL,0x0A                 ; Verifico se é enter: 0x0A = ENTER
    je      end_reading_int             ; Se for enter, fim  
    pop     EAX             
    inc     EAX
    push    EAX                     ; conta char ++
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
    jmp     end_reading_int         ; Se chegou no limite, fim
read_negative:
    mov     ECX,EBP
    dec     ECX
    dec     ECX
    mov     BYTE[ECX],1
    jmp     read_digit          ; continua lendo
    pop     EAX             
    inc     EAX
    push    EAX   
   
end_reading_int: 
    ;ve se o numero eh negativo
    mov     AL,[EBP-2]  ; flag negativo     
    cmp     AL,1  
    jne     end_int     ; Se flag ativou, negar numero
    mov     ECX,[EBP+8]
    neg     DWORD [ECX]
end_int:
    ; eax esta na pilha
    call   print_output_msg

    ;registradores utilizados
    pop     EDX
    pop     ECX
    pop     EBX
    
    leave
    ret       
    
    %define QUOCIENT  DWORD [EBP-16]
    %define ORIGINAL_NUM [EBP+8]    
    

%define QUOCIENT  DWORD [EBP-16]
%define ORIGINAL_NUM [EBP+8]    
    
write_int:
;cria frame de pilha
    enter 16,0
    ;PUSH EM registradores utilizados
    push    EBX
    push    ECX
    push    EDX
    
    mov EDX, ORIGINAL_NUM
    mov EDX, [EDX]          ; EDX = INTEIRO
    mov DWORD QUOCIENT,EDX     ; VALUE = INTEIRO
    ;imprime o -, se existir    
    and     EDX,0x80000000
    cmp     EDX,0x80000000
    jne     start_int_writing_begin
    neg     DWORD QUOCIENT
    mov     EAX,4
    mov     EBX,1
    mov     ECX,menos
    mov     EDX,1
    int     80h
start_int_writing_begin:    
    sub     ECX,ECX
start_int_writing:
    push    ECX                 ; i
    mov     EAX,QUOCIENT        ; EAX = QUOCIENT
    mov     EBX,10              ; EBX = 10
    sub     EDX,EDX             ; EDX = 0
    div     EBX                 ; EAX = QUOCIENTE, EDX = RESTO
    mov     QUOCIENT,EAX        ; Valor = QUOCIENTE
    mov     EBX,EBP
    sub     EBX, 1              ; EBX = ENDEREÇO DO DIGITO
    mov     [EBX],EDX           ; EBX = caractere que quero imprimir
    add     BYTE [EBX],0x30     ; converte para char
    mov     EDX,EBP
    sub     EDX,11              ; EDX = EBP -11
    mov     EBX,[EBX]           ; EBX = caractere que quero imprimir
    mov     [EDX+ECX],EBX
    pop     ECX
    inc     ECX
    mov     EAX,QUOCIENT
    cmp     EAX,0
    jne     start_int_writing
    mov     EAX,ECX
    push    EAX    
print_int:
    mov     EDX,EBP
    sub     EDX,12
    add     EDX,ECX
    push    ECX
    mov     EAX,4
    mov     EBX,1
    mov     ECX,EDX
    mov     EDX,1
    int     80h
    pop     ECX
    loop    print_int
ending_writing_int:       
    mov     EAX,ORIGINAL_NUM
    mov     EAX,[EAX]
    and     EAX,0x80000000
    cmp     EAX,0x80000000    
    pop     EAX
    jne     if_int_positive  
if_int_negative:      
    inc     EAX
if_int_positive:    

    push EAX
    call print_output_msg

    ;pop em registradores utilizados
    pop     EDX
    pop     ECX
    pop     EBX


    leave
    ret

; ------------ CHAR FUNCTIONS ------------

read_char:
    enter 0,0                      ;cria frame de pilha
    push    EBX
    push    ECX
    push    EDX

    mov     EAX,3                   ;leitura do teclado 
    mov     EBX,0                   
    mov     ECX,[EBP+8]             ; + 8, pois ebp + 4 guarda o endereço de retorno e ebp+8 guarda o endereço do parametro
    mov     EDX,1                   ;le apenas um char tamanho em bytes do que vai ser lido
    int     80h                     ;chama a interrupcao 80h


    pop     EDX                     ;pop em registradores que foram utilizados
    pop     ECX
    pop     EBX

    mov     EAX,1                   ;retorna 1 para indicar que leu um char
    push EAX
    call print_output_msg


    leave
    ret                             ;retorna para o endereço de retorno

write_char:
    enter 0,0                      ;cria frame de pilha
    push    EBX
    push    ECX
    push    EDX
    mov     EAX,4                   ;escrita no teclado
    mov     EBX,1
    mov     ECX,[EBP+8]             ; + 8, pois ebp + 4 guarda o endereço de retorno e ebp+8 guarda o endereço do parametro
    mov     EDX,1
    int     80h                     ;chama a interrupcao 80h

    mov     EAX,1                   ;retorna 1 para indicar que escreveu um char

    pop     EDX                     ;pop em registradores que foram utilizados
    pop     ECX
    pop     EBX

    push EAX
    call print_output_msg

    leave
    ret                             ;retorna para o endereço de retorno

; ------------ STRING FUNCTIONS ------------

read_string:
    enter   1,0                     ;cria frame de pilha, 1 byte para char lido
    push    EBX                     ;push em registradores que serao utilizados
    push    ECX
    push    EDX
    mov     EDX,[EBP+8]             ; + 8, pois ebp + 4 guarda o endereço de retorno e ebp+8 guarda o endereço do parametro
    sub     EAX,EAX                 ; contador de caracteres lidos
reading:
    push    EAX
    push    EDX                     ;salva o endereço da string
    ;leitura de CHAR
    mov     EAX,3
    mov     EBX,0
    mov     ECX,EBP
    dec     ECX
    mov     EDX,1
    int     80h

    mov     EBX,[ECX]               ;verifica se o CHAR eh enter
    cmp     EBX,0x0A
    je     end_reading_enter
    pop     EDX					; Salva o endereço em EAX
    mov     [EDX],EBX			; Salva o char no endereço
    inc     EDX					; vai para o próximo endereço
    pop     EAX
    inc     EAX
	jmp		reading
end_reading_enter:
    pop     EDX             ;pop na pilha
    pop     EAX             ;pop na pilha (retorno)
    ;registradores utilizados
	pop		EDX
	pop     ECX
	pop     EBX

    ;limpa frame de pilha
    mov     ESP,EBP
    pop     EBP
    ret

write_string:
    ;cria frame de pilha
    enter   0,0
    ;registradores utilizados
	; Não tem push em EAX pois EAX retorna
    push    EBX
    push    ECX
    push    EDX

    mov     EAX,[EBP+8]		; ENDEREÇO
    mov     ECX,[EBP+12]	; TAMANHO
start_string_writing:
    push    ECX				    ; empilha o tamanho atual
    push    EAX				    ; empilha o endereço atual
    
    mov     ECX, EAX            ; ESCRITA
	mov    	EAX,4
    mov     EBX,1
	mov     EDX,1
    int     80h

    pop     EAX					; retira o endereço e salva em edx
    inc     EAX					; edx = próximo endereço

    cmp     DWORD [ECX],0x0A	; verifica se o char é enter
    je      end_writing_enter
    ;ve se ainda tem TAM
    pop     ECX					    ; retira o tamanho e salva em ecx
    loop    start_string_writing	; se ainda tem tamanho, vai para o proximo char
    jmp     end_writing_overflow	    ; se nao, vai para o final
end_writing_enter:
    ;registradores utilizados
    pop     ECX

	;retorno em eax
	dec		ECX
    mov     EAX,[EBP+12]
	sub		EAX, ECX
	jmp end_writing
end_writing_overflow:
    ;retorno em EAX
    mov     EAX,[EBP+12]
    add     EAX,1     
end_writing:
	pop		EDX
	pop		ECX
	pop		EBX

    push EAX
    call print_output_msg


	;limpa frame de pilha
	leave
	ret

; FUNCTION OUTPUT MSG
print_output_msg:
    ;cria frame de pilha
    enter   0,0

    ;registradores utilizados
    push    EDI
    push    ESI
    push    EBX
    push    ECX
    push    EDX

    mov     EDI, [EBP+8]
    mov     ESI, buffer_read

    
    ;chama a funcao de escrita que escreve mensagem
    mov    EAX,4
    mov    EBX,1
    mov    ECX,output_msg
    mov    EDX,output_msg_size
    int    80h
    
    push    EDI
    push    ESI
    call    int_to_string

    mov    EDX,ECX
    mov    ECX,EAX
    mov    EAX,4
    mov    EBX,1
    int    80h

    mov    EAX,4
    mov    EBX,1
    mov    ECX,new_line
    mov    EDX,1
    int    80h
    
    ;registradores utilizados
    pop    EDX
    pop    ECX
    pop    EBX
    pop   ESI
    pop   EDI

    ;limpa frame de pilha
    leave
    ret

int_to_string:
    enter 0,0 ; create stack frame
    mov eax, [ebp+12] ; push eax
    mov esi, [ebp+8] ; push esi
    add esi,9        ; Point to the end of the buffer
    mov byte [esi],0    ; String terminator

    mov ecx,0 ; initialize counter
    mov ebx,10 ; set base to 10
.next_digit:
    inc ecx ; increment counter
    xor edx,edx         ; Clear edx prior to dividing edx:eax by ebx
    div ebx             ; eax /= 10
    add dl,'0'          ; Convert the remainder to ASCII 
    dec esi             ; store characters in reverse order
    mov [esi],dl
    test eax,eax            
    jnz .next_digit     ; Repeat until eax==0

    ; return a pointer to the first digit (not necessarily the start of the provided buffer)
    mov eax,esi
    leave ; remove stack frame
    ret
