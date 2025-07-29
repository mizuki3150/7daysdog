class Button {
  float x, y, w, h; // ボタンの位置とサイズ
  String label; // ボタンのテキスト
  Runnable action; // ボタンクリック時に実行する処理

  // コンストラクタ（ボタンの情報を設定）
  Button(float x, float y, float w, float h, String label, Runnable action) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
    this.action = action;
  }

  // ボタンの表示
  void display() {
    fill(200, 230, 250);
    rect(x, y, w, h, 10); // 丸みを帯びた長方形
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(18);
    text(label, x + w / 2, y + h / 2); // 中央にラベル表示
  }

  // クリックされたかどうかを判定
  boolean isClicked(int mx, int my) {
    return mx > x && mx < x + w && my > y && my < y + h;
  }

  // クリックされたときの処理を実行
  void onClick() {
    if (action != null) {
      action.run(); // アクションを実行
    }
  }
}
