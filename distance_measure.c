#define echo PORTB.B4
#define trig PORTB.B0
// Lcd modül bağlantıları
sbit LCD_RS at RC0_bit;
sbit LCD_EN at RC1_bit;
sbit LCD_D4 at RC2_bit;
sbit LCD_D5 at RC3_bit;
sbit LCD_D6 at RC4_bit;
sbit LCD_D7 at RC5_bit;

sbit BUFFER at RD0_bit;

// Pin veri yönü
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
                  RBIE_bit = 0;// bağlantı noktası değişikliği kesmesini devre dışı bırak
                  if(echo){ //echo pini 1
                                 TMR1L  = 0;                               //Timer1 sayıcısının düşük değerlikli bitini tutan kaydedici
                                 TMR1H  = 0;                               // Timer1 sayıcısının yüksek değerlikli bitini tutan kaydedici
                                 T1CON.TMR1ON = 1;// Zamanlayıcıyı Etkinleştir1
                                 }
                  if(!echo){ //echo pini 0
                                 zaman = (TMR1H<<8) | (TMR1L) ;          // Zamanlayıcı Değerini Okur
                                 T1CON.TMR1ON = 0;// zamanlayıcıyı devre dışı bırakır

                                 }
                  RBIF_bit = 0;                 // Kesme bayrağı bitini temizle
                  }
     RBIE_bit = 1;// Bağlantı noktası değişikliği kesmesini etkinleştir
     }

void Tone1() {
  Sound_Play(500, 200);   // frekans, süre
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



     Lcd_Init();                      //display bağlantılarını oku
     Lcd_Cmd(_LCD_CLEAR);              // Lcd modülünü başlatın
     Lcd_Cmd(_LCD_CURSOR_OFF);        // LCD ekranın imleci
     Lcd_Out(1,1,"HOSGELDINIZ");
       delay_ms(1000);              // 1 saniye gecikme
     Lcd_Cmd(_LCD_CLEAR);
     Lcd_Out(1,1,"FERHAT_YAMAN");
     Lcd_Out(2,1,"170421829");
       delay_ms(1000);            // 1 saniye gecikme
     Lcd_Cmd(_LCD_CLEAR);           // LCD ekranı temizle

     INTCON.GIE = 1;             // gloabal interruptı etkinleştirdik
     INTCON.RBIE = 1;          // Bağlantı noktası değişikliğini etkinleştir

     T1CON.TMR1ON = 0;        // Timer1'i devre dışı bırak
     T1CON.TMR1CS = 0;        // Timer1 internal clock kaynağı (Fosc/4)  // zamanlayıcı yaptık
     T1CON.T1CKPS1 = 0;       // 1:2 Presclar değeri
     T1CON.T1CKPS0 = 1;

     zaman = 0;
     mesafe = 0;

     while(1){
              trig =1; //tetikleme palsi          //Sensör Tetik pininde en az 10µs darbeye ihtiyaç duyar
              delay_us(10); //(10us)
              trig = 0;
              while(!echo);             //ECHO "H" olana kadar bekle
              T1CON.TMR1ON = 1;         //Timer1'i başlat
              while(echo);               //ECHO "L" olana kadar bekle
              T1CON.TMR1ON = 0;          //Timer1'i durdur.


              mesafe = zaman*(0.034 / 2);
              if( mesafe >=2 && mesafe <=800 ) {     // Geçerli mesafe için durumu kontrol edin
                        Lcd_Out(2,7,"cm");
                        Lcd_Out(1,1,"Mesafe:");
                        floatToStr(mesafe,text); //veri dönüştürme
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