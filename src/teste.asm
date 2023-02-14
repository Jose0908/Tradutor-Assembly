SECTION TEXT
INPUT qtd_termos_fibonacci
copy ONE,a
copy ONE,b
load qtd_termos_fibonacci
jmpn parar
jmpz parar
fibonacci:
load a
add b
store c
load b
store a
load c
store b
OUTPUT c
load qtd_termos_fibonacci
sub ONE
store qtd_termos_fibonacci
jmpp fibonacci
parar:
STOP
SECTION DATA
a: space 1
b: space 1
c: space 1
ONE: CONST 0x1
qtd_termos_fibonacci: SPACE