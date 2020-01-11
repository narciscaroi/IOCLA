%include "include/io.inc"

extern atoi
extern printf
extern exit

; Functions to read/free/print the image.
; The image is passed in argv[1].
extern read_image
extern free_image
; void print_image(int* image, int width, int height);
extern print_image

; Get image's width and height.
; Store them in img_[width, height] variables.
extern get_image_width
extern get_image_height

section .data
	use_str db "Use with ./tema2 <task_num> [opt_arg1] [opt_arg2]", 10, 0
	string db "revient", 0
        message db "C'est un proverbe francais.", 0
        mask dw 254

section .bss
    task:       resd 1
    img:        resd 1
    img_width:  resd 1
    img_height: resd 1

section .text
    bruteforce_singlebyte_xor:
                push ebp
	        mov ebp, esp
                xor ebx, ebx
        key_loop:   ;loop-ul pentru cheie cu valori intre 0 - 255
                 xor eax,eax
                 mov eax, [ebp+8] ; pun in eax adresa primului el din matrice
		xor edx, edx
		xor edi, edi

                mov edi, [img_width]
                sub edi, 1
                mov edx, [img_height]
                sub edx,1
                imul edi, edx ;am pus in edx numarul elementelor din matrice
                xor edx, edx
                mov esi, string ; pun in esi "revient"
                xor edx,edx
		xor_element:
                         xor ecx, ecx
			mov ecx, [eax + edx * 4] 
			xor ecx, ebx
			cmp cl, byte[esi] ;compar char-ul
			je next_char ;daca este r prima data,apoi urmatoarele
			jmp reset_char ;daca char-ul nu face parte din string
                    
			next_char:
				inc esi ;trec pe urm char din string
				cmp byte[esi], 0 ;verific daca am ajuns la \0
				je printare ;printez daca da
				je return
				inc edx ;incrementez nr pixelului de verificat
				cmp edx, edi
				je pre_key_loop
				jmp xor_element

			reset_char:
				mov esi, string
				inc edx
				cmp edx, edi
				je pre_key_loop
				jmp xor_element
               
		printare:
			mov eax, edx
			xor edx, edx
			idiv dword[img_width] ;iau linia
			mov edx, eax
			imul edx, dword[img_width] ;iau pozitia elem de pe linie
                         mov ecx, [ebp+12]
                         cmp ecx, 1
                         jne return
                         push eax
                         mov eax, [ebp+8]
			jmp final_printing_1
                final_printing_1:
                   xor ecx, ecx
		   mov ecx, [eax + edx * 4]
		   xor ecx, ebx
                    cmp ecx, 0
                    je final_printing_2
                    PRINT_CHAR ecx
                   inc edx
                   jmp final_printing_1
                
                final_printing_2:
                    NEWLINE
                    pop eax
                    PRINT_UDEC 4,ebx
                    NEWLINE
                    PRINT_UDEC 4,eax
                    NEWLINE
                    jmp return
                pre_key_loop:
                    inc ebx
                    cmp ebx,256
                    je return
                    jmp key_loop
                return:
                    leave
                    ret
  
