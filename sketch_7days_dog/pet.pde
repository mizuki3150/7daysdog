class Pet implements IScreen {
  Status status; // ごはん・遊び・ねむりの状態
  PImage[] dog; // 犬の画像（表情など）
  int imageIndex; // 現在表示している犬の画像番号

  // コンストラクタ（選ばれた犬の画像を受け取る）
  Pet(PImage[] img) {
    status = new Status();
    dog = img;
    imageIndex = 0;
  }

  // 育成画面の表示（犬の画像とステータス）
  void display() {
    imageMode(CORNER);
    float imgDisplayWidth = width * 0.4;
    float imgDisplayHeight = height * 0.4;
    float imgDisplayX = (width - imgDisplayWidth) / 2;
    float imgDisplayY = (height - imgDisplayHeight) / 3;

    image(dog[imageIndex], imgDisplayX, imgDisplayY, imgDisplayWidth, imgDisplayHeight);

    status.display(width * 0.1, height * 0.8); // ステータス表示
  }

  // クリック処理（今は何もしない）
  boolean handleClick(int mx, int my) {
    // メイン画面でのクリック処理はここに追加（例：犬をなでるボタンなど）
    return false;
  }

  void feed() {
    status.chargeEnergy();
    imageIndex = 1;
  }

  void play() {
    status.exercise();
    imageIndex = 2;
  }

  void sleep() {
    status.rest();
    imageIndex = 3;
  }
}
