#define echo PORTB.B4
#define trig PORTB.B0
// Lcd mod�l ba�lant�lar�
sbit LCD_RS at RC0_bit;
sbit LCD_EN at RC1_bit;
sbit LCD_D4 at RC2_bit;
sbit LCD_D5 at RC3_bit;
sbit LCD_D6 at RC4_bit;
sbit LCD_D7 at RC5_bit;

sbit BUFFER at RD0_bit;

// Pin veri y�n�
sbit LCD_RS_Direction at TRISC0_bit;
sbit LCD_EN_Direction at TRISC1_bit;
sbit LCD_D4_Direction at TRISC2_bit;
sbit LCD_D5_Direction at TRISC3_bit;
sbit LCD_D6_Direction at TRISC4_bit;
sbit LCD_D7_Direction at TRISC5_bit;


unsigned int zaman;
float mesafe;
char text[15];

void interrupt(){
     if(RBIF_bit){
                  RBIE_bit = 0;// ba�lant� noktas� de�i�ikli�i kesmesini devre d��� b�rak
                  if(echo){ //echo pini 1
                                 TMR1L  = 0;                               //Timer1 say�c�s�n�n d���k de�erlikli bitini tutan kaydedici
                                 TMR1H  = 0;                               // Timer1 say�c�s�n�n y�ksek de�erlikli bitini tutan kaydedici
                                 T1CON.TMR1ON = 1;// Zamanlay�c�y� Etkinle�tir1
                                 }
                  if(!echo){ //echo pini 0
                                 zaman = (TMR1H<<8) | (TMR1L) ;          // Zamanlay�c� De�erini Okur
                                 T1CON.TMR1ON = 0;// zamanlay�c�y� devre d��� b�rak�r

                                 }
                  RBIF_bit = 0;                 // Kesme bayra�� bitini temizle
                  }
     RBIE_bit = 1;// Ba�lant� noktas� de�i�ikli�i kesmesini etkinle�tir
     }

void Tone1() {
  Sound_Play(500, 200);   // frekans, s�re
}

void Tone2() {
  Sound_Play(600, 400);
}

void Tone3() {
  Sound_Play(700, 700);
}

void Tone4() {
  Sound_Play(1000, 2000);
}



void main() {
     TRISB0_bit = 0;// Trigger pin
     TRISB4_bit = 1;// Echo pin
     TRISC=0;
     TRISD=0b00000000; //BUZZER


     
     Sound_Init(&PORTD, 0);
     Sound_Play(1000,100);



     Lcd_Init();                      //display ba�lant�lar�n� oku
     Lcd_Cmd(_LCD_CLEAR);              // Lcd mod�l�n� ba�lat�n
     Lcd_Cmd(_LCD_CURSOR_OFF);        // LCD ekran�n imleci
     Lcd_Out(1,1,"HOSGELDINIZ");
       delay_ms(1000);              // 1 saniye gecikme
     Lcd_Cmd(_LCD_CLEAR);
     Lcd_Out(1,1,"FERHAT_YAMAN");
     Lcd_Out(2,1,"170421829");
       delay_ms(1000);            // 1 saniye gecikme
     Lcd_Cmd(_LCD_CLEAR);           // LCD ekran� temizle

     INTCON.GIE = 1;             // gloabal interrupt� etkinle�tirdik
     INTCON.RBIE = 1;          // Ba�lant� noktas� de�i�ikli�ini etkinle�tir

     T1CON.TMR1ON = 0;        // Timer1'i devre d��� b�rak
     T1CON.TMR1CS = 0;        // Timer1 internal clock kayna�� (Fosc/4)  // zamanlay�c� yapt�k
     T1CON.T1CKPS1 = 0;       // 1:2 Presclar de�eri
     T1CON.T1CKPS0 = 1;

     zaman = 0;
     mesafe = 0;

     while(1){
              trig =1; //tetikleme palsi          //Sens�r Tetik pininde en az 10�s darbeye ihtiya� duyar
              delay_us(10); //(10us)
              trig = 0;
              while(!echo);             //ECHO "H" olana kadar bekle
              T1CON.TMR1ON = 1;         //Timer1'i ba�lat
              while(echo);               //ECHO "L" olana kadar bekle
              T1CON.TMR1ON = 0;          //Timer1'i durdur.


              mesafe = zaman*(0.034 / 2);
              if( mesafe >=2 && mesafe <=800 ) {     // Ge�erli mesafe i�in durumu kontrol edin
                        Lcd_Out(2,7,"cm");
                        Lcd_Out(1,1,"Mesafe:");
                        floatToStr(mesafe,text); //veri d�n��t�rme
                        Ltrim(text);
                        text[5] =0;
                        Lcd_Out(2,1,text);
                        
                        
                        if(mesafe <=165 && mesafe >110){
                                  Tone1();
                        }
                        else if (mesafe <=110 && mesafe >55){
                                  Tone2();
                        }
                        else if (mesafe <= 55&& mesafe >2){
                                  Tone3();
                        }
                        }
                        

              else {
                        Lcd_Cmd(_LCD_CLEAR);
                        Lcd_Out(1,1,"KAZA YAPTIK");
                        Tone4();


                        }
              delay_ms(500);
              }


}