encode_message:
   push ebp
   mov ebp, esp
   
   xor eax, eax
   xor ebx, ebx
   xor ecx, ecx
   xor edx, edx
   mov esi, message
   
   mov edx, [ebp+8]    
   mov ax, dx ;cheia
   shr edx,16
   mov bx, dx ;linia
   
   mov edi, [img_width]
   imul edi, [img_height] ;iau pozitia ultimului element din matrice
   
   mov edx, [ebp+12] ;pointer la adresa lui img
   xor ecx, ecx
   decode_matrix:
        xor [edx + ecx * 4], eax
        inc ecx
        cmp ecx, edi
        je here
        jmp decode_matrix
        
   here:
   mov ecx, 5
   xor edx, edx
   imul eax, 2
   add eax, 3
   idiv ecx
   sub eax,4 ;noua cheie in eax
   
   mov edx, [ebp+12] ;pointer la img
   add ebx, 1 ;obtin linia pe care trebuie sa encodez
   
   imul ebx, [img_width]
   write_message:
        mov cl, byte[esi] ;pun char-ul care trebuie encodat
        mov [edx + ebx * 4], ecx ;il pun in matrice
        inc esi
        cmp byte[esi], 0
        je pre_encoding
        inc ebx
        jmp write_message
   
   pre_encoding:
   inc ebx
   mov cl, byte[esi]
   mov [edx + ebx * 4], ecx
   
   mov edx, [ebp+12]
   xor ecx, ecx
   encode_matrix: ;encodez matricea
        xor [edx + ecx * 4], eax
        inc ecx
        cmp ecx, edi
        je returned
        jmp encode_matrix
   
   returned:
   leave
   ret
   

