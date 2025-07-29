class Status{
  int hunger;
  int energy;
  int sleepiness;
  Status(){
    hunger = 30;
    energy = 30;
    sleepiness = 30;
  }
  void feed(){
    hunger = min(hunger + 30,100);
    energy = min(energy + 10, 100);
    sleepiness = min(sleepiness + 10, 100);
  }
  void play(){
    energy = min(energy + 30, 100);
    hunger = max(0,hunger - 20);
    sleepiness = min(sleepiness + 20, 100);
  }
  void sleep(){
    sleepiness = max(0,sleepiness - 30);
    energy = min(energy + 20, 100);
    hunger = max(0,hunger - 10);
  }
  void display(float x, float y){
    fill(0);
    textSize(height * 0.04);
    // text() は表示したい文字列を第1引数にまとめて渡す必要があります
    text("満腹度: " + hunger, x, y + 10);
    text("元気: " + energy, x, y + 30);
    text("眠気: " + sleepiness, x, y + 50);
  }
}
