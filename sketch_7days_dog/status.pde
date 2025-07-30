class Status {
  int hunger;      // 満腹度（100が満腹）
  int vitality;    // 活力（100が元気いっぱい）
  int fatigue;     // 疲労回復度（100が疲労なし）

  final int maxValue = 100;

  Status() {
    hunger = 30;
    vitality = 30;
    fatigue = 30;
  }

  void chargeEnergy() {
    hunger = min(hunger + 30, maxValue);
    vitality = min(vitality + 5, maxValue);  // 少しお腹減る
    fatigue = min(fatigue + 5, maxValue);    // 少し疲労減る
  }

  void exercise() {
    vitality = min(vitality + 30, maxValue);  // 活力大幅アップ
    hunger = max(hunger - 15, 0);             // 少しお腹減る
    fatigue = max(fatigue - 10, 0);           // 少し疲労増える（疲労回復度が減る）
  }

  void rest() {
    fatigue = min(fatigue + 40, maxValue);    // 疲労回復大幅アップ
    vitality = min(vitality + 10, maxValue);  // 活力も少し増える
    hunger = max(hunger - 10, 0);              // お腹は少し減る
  }


  // ステータス表示
  void display(float x, float y) {
    float labelW = width * 0.15;     // ラベルの幅
    float barW = width * 0.6;        // バーの幅
    float barH = height * 0.04;     // バーの高さ
    float spacing = height * 0.07;   // 行間

    textSize(height * 0.04);
    textAlign(LEFT, CENTER);
    textLeading(spacing);

    drawStatusBar("満腹度", hunger, x, y, labelW, barW, barH);
    drawStatusBar("活力", vitality, x, y + spacing, labelW, barW, barH);
    drawStatusBar("疲労回復度", fatigue, x, y + spacing * 2, labelW, barW, barH);
  }

  // ステータス1項目の表示
  void drawStatusBar(String label, int value, float x, float y, float labelW, float barW, float barH) {
    fill(0);
    text(label, x - 1, y + barH / 2);
    text(label, x + 1, y + barH / 2);
    text(label, x, y + barH / 2 - 1);
    text(label, x, y + barH / 2 + 1);

    // 本体（黒文字を中央に重ねる
    fill(255);
    text(label, x, y + barH / 2);

    // バーの背景
    float barX = x + labelW;
    float barY = y;
    fill(255);
    stroke(0);
    rect(barX, barY, barW, barH, 5);

    // バーの中身
    float filledW = map(value, 0, maxValue, 0, barW);
    noStroke();
    fill(100, 180, 255);
    rect(barX, barY, filledW, barH, 5);

    // 数値表示
    fill(0);
    textAlign(RIGHT, CENTER);
    text(value + " / " + maxValue, barX + barW - 5, barY + barH / 2);

    // 左寄せに戻す
    textAlign(LEFT, CENTER);
  }
}
