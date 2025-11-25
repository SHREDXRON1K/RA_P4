// Loesung Aufgabe 3 und 4 von Termin4 Rechnerarchitektur SS2025 
// Variante Caesar Verschlüsselung
// Name: 	Matrikelnummer:
// Name: 	Matrikelnummer:
// Datum:
	.file "aufgabe3.S"
	.text 		@ legt eine Textsection fuer PrgrammCode + Konstanten an
	.align 2 	@ sorgt dafuer, dass nachfolgende Anweisungen auf einer durch 4 teilbaren Adresse liegen	     
	    		@ unteren 2 Bit sind 0
	.global main 	@ nimmt das Symbol main in die globale Sysmboltabelle auf
	.type main,function

// ASCII Tabelle 65 - 90 : 'A' - 'Z'
// ASCII Tabelle 97 - 122: 'a' - 'z'


main:
	push    {r4, r5,r6,  lr} @ Ruecksprungadresse und Register sichern
	mov	    r4, #3       @ Schlüssellänge in R4
	mov	    r5, #29      @ andere Schlüssellänge in R5
	mov	    r6, #55      @ andere Schlüssellänge in R6
	
@ hier Ihr Programm zum Verschluesseln von Text  .....
 
	MOV		r0, r4		// Testfall auswaehlen, Schlüssel in R0
	
	LDR		r1, =Text	@String pointer
	LDR		r8, =Text_verschluesselt	@encrypted
	LDR		r9, =Text_unverschluesselt	@decrpyted	
	
	
	cmp		r0, #26		@if key greater than 26
	blt		encrypt
	

reduceKey:
	sub		r0, r0, #26
	cmp		r0, #26
	bge		reduceKey
	
	
	
encrypt:
	LDRB		r2, [r1], #1 
	CMP		r2, #0
	BEQ		storeNull
	
	cmp		r2, #96
	subgt		r2, r2, #32
	
	
	add		r2, r2, r0
	cmp		r2, #90
	subgt		r2, r2, #26
	
	strb		r2, [r8], #1 @post increment
	
	b		encrypt

		
storeNull:
	strb		r2,[r8]
	LDR		r8, =Text_verschluesselt	@encrypted
	b		decrypt		
	
	


@ hier Ihr Programm zum Rück-Entschluesseln vom verschluesselten Text  ....

	
decrypt:
	ldrb		r2, [r8], #1
	CMP		r2, #0
	BEQ		ende
	
	sub		r2, r2, r0
	cmp		r2, #65
	addlt		r2, r2, #26
	
	strb		r2, [r9], #1 @post increment
	
	b		decrypt	

		
ende:
	pop		{r4, r5, r6, pc} @ Ruecksprungadresse und Register

Text1: .word Text   @ Beispiel um an Adressen aus anderen Segmenten zu kommen
Text2: .word  Text_verschluesselt   
Text3: .word  Text_unverschluesselt
.Lfe1:
	.size main,.Lfe1-main

// .data-Section fuer initialisierte Daten
	.data

// Text, der zu verschluesseln ist
Text:   .asciz "CAESAR"
TextEnde:

// .comm-Section fuer nicht initialisierte Daten
	.comm Text_verschluesselt, (TextEnde-Text) 	    @ Speicherbereich mit der von Text reservieren
	.comm Text_unverschluesselt, (TextEnde-Text) 	@ Speicherbereich mit der von Text reservieren

// End of File