encode_by_morse:
    push ebp
    mov ebp, esp

    mov eax, [ebp+8] ;img
    mov esi, [ebp+12] ;mesaj
    mov ecx, [ebp+16] ;indice
    
    ;'PRINT_STRING byte[esi]
    encoding: ;prima data verific caracterul care trebuie encodat
        cmp byte[esi], 65 ; 65 = "A"
        je encodingA
        cmp byte[esi], 66; 66 = "B"
        je encodingB
        cmp byte[esi], 67;
        je encodingC
        cmp byte[esi], 68;
        je encodingD
        cmp byte[esi], 69;
        je encodingE
        cmp byte[esi], 70;
        je encodingF
        cmp byte[esi], 71;
        je encodingG
        cmp byte[esi], 72;
        je encodingH
        cmp byte[esi], 73;
        je encodingI
        cmp byte[esi], 74;
        je encodingJ
        cmp byte[esi], 75;
        je encodingK
        cmp byte[esi], 76;
        je encodingL
        cmp byte[esi], 77;
        je encodingM
        cmp byte[esi], 78;
        je encodingN
        cmp byte[esi], 79;
        je encodingO
        cmp byte[esi], 80;
        je encodingP
        cmp byte[esi], 81;
        je encodingQ
        cmp byte[esi], 82;
        je encodingR
        cmp byte[esi], 83;
        je encodingS
        cmp byte[esi], 84;
        je encodingT
        cmp byte[esi], 85;
        je encodingU
        cmp byte[esi], 86;
        je encodingV
        cmp byte[esi], 87;
        je encodingW
        cmp byte[esi], 88;
        je encodingX
        cmp byte[esi], 89;
        je encodingY
        cmp byte[esi], 90; "90 = Z"
        je encodingZ
        
        cmp byte[esi], 97 ; 65 = "a"
        je encodingA
        cmp byte[esi], 98; 66 = "b"
        je encodingB
        cmp byte[esi], 99;
        je encodingC
        cmp byte[esi], 100;
        je encodingD
        cmp byte[esi], 101;
        je encodingE
        cmp byte[esi], 102;
        je encodingF
        cmp byte[esi], 103;
        je encodingG
        cmp byte[esi], 104;
        je encodingH
        cmp byte[esi], 105;
        je encodingI
        cmp byte[esi], 106;
        je encodingJ
        cmp byte[esi], 107;
        je encodingK
        cmp byte[esi], 108;
        je encodingL
        cmp byte[esi], 109;
        je encodingM
        cmp byte[esi], 110;
        je encodingN
        cmp byte[esi], 111;
        je encodingO
        cmp byte[esi], 112;
        je encodingP
        cmp byte[esi], 113;
        je encodingQ
        cmp byte[esi], 114;
        je encodingR
        cmp byte[esi], 115;
        je encodingS
        cmp byte[esi], 116;
        je encodingT  
        cmp byte[esi], 117;
        je encodingU
        cmp byte[esi], 118;
        je encodingV
        cmp byte[esi], 119;
        je encodingW
        cmp byte[esi], 120;
        je encodingX
        cmp byte[esi], 121;
        je encodingY
        cmp byte[esi], 122; "90 = Z"
        je encodingZ
        cmp byte[esi], 0
        je returnM
        cmp byte[esi], 44 ;","
        je encodingComma
    
    encodingA:
        mov byte[eax + ecx * 4], 46 ; "." 
        inc ecx
        mov byte[eax + ecx * 4], 45 ; "-"
        add ecx, 1
        inc esi
        cmp byte[esi], 32
        je encodingSpaceWords
        jmp encodingSpaceLetter
        
    encodingB:
         mov byte[eax + ecx * 4], 45; "-"
         add ecx, 1
         mov edx, 3
      repeatSPointB:
         mov byte[eax + ecx * 4], 46 ;"."
         inc ecx
         dec edx
         cmp edx, 0
         ja repeatSPointB
         inc esi
         cmp byte[esi], 32 ; " "
         je encodingSpaceWords
         jmp encodingSpaceLetter
    encodingC:
         mov edx, 2
      repeatCLP:
         mov byte[eax + ecx * 4], 45 ;"-"
         add ecx, 1
         mov byte[eax + ecx * 4], 46 ;"."
         inc ecx
         dec edx
         cmp edx, 0
         je finalC
         jmp repeatCLP
      finalC:
         inc esi
         cmp byte[esi], 32 ; " "
         je encodingSpaceWords
         jmp encodingSpaceLetter
    
    encodingD:
         mov byte[eax + ecx * 4], 45 ;"-"
         add ecx, 1
         mov edx, 2
      repeatDP:
         mov byte[eax + ecx * 4], 46 ;"."
         inc ecx
         dec edx
         cmp edx, 0
         ja repeatDP
         inc esi
         cmp byte[esi], 32 ; " "
         je encodingSpaceWords
         jmp encodingSpaceLetter
         
    encodingE:
        mov byte[eax + ecx * 4], 46 ;"."
        inc ecx
        inc esi
        cmp byte[esi], 32
        je encodingSpaceWords
        jmp encodingSpaceLetter
    encodingF:
        mov edx, 2
     repeatFP:
        mov byte[eax + ecx * 4], 46 ;"."
        inc ecx
        dec edx
        cmp edx, 0
        ja repeatFP
        mov byte[eax + ecx * 4], 45 ;"-"
        add ecx, 1
        mov byte[eax + ecx * 4], 46 ;"."
        inc ecx
        inc esi
        cmp byte[esi], 32
        je encodingSpaceWords
        jmp encodingSpaceLetter
    encodingG:
        mov edx, 2
     repeatLG:
        mov byte[eax + ecx * 4], 45 ;"-"
        add ecx, 1
        dec edx
        cmp edx, 0
        ja repeatLG
        mov byte[eax + ecx * 4], 46 ;"."
        inc ecx
        inc esi
        cmp byte[esi], 32
        je encodingSpaceWords
        jmp encodingSpaceLetter
    encodingH:
        mov edx, 4
     anotherEdxP:
     repeatHP:
        mov byte[eax + ecx * 4], 46 ;"."
        inc ecx
        dec edx
        cmp edx, 0
        je finalD
        jmp repeatHP
     finalD:
        inc esi
        cmp byte[esi], 32
        je encodingSpaceWords
        jmp encodingSpaceLetter
    
    encodingI:
        ;mov edx, 2
        ;jmp repeatHP
        mov byte[eax + ecx * 4], 46 ;"."
        inc ecx
        mov byte[eax + ecx * 4], 46 ;"."
        inc ecx
        inc esi
        cmp byte[esi], 32
        je encodingSpaceWords
        jmp encodingSpaceLetter
    encodingJ:
        mov byte[eax + ecx * 4], 45 ;"."
        inc ecx
        mov edx, 3
      anotherEdx:
      repeatLJ:
        mov byte[eax + ecx * 4], 45 ;"-"
        add ecx, 1
        dec edx
        cmp edx, 0
        ja repeatLJ
        inc esi
        cmp byte[esi], 32
        je encodingSpaceWords
        jmp encodingSpaceLetter
    encodingK:
        mov edx,2
      repeatKLP:
        mov byte[eax + ecx * 4], 45 ;"-"
        inc ecx
        dec edx
        cmp edx,0
        je finalK
        cmp edx,1
        je repeatKLP
        mov byte[eax + ecx * 4], 46   ; "."
        jmp repeatKLP
      finalK:
        inc esi
        cmp byte[esi], 32
        je encodingSpaceWords
        jmp encodingSpaceLetter
        
    encodingL:
        mov edx, 3
      repeatLLP:
        mov byte[eax + ecx * 4], 46 ;"."
        inc ecx
        dec edx
        cmp edx, 2
        je LLine
        cmp edx, 0
        je finalL
        jmp repeatLLP
      LLine:
        mov byte[eax + ecx * 4], 45 ;"-"
        add ecx, 1
        jmp repeatLLP
      finalL:
        inc esi
        cmp byte[esi], 32
        je encodingSpaceWords
        jmp encodingSpaceLetter
        
    encodingM:
        mov edx,2
        jmp repeatLJ
    encodingN:
        mov edx, 1
        jmp repeatCLP
    
    encodingO:
        mov edx, 3
        jmp repeatLJ
        
    encodingP:
        mov byte[eax + ecx * 4], 46 ;"."
        inc ecx
        mov byte[eax + ecx * 4], 45 ;"-"
        add ecx, 1
        mov byte[eax + ecx *  4], 45 ;"-"
        add ecx, 1
        mov byte[eax + ecx * 4], 46 ;"."
        inc ecx
        inc esi
        cmp byte[esi], 32
        je encodingSpaceWords
        jmp encodingSpaceLetter
        
    encodingQ:
        mov edx, 3
      repeatQLP:
        mov byte[eax + ecx * 4], 45 ;"-"
        add ecx, 1
        dec edx
        cmp edx, 0
        je finalQ
        cmp edx, 1
        je qPoint
        jmp repeatQLP
      qPoint:
        mov byte[eax + ecx * 4], 46 ;"."
        inc ecx
        jmp repeatQLP
      finalQ:
        inc esi
        cmp byte[esi], 32
        je encodingSpaceWords
        jmp encodingSpaceLetter
        
    encodingR:
        mov edx, 2
      repeatRPL:
        mov byte[eax + ecx * 4], 46 ;"."
        inc ecx
        dec edx
        cmp edx, 1
        je RL
        cmp edx, 0
        je finalR
      RL:
        mov byte[eax + ecx * 4], 45 ;"-"
        inc ecx
        jmp repeatRPL
        
      finalR:
        inc esi
        cmp byte[esi], 32
        je encodingSpaceWords
        jmp encodingSpaceLetter
    encodingS:
        mov edx, 3
        jmp repeatHP
    encodingT:
        mov byte[eax + ecx * 4], 45 ;"-"
        add ecx, 1
        inc esi
        cmp byte[esi], 32
        je encodingSpaceWords
        jmp encodingSpaceLetter
    encodingU:
        mov edx,2
      repeatUP:
        mov byte[eax + ecx * 4], 46 ;"."
        inc ecx
        dec edx
        cmp edx,0
        ja repeatUP
        mov byte[eax + ecx * 4], 45 ;"-"
        add ecx, 1
        inc esi
        cmp byte[esi], 32
        je encodingSpaceWords
        jmp encodingSpaceLetter
    encodingV:
        mov edx, 3
        jmp repeatUP
    encodingW:
        mov byte[eax + ecx * 4], 46 ;"."
        inc ecx
        mov edx, 2
        jmp anotherEdx
    encodingX:
        mov byte[eax + ecx * 4], 45 ;"-"
        add ecx, 3
        mov byte[eax + ecx * 4], 46 ;"."
        inc ecx
        mov byte[eax + ecx * 4], 46 ;"."
        inc ecx
        mov byte[eax + ecx * 4], 45 ;"-"
        add ecx, 3
        inc esi
        cmp byte[esi], 32
        je encodingSpaceWords
        jmp encodingSpaceLetter
    encodingY:
        mov byte[eax + ecx * 4], 45 ;"-"
        add ecx, 3
        mov byte [eax + ecx * 4], 46 ;"."
        inc ecx
        
        mov edx, 2
        jmp anotherEdx
    encodingZ:
        mov byte[eax + ecx * 4], 45 ;"-"
        inc ecx
        mov byte[eax + ecx * 4], 45 ;"-"
        inc ecx
        mov edx, 2
      repeatZP:
        mov byte[eax + ecx * 4], 46 ;"."
        inc ecx
        dec edx
        cmp edx, 0
        je finalZ
        jmp repeatZP
     finalZ:
        inc esi
        cmp byte[esi], 32
        je encodingSpaceWords
        jmp encodingSpaceLetter
    encoding1:
        mov byte[eax + ecx * 4], 46 ;"."
        inc ecx
        mov edx, 4
        jmp anotherEdx
    encoding2:
        mov byte[eax + ecx * 4], 46 ;"."
        inc ecx
        mov byte[eax + ecx * 4], 46 ;"."
        inc ecx
        mov edx, 3
        jmp anotherEdx
    encoding3:
        mov edx, 3
      repeat3P:
        mov byte[eax + ecx * 4], 46 ;"."
        inc ecx
        dec edx
        cmp edx, 0
        je next3
        jmp repeat3P
      next3:
        mov edx, 2
        jmp anotherEdx
    encoding4:
         mov edx, 4
      repeat4P:
        mov byte[eax + ecx * 4], 46 ;"."
        inc ecx
        dec edx
        cmp edx, 0
        je next4
        jmp repeat4P
      next4:
        mov byte[eax + ecx * 4], 45 ;"-"
        add ecx, 3
        inc esi
        cmp byte[esi], 32
        je encodingSpaceWords
        jmp encodingSpaceLetter
    encoding5:
        mov edx, 5
        jmp anotherEdxP
    encoding6:
        mov byte [eax + ecx * 4], 45 ;"-"
        inc ecx
        mov edx, 4
        jmp anotherEdxP
    encoding7:
        mov edx, 2
      repeat7L:
        mov byte[eax + ecx * 4], 45 ;"-"
        inc ecx
        dec edx
        cmp edx,0
        ja repeat7L
        mov edx, 3
        jmp anotherEdxP
    encoding8:
         mov edx, 3
      repeat8L:
        mov byte[eax + ecx * 4], 45 ;"-"
        inc ecx
        dec edx
        cmp edx,0
        ja repeat8L
        mov edx, 2
        jmp anotherEdxP
    encoding9:
        mov edx, 4
      repeat9L:
        mov byte[eax + ecx * 4], 45 ;"-"
        inc ecx
        dec edx
        cmp edx,0
        ja repeat9L
        mov edx, 1
        jmp anotherEdxP
    encoding0:
        mov edx, 5
        jmp anotherEdx
    encodingComma:
        mov byte[eax + ecx * 4], 45 ;"-"
        inc ecx
        mov byte[eax + ecx * 4], 45 ;"-"
        inc ecx
        mov byte[eax + ecx * 4], 46 ;"."
        inc ecx
        mov byte[eax + ecx * 4], 46 ;"."
        inc ecx
        mov byte[eax + ecx * 4], 45 ;"-"
        inc ecx
        mov byte[eax + ecx * 4], 45 ;"-"
        inc ecx
      finalCOM:
        inc esi
        cmp byte[esi], 32
        je encodingSpaceWords
        jmp encodingSpaceLetter
    encodingSpaceLetter:
        cmp byte[esi], 0
        je returnM
        mov byte[eax + ecx * 4], 32 ;" "
        add ecx, 1
        jmp encoding
    encodingSpaceWords:
        inc esi
        mov byte[eax + ecx * 4], 32 ;" "
        add ecx, 1
        jmp encoding
    returnM:
    mov byte[eax + ecx * 4], 0 ;"\0"    
    leave
    ret

