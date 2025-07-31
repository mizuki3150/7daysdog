interface IScreen { //<>//
  void display(); // 画面を描画
  boolean handleClick(int mx, int my); // クリック処理（画面遷移があればtrue）
}

GameManager gm;

void setup() {
  size(640, 480);
  PFont font = createFont("メイリオ", 50); // 日本語フォント設定
  textFont(font);
  gm = new GameManager(); // ゲーム管理クラス初期化
}

void draw() {
  background(255); // 背景白
  gm.display(); // 画面描画
}

void mousePressed() {
  gm.handleClick(mouseX, mouseY); // クリック処理
}

class GameManager {
  private IScreen currentScreen; // 現在の画面
  private Pet pet;
  private int actionCount = 0; // 時間管理用カウンタ
  private final int ACTIONS_PER_DAY = 3;
  private final int TOTAL_DAYS = 7;
  private final int MAX_CNT = ACTIONS_PER_DAY * TOTAL_DAYS;
  private String[] times = {"朝", "昼", "晩"}; // 時間帯

  private Button feedButton, playButton, sleepButton; // 各種ボタン

  PImage[] selectedDogImage; // 選ばれた犬の画像
  PImage bgMorning, bgNoon, bgNight; // 背景画像（未使用）

  GameManager() {
    currentScreen = new TitleScreen(); // 初期画面
    // 各ボタンの初期化と処理
    feedButton = new Button(width * 0.17, height * 0.7, width * 0.18, height * 0.08, "ごはん", () -> {
      if (pet != null) pet.feed();
      incrementActionCount();
    }
    );
    playButton = new Button(width * 0.44, height * 0.7, width * 0.18, height * 0.08, "遊ぶ", () -> {
      if (pet != null) pet.play();
      incrementActionCount();
    }
    );
    sleepButton = new Button(width * 0.71, height * 0.7, width * 0.18, height * 0.08, "ねる", () -> {
      if (pet != null) pet.sleep();
      incrementActionCount();
    }
    );


    // 背景画像の読み込み
    bgMorning = loadImage("morning.jpg");
    bgNoon = loadImage("noon.jpg");
    bgNight = loadImage("night.jpg");
  }

  void incrementActionCount() {
    if (actionCount < MAX_CNT) actionCount++;
  }

  int getDay() {
    return actionCount / ACTIONS_PER_DAY + 1;
  }

  String getTime() {
    return times[actionCount % ACTIONS_PER_DAY];
  }

  boolean isGameOver() {
    return actionCount >= MAX_CNT;
  }

  void display() {
    // 1) ――― 背景 ―――
    if (currentScreen instanceof Pet) {
      // 時間帯に応じて背景画像を選択
      int timeIndex = actionCount % 3;

      PImage selectedBg = null;
      if (timeIndex == 0) {
        selectedBg = bgMorning;
      } else if (timeIndex == 1) {
        selectedBg = bgNoon;
      } else {
        selectedBg = bgNight;
      }

      // 背景画像があれば表示、なければグレー
      if (selectedBg != null) {
        image(selectedBg, 0, 0, width, height);
      } else {
        background(200); // 画像読み込み失敗時
      }
    }

    // 2) ――― 画面本体 ―――
    currentScreen.display();

    // 3) ――― UI (Pet 画面のみ) ―――
    if (currentScreen instanceof Pet) {
      feedButton.display();
      playButton.display();
      sleepButton.display();

      float ts = height * 0.05;
      textSize(ts);
      float boxX = width * 0.02;
      float boxY = height * 0.04;
      float padding = ts * 0.5f;

      float boxW = textWidth("日数: " + getDay() + "日目");
      float boxW2 = textWidth("時間帯: " + getTime());
      float boxWFinal = max(boxW, boxW2) + padding * 2;

      float boxH = ts * 2 + padding * 2;

      fill(230);
      noStroke();
      rect(boxX, boxY, boxWFinal, boxH, 8);

      fill(0);
      textAlign(LEFT, TOP);
      textSize(ts);
      text("日数: " + getDay() + "日目", boxX + padding, boxY + padding);
      text("時間帯: " + getTime(), boxX + padding, boxY + padding + ts * 1.2);
    }
    // ゲーム終了判定 → EndScreen へ切替
    if (pet != null && isGameOver() && !(currentScreen instanceof EndScreen) && !(currentScreen instanceof AlbumScreen)) {
      currentScreen = new EndScreen();
    }
  }

