;Nie da sie wyswietlac na 2 wyswietlaczach na raz
;Zamiast tego wynik bedzie wysiwetlany na R6 w kodzie BCD

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
	;setb 7Fh ;Timer dziala
	clr 7Fh ;Timer stoi
	mov R7, #0 ;Tmier jest wyzerowany
	mov R6, #0

	;Ustawienienie trybu timera i zdjęcie masek
	mov TMOD, #10b
	setb ET0
	setb EA

	setb TR0

loop:
	;Można dać opóźnienie lub przenieść na timer by zniwelować odbicia
	lcall buttons
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
	
	;Wypisanie na R6
	mov R1, b ;Odłożenie b

	mov b, #16
	mul ab
	add a, R1

	mov R6, a	
	ret

;Obsługa klikniecia guzikow
buttons:
	jnb P2.0, startButton
	startButtonReturn:
	jnb P2.1, stopButton
	stopButtonReturn:
	jnb P2.2, clearButton
	clearButtonReturn:

	ret

startButton:
	setb 7Fh ;Timer dziala
	ljmp startButtonReturn

stopButton:
	clr 7Fh
	ljmp stopButtonReturn

clearButton:
	mov R7, #0
	lcall display
	ljmp clearButtonReturn
