
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Distance_measure.c,26 :: 		void interrupt(){
;Distance_measure.c,27 :: 		if(RBIF_bit){
	BTFSS      RBIF_bit+0, BitPos(RBIF_bit+0)
	GOTO       L_interrupt0
;Distance_measure.c,28 :: 		RBIE_bit = 0;// baðlantý noktasý deðiþikliði kesmesini devre dýþý býrak
	BCF        RBIE_bit+0, BitPos(RBIE_bit+0)
;Distance_measure.c,29 :: 		if(echo){ //echo pini 1
	BTFSS      PORTB+0, 4
	GOTO       L_interrupt1
;Distance_measure.c,30 :: 		TMR1L  = 0;                               //Timer1 sayýcýsýnýn düþük deðerlikli bitini tutan kaydedici
	CLRF       TMR1L+0
;Distance_measure.c,31 :: 		TMR1H  = 0;                               // Timer1 sayýcýsýnýn yüksek deðerlikli bitini tutan kaydedici
	CLRF       TMR1H+0
;Distance_measure.c,32 :: 		T1CON.TMR1ON = 1;// Zamanlayýcýyý Etkinleþtir1
	BSF        T1CON+0, 0
;Distance_measure.c,33 :: 		}
L_interrupt1:
;Distance_measure.c,34 :: 		if(!echo){ //echo pini 0
	BTFSC      PORTB+0, 4
	GOTO       L_interrupt2
;Distance_measure.c,35 :: 		zaman = (TMR1H<<8) | (TMR1L) ;          // Zamanlayýcý Deðerini Okur
	MOVF       TMR1H+0, 0
	MOVWF      _zaman+1
	CLRF       _zaman+0
	MOVF       TMR1L+0, 0
	IORWF      _zaman+0, 1
	MOVLW      0
	IORWF      _zaman+1, 1
;Distance_measure.c,36 :: 		T1CON.TMR1ON = 0;// zamanlayýcýyý devre dýþý býrakýr
	BCF        T1CON+0, 0
;Distance_measure.c,38 :: 		}
L_interrupt2:
;Distance_measure.c,39 :: 		RBIF_bit = 0;                 // Kesme bayraðý bitini temizle
	BCF        RBIF_bit+0, BitPos(RBIF_bit+0)
;Distance_measure.c,40 :: 		}
L_interrupt0:
;Distance_measure.c,41 :: 		RBIE_bit = 1;// Baðlantý noktasý deðiþikliði kesmesini etkinleþtir
	BSF        RBIE_bit+0, BitPos(RBIE_bit+0)
;Distance_measure.c,42 :: 		}
L_end_interrupt:
L__interrupt33:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_Tone1:

;Distance_measure.c,44 :: 		void Tone1() {
;Distance_measure.c,45 :: 		Sound_Play(500, 200);   // frekans, süre
	MOVLW      244
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      1
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      200
	MOVWF      FARG_Sound_Play_duration_ms+0
	CLRF       FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;Distance_measure.c,46 :: 		}
L_end_Tone1:
	RETURN
; end of _Tone1

_Tone2:

;Distance_measure.c,48 :: 		void Tone2() {
;Distance_measure.c,49 :: 		Sound_Play(600, 400);
	MOVLW      88
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      2
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      144
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      1
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;Distance_measure.c,50 :: 		}
L_end_Tone2:
	RETURN
; end of _Tone2

_Tone3:

;Distance_measure.c,52 :: 		void Tone3() {
;Distance_measure.c,53 :: 		Sound_Play(700, 700);
	MOVLW      188
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      2
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      188
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      2
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;Distance_measure.c,54 :: 		}
L_end_Tone3:
	RETURN
; end of _Tone3

_Tone4:

;Distance_measure.c,56 :: 		void Tone4() {
;Distance_measure.c,57 :: 		Sound_Play(1000, 2000);
	MOVLW      232
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      3
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      208
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      7
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;Distance_measure.c,58 :: 		}
L_end_Tone4:
	RETURN
; end of _Tone4

_main:

