%include "includes/io.inc"

extern getAST
extern freeAST
section .bss
    ; La aceasta adresa, scheletul stocheaza radacina arborelui
    root: resd 1
    ovrnode: resd 1

section .text
preorder:
    push ebp
    mov ebp, esp
   
    mov eax, [ebp+8] 
    mov eax, [eax+4] ;initializez eax cu copilul din stanga

    xor ebx,ebx
    cmp eax, 0  ;verific daca e frunza
    je conv
    
Left:
    mov eax, [ebp+8]
    mov eax, [eax+4] ;initializez eax cu copilul din stanga
    push eax
    call preorder ;apelez recursiv functia pentru stanga
    add esp,4
    
Right: 
    mov eax, [ebp+8]
    mov eax, [eax+8] ;initializez eax cu copilul din dreapta
    push eax
    call preorder ;apelez recursiv pentru dreapta
    add esp, 4
    
    mov eax, [ebp+8]
    mov eax, [eax]
    ;verific daca in eax am operatia "+"
    cmp byte [eax], 43
    je plus
    
    ;verific daca in eax am operatia "*"
    cmp byte [eax], 42
    je multiply
    
    ;verific daca am operatia "/"
    cmp byte[eax], 47
    je divide
    
    ;verific daca am operatia "-"
    cmp byte[eax], 45 ;"-"
    je substract
plus:
    mov ebx, [ebp+8]
    mov ebx, [ebx+4] ;initializez ebx cu copilul din dreapta
    mov ebx, [ebx]
    mov ebx, [ebx] ;am dereferentiat sa ajung la valoare
    
    mov edx, [ebp+8]
    mov edx, [edx+8] ;initializez edx cu copilul din dreapta
    mov edx, [edx]
    mov edx, [edx] ;am dereferentiat pana cand ajung la valoare
    
    add ebx, edx ;adaug la ebx valoarea din edx
    mov eax, [ebp+8]
    mov eax, [eax] ;reinitializez eax pentru asigurare
    mov [eax], ebx ;pun la adresa lui eax, suma calculata
    jmp return
multiply:
    mov ebx, [ebp+8]
    mov ebx, [ebx+4] ;initializez ebx cu copilul din stanga
    mov ebx, [ebx] 
    mov ebx, [ebx] ;am dereferentiat pana am ajuns la valoare
    
    mov edx, [ebp+8]
    mov edx, [edx+8] ;initializez edx  cu copilul din dreapta
    mov edx, [edx]
    mov edx, [edx] ;am dereferentiat pana am ajuns la valoare
    
    imul ebx, edx ;inmultesc val din ebx cu cea din edx
    mov eax, [ebp+8] 
    mov eax, [eax] ;reinitializez eax pana ajung la adresa dorita
    mov [eax], ebx ;pun valoarea obtinuta mai sus
    jmp return
    
divide:
    mov eax, [ebp+8]
    mov eax, [eax+4] ; ---//-- stanga
    mov eax, [eax]
    mov eax, [eax] ;pana am ajuns la valoare
    
    mov ebx, [ebp+8]
    mov ebx, [ebx+8] ;--//-- dreapta
    mov ebx, [ebx]
    mov ebx, [ebx] ;pana am ajuns la valoare
    cdq ;convert double word to quad word
         ;in caz ca nr e negativ muta semnul in edx
    idiv ebx ;impart val din eax cu cea din ebx
    
    mov ebx, [ebp+8]
    mov ebx, [ebx] ;initializez ebx cu nodul in care vreau sa pun rezultatul
    mov [ebx], eax ;pun valoarea la adresa
    jmp return
    
 substract:
    mov ebx, [ebp+8]
    mov ebx, [ebx+4] ;--//--
    mov ebx, [ebx]
    mov ebx, [ebx] ;-///--
    
    mov edx, [ebp+8]
    mov edx, [edx+8] ;--//--
    mov edx, [edx]
    mov edx, [edx] ;--//--
    sub ebx, edx  ; scad din ebx val din edx
    mov eax, [ebp+8]
    mov eax, [eax]
    mov [eax], ebx ;pun la adresa valorii din nod val obtinuta
    jmp return
    
 conv:
    mov eax, [ebp+8]
    mov eax, [eax]
    xor ecx, ecx
 loopconv:
    mov cl, byte[eax] ;iau numarul byte cu byte din eax
    test cl, cl
    jz overriding ;verific "\0"
    cmp cl, 45 ; verific daca numarul e negativ
               ;daca e nagativ are pe primul byte "-", adica 45 in ASCII
    je negative
    inc eax  ;ma mut pe urmatorul byte
    sub cl, 48 ;scad 48 deoarece 48 este 0 in ascii
    imul ebx, 10 ;inmltesc numarul cu 10 pentru a adauga apoiultima cifra
    add ebx, ecx
    jmp loopconv
    
negative:
    inc eax ;incrementez eax pentru a nu-mi lua iar byte-ul cu "-"
    jmp negativeloopconv
    
negativeloopconv:
    mov cl, byte[eax] ; --//--
    test cl, cl
    jz overriding
    inc eax
    sub cl, 48
    imul ebx, 10
    sub ebx, ecx
    jmp negativeloopconv
    
overriding:
     mov eax, [ebp+8]
     mov eax, [eax] ;initiliaziez eax cu adresa nodului
     mov dword [eax], ebx ; pun in eax in loc de string
                        ;valoarea pe care am converit-o
    
 return:
    leave
    ret

global main
main:
    mov ebp, esp; for correct debugging
    ; NU MODIFICATI
    push ebp
    mov ebp, esp
    
    ; Se citeste arborele si se scrie la adresa indicata mai sus
    call getAST
    mov [root], eax
    
    ; Implementati rezolvarea aici:
   ; push printf
    sub esp, 4
    push eax
    call preorder
    add esp,4
    mov eax, [root]
    mov eax, [eax]
    PRINT_DEC 4,[eax]
    
    ; NU MODIFICATI
    ; Se elibereaza memoria alocata pentru arbore
    push dword [root]
    call freeAST
    
    xor eax, eax
    leave
    ret