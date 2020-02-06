/*---------------NOT------------------------
UYGULAMA fullScrenn(); FONKSİYONU İÇERMEKTEDİR.
UYGULAMAYI DİNAMİKLEŞTİRMEK İÇİN EKSTRADAN HER SATIR İÇİN TOP YERLEŞTİRİLDİ.
--------------------------------------------*/

ArrayList<Dikdortgen> dizi = new ArrayList<Dikdortgen>();//Dinamiklik için Dikdörtgen listesi
ArrayList<ball> bDizi = new ArrayList<ball>();//Dinamiklik için Top listesi.

boolean den=false;
int tops=1;//top sayısı
int durum;//ekranlar arası geçiş 

PVector temp=new PVector(0,0);

int skor=0;//Oyun içi skor değişkeni.
int sayac=0;//Dikdörtgen sayacı
int c=-25;//Dikdörtgenleri renklendirmek için renk sabiti

//Oyunun daha dinamik hale gelmesi için her satıra rastgele top konumu değişkenleri
int s5 =(int)random(35,44);//5. satır
int s4= (int)random(25,34);//4. satır
int s3=(int)random(15,24);//3. satır
int s2=(int)random(5,14);//2. satır

void setup(){
  bDizi.add(new ball (new PVector (width/2,height/2)) );
  fullScreen();//(1290,1080)
  noCursor();//mouse imleci yok eden fonksiyon
  colorMode(HSB);//renklendirme tip dönüşümü
  background(0);
  
  durum=0;//ilk ekrana geçiş yapabilmek için durumu 0 konumuna getiriyoruz.
  
  float y2=5;//İlk oluşan dikdörtgenin sol kenar uzaklığı
    for(int i=0;i<5;i++){//satır sayısı
      float x2=35;//oluşan her dikdörtgenin x kordinat uzunluğu
      for(int j=0;j<9;j++){//sutün sayısı
      /*-------------
      Her satır için oluştruduğumuz rastgele sayıların istediğimiz dikdörgene
      denk gelmesi için kontrol grubu yazıyoruz.
      ---------------*/
        if(sayac==s5 || sayac == s4 || sayac == s3 || sayac == s2)  {dizi.add(new Dikdortgen(x2,y2,c,true));}
        dizi.add(new Dikdortgen(x2,y2,c,false));
        x2+=205;
        sayac++;//Toplam dikdörgen sayısına(45) ulaşacak değişken.(1~45)
      }
      c+=50;//Her satır için renk değişkenini değiştiriyoruz.
      y2+=50;//her dikdörtgen arası mesafe
   }

}//end of setup