  void setCurrentScreen(IScreen screen) {
    currentScreen = screen;
  }
 
  void handleClick(int mx, int my) {
    boolean screenChangeRequested = currentScreen.handleClick(mx, my);
    // 画面遷移の処理
    if (screenChangeRequested) {
      if (currentScreen instanceof TitleScreen) {
        currentScreen = new SelectionScreen();
      } else if (currentScreen instanceof SelectionScreen) {
        selectedDogImage = ((SelectionScreen)currentScreen).getSelectedDogImage();
        pet = new Pet(selectedDogImage);
        actionCount = 0;
        currentScreen = pet;
      } else if (currentScreen instanceof EndScreen) {
        // 再スタート時はタイトル画面に戻す
        currentScreen = new TitleScreen();
        actionCount = 0;
        pet = null;
      }
    } else {
      // ボタンのクリック判定（育成画面）
      if (currentScreen instanceof Pet) {
        if (feedButton.isClicked(mx, my)) feedButton.onClick();
        else if (playButton.isClicked(mx, my)) playButton.onClick();
        else if (sleepButton.isClicked(mx, my)) sleepButton.onClick();
      }
    }
  }
}

// タイトル画面
class TitleScreen implements IScreen {
  Button startGameButton;

  TitleScreen() {
    // ボタンの位置とサイズを計算
    float x = width * (1.0/3);
    float y = height * 0.7;
    float w = width * 0.3;
    float h = height * 0.1;

    // ボタン初期化とアクション定義
    startGameButton = new Button(x, y, w, h, "ゲーム開始", () -> {
      println("ゲーム開始ボタンが押されました！");
    }
    );
  }

  void display() {
    background(255);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(height * 0.07);
    text("犬と私の1週間", width / 2, height / 3);
    startGameButton.display(); // ボタンの描画
  }

  boolean handleClick(int mx, int my) {
    if (startGameButton.isClicked(mx, my)) {
      startGameButton.onClick();
      return true; // 画面遷移要求
    }
    return false;
  }
}

// 選択画面
class SelectionScreen implements IScreen {
  PImage[] dog1 = new PImage[4]; // 犬1の画像
  PImage[] dog2 = new PImage[4]; // 犬2の画像
  float imgW, imgH;
  float dog1X, dog1Y, dog2X, dog2Y; // 犬画像の位置
  float btnW, btnH, btnX, btnY; // ボタン位置
  boolean dog1Selected = false; // 選択状態
  Button confirmButton; // 「この子にする」ボタン

  SelectionScreen() {
    for (int i = 0; i < dog1.length; i++) {
      dog1[i] = loadImage("dog1_"+i+".png");
      dog2[i] = loadImage("dog2_"+i+".png");
    }
    // レイアウトとボタン初期化
    imgW = width * 0.3;
    imgH = height * 0.32;
    dog1X = width * 0.15;
    dog1Y = height * 0.35;
    dog2X = width * 0.55;
    dog2Y = height * 0.35;
    btnW = width * 0.4;
    btnH = height * 0.08;
    btnX = width / 2 - btnW / 2;
    btnY = height * 0.85 - btnH / 2;
    confirmButton = new Button(btnX, btnY, btnW, btnH, "この子にする", () -> {
      println("この子にするボタンが押されました！");
    }
    );
  }