;Distance_measure.c,62 :: 		void main() {
;Distance_measure.c,63 :: 		TRISB0_bit = 0;// Trigger pin
	BCF        TRISB0_bit+0, BitPos(TRISB0_bit+0)
;Distance_measure.c,64 :: 		TRISB4_bit = 1;// Echo pin
	BSF        TRISB4_bit+0, BitPos(TRISB4_bit+0)
;Distance_measure.c,65 :: 		TRISC=0;
	CLRF       TRISC+0
;Distance_measure.c,66 :: 		TRISD=0b00000000; //BUZZER
	CLRF       TRISD+0
;Distance_measure.c,70 :: 		Sound_Init(&PORTD, 0);
	MOVLW      PORTD+0
	MOVWF      FARG_Sound_Init_snd_port+0
	CLRF       FARG_Sound_Init_snd_pin+0
	CALL       _Sound_Init+0
;Distance_measure.c,71 :: 		Sound_Play(1000,100);
	MOVLW      232
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      3
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      100
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      0
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;Distance_measure.c,75 :: 		Lcd_Init();                      //display baðlantýlarýný oku
	CALL       _Lcd_Init+0
;Distance_measure.c,76 :: 		Lcd_Cmd(_LCD_CLEAR);              // Lcd modülünü baþlatýn
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Distance_measure.c,77 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);        // LCD ekranýn imleci
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Distance_measure.c,78 :: 		Lcd_Out(1,1,"HOSGELDINIZ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_Distance_measure+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Distance_measure.c,79 :: 		delay_ms(1000);              // 1 saniye gecikme
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main3:
	DECFSZ     R13+0, 1
	GOTO       L_main3
	DECFSZ     R12+0, 1
	GOTO       L_main3
	DECFSZ     R11+0, 1
	GOTO       L_main3
	NOP
	NOP
;Distance_measure.c,80 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Distance_measure.c,81 :: 		Lcd_Out(1,1,"FERHAT_YAMAN");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_Distance_measure+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Distance_measure.c,82 :: 		Lcd_Out(2,1,"170421829");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_Distance_measure+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Distance_measure.c,83 :: 		delay_ms(1000);            // 1 saniye gecikme
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main4:
	DECFSZ     R13+0, 1
	GOTO       L_main4
	DECFSZ     R12+0, 1
	GOTO       L_main4
	DECFSZ     R11+0, 1
	GOTO       L_main4
	NOP
	NOP
;Distance_measure.c,84 :: 		Lcd_Cmd(_LCD_CLEAR);           // LCD ekraný temizle
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Distance_measure.c,86 :: 		INTCON.GIE = 1;             // gloabal interruptý etkinleþtirdik
	BSF        INTCON+0, 7
;Distance_measure.c,87 :: 		INTCON.RBIE = 1;          // Baðlantý noktasý deðiþikliðini etkinleþtir
	BSF        INTCON+0, 3
;Distance_measure.c,89 :: 		T1CON.TMR1ON = 0;        // Timer1'i devre dýþý býrak
	BCF        T1CON+0, 0
;Distance_measure.c,90 :: 		T1CON.TMR1CS = 0;        // Timer1 internal clock kaynaðý (Fosc/4)
	BCF        T1CON+0, 1
;Distance_measure.c,91 :: 		T1CON.T1CKPS1 = 0;       // 1:2 Presclar deðeri
	BCF        T1CON+0, 5
;Distance_measure.c,92 :: 		T1CON.T1CKPS0 = 1;
	BSF        T1CON+0, 4
;Distance_measure.c,94 :: 		zaman = 0;
	CLRF       _zaman+0
	CLRF       _zaman+1
;Distance_measure.c,95 :: 		mesafe = 0;
	CLRF       _mesafe+0
	CLRF       _mesafe+1
	CLRF       _mesafe+2
	CLRF       _mesafe+3
;Distance_measure.c,97 :: 		while(1){
L_main5:
;Distance_measure.c,98 :: 		trig =1; //tetikleme palsi          //Sensör Tetik pininde en az 10µs darbeye ihtiyaç duyar
	BSF        PORTB+0, 0
;Distance_measure.c,99 :: 		delay_us(10); //(10us)
	MOVLW      3
	MOVWF      R13+0
L_main7:
	DECFSZ     R13+0, 1
	GOTO       L_main7
;Distance_measure.c,100 :: 		trig = 0;
	BCF        PORTB+0, 0
;Distance_measure.c,101 :: 		while(!echo);             //ECHO "H" olana kadar bekle
L_main8:
	BTFSC      PORTB+0, 4
	GOTO       L_main9
	GOTO       L_main8
L_main9:
;Distance_measure.c,102 :: 		T1CON.TMR1ON = 1;         //Timer1'i baþlat
	BSF        T1CON+0, 0
;Distance_measure.c,103 :: 		while(echo);               //ECHO "L" olana kadar bekle
L_main10:
	BTFSS      PORTB+0, 4
	GOTO       L_main11
	GOTO       L_main10
L_main11:
;Distance_measure.c,104 :: 		T1CON.TMR1ON = 0;          //Timer1'i durdur.
	BCF        T1CON+0, 0
;Distance_measure.c,107 :: 		mesafe = zaman*(0.034 / 2);
	MOVF       _zaman+0, 0
	MOVWF      R0+0
	MOVF       _zaman+1, 0
	MOVWF      R0+1
	CALL       _word2double+0
	MOVLW      150
	MOVWF      R4+0
	MOVLW      67
	MOVWF      R4+1
	MOVLW      11
	MOVWF      R4+2
	MOVLW      121
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _mesafe+0
	MOVF       R0+1, 0
	MOVWF      _mesafe+1
	MOVF       R0+2, 0
	MOVWF      _mesafe+2
	MOVF       R0+3, 0
	MOVWF      _mesafe+3
;Distance_measure.c,108 :: 		if( mesafe >=2 && mesafe <=800 ) {     // Geçerli mesafe için durumu kontrol edin
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      0
	MOVWF      R4+2
	MOVLW      128
	MOVWF      R4+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main14
	MOVF       _mesafe+0, 0
	MOVWF      R4+0
	MOVF       _mesafe+1, 0
	MOVWF      R4+1
	MOVF       _mesafe+2, 0
	MOVWF      R4+2
	MOVF       _mesafe+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      72
	MOVWF      R0+2
	MOVLW      136
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main14
L__main31:
;Distance_measure.c,109 :: 		Lcd_Out(2,7,"cm");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_Distance_measure+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Distance_measure.c,110 :: 		Lcd_Out(1,1,"Mesafe:");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_Distance_measure+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Distance_measure.c,111 :: 		floatToStr(mesafe,text); //veri dönüþtürme
	MOVF       _mesafe+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       _mesafe+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       _mesafe+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       _mesafe+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      _text+0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
;Distance_measure.c,112 :: 		Ltrim(text);
	MOVLW      _text+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
;Distance_measure.c,113 :: 		text[5] =0;
	CLRF       _text+5
;Distance_measure.c,114 :: 		Lcd_Out(2,1,text);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _text+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Distance_measure.c,117 :: 		if(mesafe <=165 && mesafe >110){
	MOVF       _mesafe+0, 0
	MOVWF      R4+0
	MOVF       _mesafe+1, 0
	MOVWF      R4+1
	MOVF       _mesafe+2, 0
	MOVWF      R4+2
	MOVF       _mesafe+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      37
	MOVWF      R0+2
	MOVLW      134
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main17
	MOVF       _mesafe+0, 0
	MOVWF      R4+0
	MOVF       _mesafe+1, 0
	MOVWF      R4+1
	MOVF       _mesafe+2, 0
	MOVWF      R4+2
	MOVF       _mesafe+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      92
	MOVWF      R0+2
	MOVLW      133
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main17
L__main30:
;Distance_measure.c,118 :: 		Tone1();
	CALL       _Tone1+0
;Distance_measure.c,119 :: 		}
	GOTO       L_main18
L_main17:
;Distance_measure.c,120 :: 		else if (mesafe <=110 && mesafe >55){
	MOVF       _mesafe+0, 0
	MOVWF      R4+0
	MOVF       _mesafe+1, 0
	MOVWF      R4+1
	MOVF       _mesafe+2, 0
	MOVWF      R4+2
	MOVF       _mesafe+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      92
	MOVWF      R0+2
	MOVLW      133
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main21
	MOVF       _mesafe+0, 0
	MOVWF      R4+0
	MOVF       _mesafe+1, 0
	MOVWF      R4+1
	MOVF       _mesafe+2, 0
	MOVWF      R4+2
	MOVF       _mesafe+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      92
	MOVWF      R0+2
	MOVLW      132
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main21
L__main29:
;Distance_measure.c,121 :: 		Tone2();
	CALL       _Tone2+0
;Distance_measure.c,122 :: 		}
	GOTO       L_main22
L_main21:
;Distance_measure.c,123 :: 		else if (mesafe <= 55&& mesafe >2){
	MOVF       _mesafe+0, 0
	MOVWF      R4+0
	MOVF       _mesafe+1, 0
	MOVWF      R4+1
	MOVF       _mesafe+2, 0
	MOVWF      R4+2
	MOVF       _mesafe+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      92
	MOVWF      R0+2
	MOVLW      132
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main25
	MOVF       _mesafe+0, 0
	MOVWF      R4+0
	MOVF       _mesafe+1, 0
	MOVWF      R4+1
	MOVF       _mesafe+2, 0
	MOVWF      R4+2
	MOVF       _mesafe+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      0
	MOVWF      R0+2
	MOVLW      128
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main25
L__main28:
;Distance_measure.c,124 :: 		Tone3();
	CALL       _Tone3+0
;Distance_measure.c,125 :: 		}
L_main25:
L_main22:
L_main18:
;Distance_measure.c,126 :: 		}
	GOTO       L_main26
L_main14:
;Distance_measure.c,130 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Distance_measure.c,131 :: 		Lcd_Out(1,1,"KAZA YAPTIK");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_Distance_measure+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Distance_measure.c,132 :: 		Tone4();
	CALL       _Tone4+0
;Distance_measure.c,135 :: 		}
L_main26:
;Distance_measure.c,136 :: 		delay_ms(500);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main27:
	DECFSZ     R13+0, 1
	GOTO       L_main27
	DECFSZ     R12+0, 1
	GOTO       L_main27
	DECFSZ     R11+0, 1
	GOTO       L_main27
	NOP
	NOP
;Distance_measure.c,137 :: 		}
	GOTO       L_main5
;Distance_measure.c,140 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