lsb_encode:
    push ebp
    mov ebp, esp
    
    xor eax, eax
    xor ebx, ebx
    xor edx, edx,
    xor ecx, ecx
    
    mov ebx, [ebp + 8] ;img
    mov esi, [ebp + 12] ;msg
    mov ecx, [ebp + 16] ;byte-ul
    dec ecx
    loop_msg:
        xor eax, eax
        mov edx, 0
        loop_bits:
           xor eax, eax
           mov al, byte[esi] ;char-ul pe care trb sa il encodez
           push edx ;iteratia loo-ului
           push eax ;char-ul
           call seeNbit
           add esp, 4
           pop edx ;iteratia loop-ului
          
           cmp eax, 0
           je zeroBit
           mov eax, dword[ebx + ecx * 4] ;elementul din matrice care trebuie schimbat
           push edx
           mov edx, 254 ; 254 = 11111110 | reseteaza ultimul bit
           and eax, edx 
           add eax, 1 ; adun 1 pentru a-i seta ultimul bit
           mov dword[ebx + ecx * 4], eax
           inc ecx
           pop edx
           jmp continueLSB
           
           zeroBit:
           mov eax, dword[ebx + ecx * 4]
           push edx
           mov edx, 254 ;reseteaza ultimul bit
           and eax, edx
           mov dword[ebx + ecx * 4], eax
           inc ecx
           pop edx
           
           continueLSB:
           inc edx ;incrementez nr de iteratii
           cmp edx, 7
           jbe loop_bits
           ja incEsi
         
         incEsi:
           inc esi
           cmp byte[esi], 0
           je pre_writeTerminator
           jmp loop_msg
   pre_writeTerminator:
        mov edx,7
   
   writeTerminator:
            xor eax,eax
            mov eax, 254
            and dword[ebx + ecx * 4], eax
            inc ecx
            dec edx
            cmp edx, 0
            ja writeTerminator
  returnLSB:
  leave
  ret
  
