#line 1 "C:/Users/ferhat/Desktop/Notlar/mikrodenetleyici/proje/micro_c/Distance_measure.c"



sbit LCD_RS at RC0_bit;
sbit LCD_EN at RC1_bit;
sbit LCD_D4 at RC2_bit;
sbit LCD_D5 at RC3_bit;
sbit LCD_D6 at RC4_bit;
sbit LCD_D7 at RC5_bit;

sbit BUFFER at RD0_bit;


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
 RBIE_bit = 0;
 if( PORTB.B4 ){
 TMR1L = 0;
 TMR1H = 0;
 T1CON.TMR1ON = 1;
 }
 if(! PORTB.B4 ){
 zaman = (TMR1H<<8) | (TMR1L) ;
 T1CON.TMR1ON = 0;

 }
 RBIF_bit = 0;
 }
 RBIE_bit = 1;
 }

void Tone1() {
 Sound_Play(500, 200);
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
 TRISB0_bit = 0;
 TRISB4_bit = 1;
 TRISC=0;
 TRISD=0b00000000;



 Sound_Init(&PORTD, 0);
 Sound_Play(1000,100);



 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,1,"HOSGELDINIZ");
 delay_ms(1000);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"FERHAT_YAMAN");
 Lcd_Out(2,1,"170421829");
 delay_ms(1000);
 Lcd_Cmd(_LCD_CLEAR);

 INTCON.GIE = 1;
 INTCON.RBIE = 1;

 T1CON.TMR1ON = 0;
 T1CON.TMR1CS = 0;
 T1CON.T1CKPS1 = 0;
 T1CON.T1CKPS0 = 1;

 zaman = 0;
 mesafe = 0;

 while(1){
  PORTB.B0  =1;
 delay_us(10);
  PORTB.B0  = 0;
 while(! PORTB.B4 );
 T1CON.TMR1ON = 1;
 while( PORTB.B4 );
 T1CON.TMR1ON = 0;


 mesafe = zaman*(0.034 / 2);
 if( mesafe >=2 && mesafe <=800 ) {
 Lcd_Out(2,7,"cm");
 Lcd_Out(1,1,"Mesafe:");
 floatToStr(mesafe,text);
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
