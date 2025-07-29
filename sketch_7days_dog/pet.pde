class Pet implements IScreen{
  Status status;
  PImage dog;

  Pet(PImage img) {
    status = new Status();
    dog = img; // 受け取った画像を保存
  }
  
  void display() {
    float imgDisplayWidth = width / 3;
    float imgDisplayHeight = height / 2;
    float imgDisplayX = 320 - imgDisplayWidth / 2; // 中心から左に幅の半分
    float imgDisplayY = 200 - imgDisplayHeight / 2; // 中心から上に高さの半分
    
    image(dog, imgDisplayX, imgDisplayY, imgDisplayWidth, imgDisplayHeight);
    
    status.display(width * 0.1, height * 0.8); // ステータス表示
  }
  
  boolean handleClick(int mx, int my) {
    // メイン画面でのクリック処理はここに追加（例：犬をなでるボタンなど）
    return false; 
  }
  
  void feed() {
    status.feed();
  }
  
  void play() {
    status.play();
  }
  
  void sleep() {
    status.sleep();
  }
}