seeNbit:
    push ebp
    mov ebp,esp
    
    push ecx
    mov ecx,7
    mov eax, dword[ebp+12] ;nBit
    sub ecx, eax ; 7 - nr iteratiei la care ma aflu pe un char
    mov eax, [ebp + 8]
    mov edx, 1 ;mask
    for_shifts:
        cmp ecx, 0
        je hereSNB
        shl edx, 1
        dec ecx
        jmp for_shifts
    hereSNB:
    and edx, eax
    cmp edx, 0
    je nonSet
    jmp set
   nonSet:
   pop ecx
   mov eax, 0 ;daca e bitul e 0, returnez 0
   jmp returnSB
   set:
   pop ecx
   mov eax, 1; daca e 1, returnez 1
   returnSB:
   leave
   ret
   
   lsb_decode:
     push ebp
     mov ebp, esp
     
     mov ebx, [ebp+8] ;img
     mov ecx, [ebp+12] ;idx
     dec ecx
     xor eax, eax
     xor edx, edx
     xor edi, edi
     xor esi, esi
     loop_numbers:
        xor eax,eax
        mov al, byte[ebx + ecx * 4]  ;iau numarul din matrice
        inc ecx
        and al, 1 ;verific daca ultimul  bit e setat sau nu
        cmp al, 0
        je incNo0 ;retin nr de 0-uri consecutive
        xor esi, esi ; resetez daca am gasit un 1
      continueSBD:
        shl dl, 1 ;shiftez nr si adaug ultimul bit gasit
        add dl, al
        inc edi
        cmp edi, 8
        je printNumber
        jmp loop_numbers
      incNo0:
        inc esi
        cmp esi,8
        je returnSBD
        jmp continueSBD
      
      printNumber:
        PRINT_CHAR edx ;printez
        xor edx, edx ;resetez numarul
        xor edi, edi ;resetez counterul de biti adaugati
        jmp loop_numbers  
   returnSBD:
   leave
   ret
   
   
   blur:
   push ebp
   mov ebp, esp
   
   mov ebx, [ebp + 8]
   xor edi, edi ; col
   xor eax, eax ;line
   xor edx, edx
   xor ecx, ecx
   loop_line: ;loop-ul cu care parcurg liniile
      xor eax, eax
      inc edi
      mov eax, [img_width]
      dec eax
      cmp edi, eax
      je pr_loop_line
      mov eax, edi
      mul dword[img_width] ;obtin pozitia primului elem de pe o linie
      mov esi, eax
      loop_col:
        xor ecx, ecx
        cmp eax, esi ;verific sa nu fie chiar primul element
        je incCol
        push edi ; nr liniei
        push esi ;pozitia primului elem
        
        add esi, dword[img_width]
        dec esi
        cmp eax, esi
        je incCol
        
        
        push eax
        push edx
        xor edx, edx
        div dword[img_width]
        mov esi, edx ;retin offset-ul pe o linie al 
                      ;numarului pentru care fac calculele
        xor eax, eax
        pop edx
        pop eax
        
        xor ecx, ecx
        dec eax
        add ecx, dword[ebx + eax * 4];stanga
        inc eax
        add ecx, dword[ebx + eax * 4] ;elementul
        inc eax
        add ecx, dword[ebx + eax * 4];dreapta
        dec eax
        
        ;sus
        push eax
        push edi
        dec edi
        mov eax, edi
        mul dword[img_width]
        pop edi
        add eax, esi
        add ecx, dword[ebx + eax * 4]
        pop eax
        
        ;jos
        push eax
        push edi
        inc edi ;incrementez linia
        mov eax, edi
        mul dword[img_width]
        pop edi ;iau indicele liniei care era inainte
        add eax, esi ;adun offset-ul
        add ecx, dword[ebx + eax * 4]
        pop eax ;primesc iar pozitia elementului
        
        pop esi
        pop edx ;primul push de edi
        inc edx
        push eax
        mov eax, edx
        mul dword[img_width]
        mov edx, eax
        dec edx ;poz ultimului element de pe linie
        pop eax
        inc eax
        
        push eax
        push edx
        push ecx ;valoarea calculata
        mov eax, ecx ; pun in eax ce am valoarea pt a o imparti
        xor edx, edx ;curat edx pt a se pune restul
        mov ecx, 5 ;pun impartitorul in ecx
        div ecx ;fac impartirea
        pop ecx ;scot de pe stiva valoarea neimpartita
        mov ecx, eax ;pun in ecx val impartita
        pop edx ;scot nr liniei de pe stiva
        pop eax ;scot poz elem de pe stiva
        push ecx ;pun pe stiva val calculata
        
        cmp eax, edx
        jb loop_col
        je incEaxFinalLine
        
        mov esi, [img_width]
        dec esi
        imul esi, [img_height]
        cmp esi, eax
        jb loop_line
        
     pr_loop_line:
        mov eax, [img_height]
        dec eax
        mov ecx, [img_width]
        mul ecx
        sub eax, 2
        
        pr_loop_col:
            pop ecx
            mov dword[ebx + eax * 4], ecx
            dec eax
            
            xor edx, edx
            mov edx, edi
            push eax
            dec edx
            mov eax, edx
            mul dword[img_width]
            mov edx, eax
            pop eax
            cmp eax, edx
            je decEaxPos
            ja pr_loop_col
            jmp returnBLUR
   incEaxFinalLine:
   inc eax
   jmp loop_line
   decEaxPos:
    sub eax, 2
    dec edi
    cmp edi, 1
    je returnBLUR
    jmp pr_loop_col
   incCol:
    inc eax
    jmp loop_col
   returnBLUR:
    leave
    ret
