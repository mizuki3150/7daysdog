class Button {
  float x, y, w, h;
  String label;
  Runnable action;  // 実行するアクション（ラムダ式やメソッド参照）
  Button(float x, float y, float w, float h, String label, Runnable action) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
    this.action = action;
  }
  
  void display() {
    fill(200, 230, 250);
    rect(x, y, w, h, 10);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(18);
    text(label, x + w/2, y + h/2);
  }
  
  boolean isClicked(int mx, int my) {
    return mx > x && mx < x + w && my > y && my < y + h;
  }
  
  void onClick() {
    if (action != null) {
      action.run();
    }
  }
}
