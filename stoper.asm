;Nie da sie wyswietlac na 2 wyswietlaczach na raz
;Zamiast tego wynik bedzie wysiwetlany na R6R5
;R6 - liczba dziesiatek
;R5 - liczba jednosci

;Opis guzików:
;P2.0 - Start
;P2.1 - Stop
;P2.2 - Clear

;Stany timera:
;Czeka - bit 7F = 0
;Liczy - bit 7F = 1

;R7 - licznik tickow timera
ORG 0000
	ljmp start

org 000Bh
	;Wektor T0
	ljmp timerTick

ORG 1000
start:
	setb 7Fh ;Timer dziala
	;clr 7Fh ;Timer stoi
	mov R7, #0 ;Tmier jest wyzerowany

	;Ustawienienie trybu timera i zdjęcie masek
	mov TMOD, #10b
	setb ET0
	setb EA

	setb TR0

loop:
	;Opoznienie może być niepotrzebne
	mov R0, #0
	djnz R0, $
	ljmp loop
	
timerTick:
	jnb 7Fh, timerTickEnd ;Timer stoi
	cjne R7, #99, timerTickUp ;Sprawdzenie osiągnięcia limitu
	reti

timerTickUp:
	inc R7
	lcall display

timerTickEnd:
	reti

;Procedura wyswietlenia wartosci timera
display:
	;Podzial na BCD
	mov a, R7
	mov b, #10
	div ab
	
	;Wypisanie na R6R5
	mov R6, a
	mov R5, b
	
	ret





