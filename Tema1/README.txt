Functia preorder, imi parcurge arborele recursiv, pana cand acesta ajunge la o
frunza, moment in care, imi converteste valoarea din string, ai exact, dintr-un
string convertesc intr-un numar pe 2 cazuri : parcurg string-ul byte cu byte,
daca primul byte este o cifra, adaug cifra in numar, apoi inmultesc cu 10 si
adaug urmatorul byte, pana cand ajung la "\0", iar pentru cazul in care
numarul este negativ, acesta incepe cu caracterul ASCII 45, si aplic metoda
de la numere pozitive, doar ca in loc sa adaug,de fiecare data scad. Dupa
returnarea unui apel recursiv pe dreapta, programul se intoarce intr-un nod
in care am operand "+", "-", "*", "/" si aplic operatia din nod pe numerele
aflate in nodurile din stanga si din dreapta. 