global main
main:

    mov ebp, esp; for correct debugging
    ; Prologue
    ; Do not modify!
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8]
    cmp eax, 1
    jne not_zero_param

    push use_str
    call printf
    add esp, 4

    push -1
    call exit

not_zero_param:
    ; We read the image. You can thank us later! :)
    ; You have it stored at img variable's address.
    mov eax, [ebp + 12]
    push DWORD[eax + 4]
    call read_image
    add esp, 4
    mov [img], eax

    ; We saved the image's dimensions in the variables below.
    call get_image_width
    mov [img_width], eax

    call get_image_height
    mov [img_height], eax

    ; Let's get the task number. It will be stored at task variable's address.
    mov eax, [ebp + 12]
    push DWORD[eax + 8]
    call atoi
    add esp, 4
    mov [task], eax

    ; There you go! Have fun! :D
    mov eax, [task]
    cmp eax, 1
    je solve_task1
    cmp eax, 2
    je solve_task2
    cmp eax, 3
    je solve_task3
    cmp eax, 4
    je solve_task4
    cmp eax, 5
    je solve_task5
    cmp eax, 6
    je solve_task6
    jmp done

solve_task1:
    ; TODO Task1
    xor ecx, ecx
    xor edx, edx
    mov ecx, 1
trailing_lines:
        push ecx
	push dword [img]
	call bruteforce_singlebyte_xor
	add esp, 8
	jmp done