void draw(){
  kazandi();
  skor();
  //can();
  if(durum==0){//Başlangıç ekranı
    girisEkrani();
  }
  
  else if(durum==1){//Oyun ekranı
    //------
    //Hareket eden nesnelerin sürüklenme hissi vermesi için arkaplanı kendimiz oluşturuyoruz.
    fill(0, 50);
    noStroke();
    rect(0, 0, width, height);
    //------
    
    fill(#FF6600);//kontrol edebildiğimiz dikdörtgenin rengi
    rect(mouseX-50,1060, 150, 20);//kontrol edebildiğimiz dikdörtgenin konumu
    
    for(Dikdortgen dikd : dizi){//Dikdörtgen dizi kadar dönen döngü
      dikd.ciz();
      int k=0;
      for(ball b : bDizi){//Top sayısı dizi kadar dönen döngü
        dikd.degdiMi(b.kord.x,b.kord.y,k);//topun dikdörtgenlere değip değmemesini kontrol eden fonksiyon.
        k++;
      }
    }
    for(ball b : bDizi){
      b.top(); 
    }
  }//end of durum==1
  
  else if(durum==2){//Oyun kaybedilirse
    background(0);
    fill(155);
    textSize(60);
    text("Tek canın vardı onu da iyi kullanamadın..", width/2, height/2);
    textSize(40);
    fill(#ED002C);
    text("Ayrıca bu oyunda yenildiysen hiç bekleme 'ESC' tuşuna bas.", width/2, height/2+200);
  }//end of durum==2
  
  else if(durum==3){
    background(0,255,0);
    textSize(100);
    fill(0,100,0);
    textAlign(CENTER);
    text("Kazandın, iyisin he!",width/2,height/2);
    textSize(25);
    fill(random(0,255));
    text("Tekrar kazanmak istiyorsan 'Enter' tuşuna bas.", width/2,height/2+135);
  }//end of durum==3
  
  if(den){bDizi.add(new ball(new PVector(temp.x+100,temp.y+45+10)));den=false;tops++;}
  
}//end of draw

//------------------------------------------------
//CLASS VE FONKSİYONLARIN BAŞLANGIÇ ALANI

void keyPressed(){
  if(keyCode==ENTER && durum==0){
    durum=1;
  }
  else if((keyCode==ENTER) && ((durum==2)||(durum==3)) ){
    durum=0;  
  }
}//end of klavyeKontrol

void girisEkrani(){
  background(0);
  fill(255);
    textAlign(CENTER);
    textSize(50);
    fill(#401FDB);
    textSize(100);
    text("TOPÇUĞUN GAZABI",width/2,height/2-100);
    textSize(50);
    fill(255);
    text("Oyuna başlamak için 'Enter' tuşuna basın.",width/2,height/2+25);
    textSize(25);
    fill(255);
    text("Oyunun kuralları oldukça basittir. Fareyi kullanarak topçuk ile her şeyi kır.",width/2,height-260);
    text("Tek bir canın var, iyi kullan. ;) ",width/2,height-230);
}//end of girisEkrani()

class Dikdortgen{
  boolean event=false;
  float x2;
  float y2;
  float yukseklik=45;
  boolean aktif=true;
  int cc=c;
  
  Dikdortgen(float xx,float yy,int ccc,boolean ev){//yapıcı
    x2=xx;  y2=yy; cc=ccc; event=ev;
  }
  
  void  ciz(){
     if(aktif){
       fill(cc,200,2000);
       rect(x2, y2, 200, 45);
     }
  }
  
  void degdiMi(float x,float y,int i){//dikdortgen yok edici
    if(aktif){
    int a=0;
    float xTopKor=x, yTopKor=y;
    
    //dikdörtgenin alt kısmı için kontrol
    if(xTopKor>=x2 && xTopKor<=x2+200 && yTopKor>=y2+45 && yTopKor<=y2+47) {
      bDizi.get(i).my*=-1;
      a++;
    }
    //dikdörtgenin sol kısmı için kontrol
    else if(xTopKor>=x2-3 && xTopKor<=x2 && yTopKor>=y2 && yTopKor<=y2+45) {
      bDizi.get(i).mx*=-1;
      a++;
    }
    //dikdörtgenin üst kısmı için kontrol
    else if(xTopKor>=x2 && xTopKor<=x2+200 && yTopKor>=y2-3 && yTopKor<=y2) {
      bDizi.get(i).my*=-1;
      a++;
    }
    //dikdörtgenin sağ kısmı için kontrol
    else if(xTopKor>=x2+200 && xTopKor<=x2+200+3 && yTopKor>=y2 && yTopKor<=y2+45){ 
      bDizi.get(i).mx*=-1;
      a++;
    }
    
    if(a>0){
      if(event) {den=true; event=false; temp.x=x2; temp.y=y2;}
    aktif=false;
    skor++;
    }
    
    }//end of main if
   }//end of degdiMi func
  }//end of Dikdortgen class
  
class ball{
  PVector kord;
  float mx=4;
   float my=5;
   boolean aktif=true;
  ball(PVector a){kord=a;}
  void top() {
    if(aktif){
    ellipse(kord.x, kord.y, 20, 20);
    kord.x+=mx;
    kord.y+=my;
    
    if(kord.x<10 || kord.x>width-10) {//topun köşelere vurduğunda yön değiştirmesi için
      mx*=-1;
    }
    
    if (kord.x>mouseX-50 && kord.x<mouseX+150 && kord.y>1060 && kord.y<1080 || kord.y<0) {//1080 ekran y değeri-hareketli dikdörtgene çarptığında yön değiştirmesi için
      my*=-1;
    }
    if (kord.y>height) {
      tops--;
      aktif=false;
      if(tops==0) {durum=2;}
    }
   }
  }//end of top
}
  
  void skor() {
    fill(60);
    textSize(300);
    text(skor, width/2 , height/2+150 );
  }
  
  void kazandi() {
    if(skor==45+4){
    durum=3;
    }
  } 
