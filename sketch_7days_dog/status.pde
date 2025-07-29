class Status {
  int hunger;      // 満腹度
  int energy;      // 元気（体力）
  int sleepiness;  // 眠気

  // 初期値の設定（すべて30からスタート）
  Status() {
    hunger = 30;
    energy = 30;
    sleepiness = 30;
  }

  // ごはんをあげたときの処理
  void feed() {
    hunger = min(hunger + 30, 100);       // 満腹度を上げる（最大100）
    energy = min(energy + 10, 100);       // 少し元気になる
    sleepiness = min(sleepiness + 10, 100); // 少し眠くなる
  }

  // 遊んだときの処理
  void play() {
    energy = min(energy + 30, 100);       // 元気になる
    hunger = max(0, hunger - 20);         // お腹が減る
    sleepiness = min(sleepiness + 20, 100); // 眠くなる
  }

  // 寝たときの処理
  void sleep() {
    sleepiness = max(0, sleepiness - 30); // 眠気が減る
    energy = min(energy + 20, 100);       // 元気が回復
    hunger = max(0, hunger - 10);         // 少しお腹が減る
  }

  // ステータスを画面に表示
  void display(float x, float y) {
    fill(0);
    textSize(height * 0.04);
    text("満腹度: " + hunger, x, y + 10);
    text("元気: " + energy, x, y + 30);
    text("眠気: " + sleepiness, x, y + 50);
  }
}