solve_task2:
    ; TODO Task2
    mov ecx, 2
    push ecx
    push dword [img]
    call bruteforce_singlebyte_xor
    add esp, 4
    
    shl eax, 16
    mov ax, bx  ;primii linia, ultimii cheia
    push dword [img]
    push eax
    call encode_message
    add esp, 8
    push dword[img_height]
    push dword[img_width]
    push dword[img]
    call print_image
    add esp, 12
    jmp done
solve_task3:
    ; TODO Task3
    
    mov eax, [ebp + 12]
    push DWORD[eax + 16]
    call atoi
    add esp, 4
    push eax
    
    mov eax, [ebp + 12]
    push dword[eax+12] ;mesaj
    push dword[img]
    call encode_by_morse
    add esp, 12
    
    push dword[img_height]
    push dword[img_width]
    push dword[img]
    call print_image
    add esp,12
    jmp done
solve_task4:
    ; TODO Task4
    mov eax, [ebp + 12]
    push DWORD[eax + 16]
    call atoi
    add esp, 4
    push eax ;indice
    
    mov eax, [ebp + 12]
    push dword[eax+12] ;mesaj
    push dword[img]
    call lsb_encode
    add esp, 12
    
    push dword[img_height]
    push dword[img_width]
    push dword[img]
    call print_image
    add esp,12
    jmp done
solve_task5:
    ; TODO Task5
    mov eax, [ebp + 12]
    push DWORD[eax + 12]
    call atoi
    add esp, 4
    push eax ;indice
    push dword[img]
    call lsb_decode
    add esp,8
    jmp done
solve_task6:
     ;TODO Task6
    push dword[img]
    call blur
    add esp,4
    
    push dword[img_height]
    push dword[img_width]
    push dword[img]
    call print_image
    add esp,12
    jmp done

    ; Free the memory allocated for the image.
done:
    push DWORD[img]
    call free_image
    add esp, 4

    ; Epilogue
    ; Do not modify!
    xor eax, eax
    leave
    ret
    