  void display() {
    background(255);
    textAlign(CENTER);
    textSize(height * 0.05);
    fill(0);
    text("どの子と過ごす？", width / 2, height * 0.21);
    imageMode(CORNER);
    image(dog1[0], dog1X, dog1Y, imgW, imgH);
    image(dog2[0], dog2X, dog2Y, imgW, imgH);

    // 選ばれた犬に枠線を描画
    noFill();
    stroke(255, 0, 0);
    strokeWeight(4);
    if (dog1Selected) {
      rect(dog1X, dog1Y, imgW, imgH);
    } else {
      rect(dog2X, dog2Y, imgW, imgH);
    }
    strokeWeight(1);
    stroke(0);
    confirmButton.display();
  }

  boolean handleClick(int mx, int my) {
    if (mx > dog1X && mx < dog1X + imgW && my > dog1Y && my < dog1Y + imgH) {
      dog1Selected = true;
      println("犬1が選ばれました！");
      return false; // 犬選択は画面切り替えではないのでfalse
    } else if (mx > dog2X && mx < dog2X + imgW && my > dog2Y && my < dog2Y + imgH) {
      dog1Selected = false;
      println("犬2が選ばれました！");
      return false;
    } else if (confirmButton.isClicked(mx, my)) {
      confirmButton.onClick();
      return true; // 確定ボタンが押されたらtrueを返す
    }
    return false; // それ以外はfalse
  }

  PImage[] getSelectedDogImage() {
    if (dog1Selected) {
      return dog1;
    } else {
      return dog2;
    }
  }
}

//終了画面
class EndScreen implements IScreen {
  Button restartButton;
  Button albumButton;

  EndScreen() {
    float btnW = width * 0.3;
    float btnH = height * 0.1;

    float restartX = width / 2 - btnW / 2;
    float restartY = height * 0.75;
    restartButton = new Button(restartX, restartY, btnW, btnH, "もう一度遊ぶ", () -> {
      println("再スタートボタンが押されました！");
    }
    );

    float albumX = width / 2 - btnW / 2;
    float albumY = height * 0.6;
    albumButton = new Button(albumX, albumY, btnW, btnH, "アルバムを見る", () -> {
      println("アルバムボタンが押されました！");
    }
    );
  }

  void display() {
    background(255);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(height * 0.06);
    text("1週間が終了しました！", width / 2, height / 3);
    albumButton.display();
    restartButton.display();
  }

  boolean handleClick(int mx, int my) {
    if (albumButton.isClicked(mx, my)) {
      albumButton.onClick();
      gm.setCurrentScreen(new AlbumScreen(gm.selectedDogImage)); // ←画面遷移
      return false;
    }
    if (restartButton.isClicked(mx, my)) {
      restartButton.onClick();
      return true;
    }
    return false;
  }
}

class AlbumScreen implements IScreen {
  PImage[] dogImages;
  int currentIndex = 0;
  Button nextButton;
  Button backButton;

  AlbumScreen(PImage[] dogImages) {
    this.dogImages = dogImages;

    float btnW = width * 0.2;
    float btnH = height * 0.08;

    nextButton = new Button(width * 0.65, height * 0.8, btnW, btnH, "次へ", () -> {
      currentIndex = (currentIndex + 1) % dogImages.length;
    }
    );

    backButton = new Button(width * 0.15, height * 0.8, btnW, btnH, "戻る", () -> {
      gm.setCurrentScreen(new EndScreen()); // エンド画面に戻る
    }
    );
  }

  void display() {
    background(255);
    if (dogImages != null && dogImages[currentIndex] != null) {
      imageMode(CENTER);
      image(dogImages[currentIndex], width / 2, height / 2 - 30, width * 0.6, height * 0.5);
    }

    fill(0);
    textAlign(CENTER, CENTER);
    textSize(height * 0.05);
    text("アルバム", width / 2, height * 0.1);

    nextButton.display();
    backButton.display();
  }

  boolean handleClick(int mx, int my) {
    if (nextButton.isClicked(mx, my)) {
      nextButton.onClick();
    } else if (backButton.isClicked(mx, my)) {
      backButton.onClick();
    }
    return false;
  }
}
