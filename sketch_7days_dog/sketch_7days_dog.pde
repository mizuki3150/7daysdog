interface IScreen {
  void display(); // 画面を表示
  boolean handleClick(int mx, int my); // クリック処理(画面切り替えの必要があればtrueを返す)
}

GameManager gm;

void setup() {
  size(640, 480);
  PFont font = createFont("Osaka", 50); // 日本語対応フォント
  textFont(font);
  gm = new GameManager();
}

void draw() {
  background(255);
  gm.display();
}

void mousePressed() {
  gm.handleClick(mouseX, mouseY);
}

class GameManager {
  IScreen currentScreen;
  PImage selectedDogImage;
  int cnt = 0;
  Pet pet;
  String[] times = {"朝", "昼", "晩"};
  PImage bgMorning, bgNoon, bgNight;

  Button feedButton, playButton, sleepButton;

  GameManager() {
    currentScreen = new TitleScreen();
    // 育成画面用のボタンを用意する（位置やサイズは適宜調整）
    feedButton = new Button(110, height - 150, 120, 40, "ごはん", () -> {
      if (pet != null) pet.feed();
      cnt++;
    }
    );
    playButton = new Button(260, height - 150, 120, 40, "遊ぶ", () -> {
      if (pet != null) pet.play();
      cnt++;
    }
    );
    sleepButton = new Button(410, height - 150, 120, 40, "ねる", () -> {
      if (pet != null) pet.sleep();
      cnt++;
    }
    );

    // 背景画像の読み込み
    /*
      bgMorning = loadImage("morning.png");
     bgNoon = loadImage("noon.png");
     bgNight = loadImage("night.png");
     */
  }

  void display() {
    //現在の画面表示
    currentScreen.display();
    /*
    // 背景表示（育成画面のみ）
    if (currentScreen instanceof Pet) {
      int timeIndex = cnt % 3;
      if (cnt >= 21) {
        background(100); // 終了後はグレー
      } else if (timeIndex == 0) {
        image(bgMorning, 0, 0, width, height);
      } else if (timeIndex == 1) {
        image(bgNoon, 0, 0, width, height);
      } else {
        image(bgNight, 0, 0, width, height);
      }
    } else {
      background(255); // それ以外の画面は白背景
    }
    */
    
    // 育成画面ならボタンを表示
    if (currentScreen instanceof Pet) {
      feedButton.display();
      playButton.display();
      sleepButton.display();

      // 時間・日数表示
      int day = cnt / 3 + 1;
      int timeIndex = cnt % 3;
      fill(0);
      textAlign(LEFT);
      textSize(24);

      if (cnt < 21) {
        text("日数: " + day + "日目", 20, 40);
        text("時間帯: " + times[timeIndex], 20, 70);
      } else {
        text("1週間が終了しました！", 20, 40);
      }
    }
  }
  void handleClick(int mx, int my) {
    boolean screenChangeRequested = currentScreen.handleClick(mx, my);
    if (screenChangeRequested) {
      if (currentScreen instanceof TitleScreen) {
        currentScreen = new SelectionScreen();
      } else if (currentScreen instanceof SelectionScreen) {
        selectedDogImage = ((SelectionScreen)currentScreen).getSelectedDogImage();
        pet = new Pet(selectedDogImage);
        currentScreen = pet;
      }
    } else {
      // 画面切り替えがない場合はボタンのクリック判定をする
      if (currentScreen instanceof Pet) {
        if (feedButton.isClicked(mx, my)) feedButton.onClick();
        else if (playButton.isClicked(mx, my)) playButton.onClick();
        else if (sleepButton.isClicked(mx, my)) sleepButton.onClick();
      }
    }
  }
}

// Title画面
class TitleScreen implements IScreen {
  Button startGameButton;

  TitleScreen() {
    // ボタンの位置とサイズを計算 (以前のgetButtonRect()の内容)
    float x = width * (1.0/3);
    float y = height * 0.7;
    float w = width * 0.3;
    float h = height * 0.1;

    // Buttonを初期化し、クリック時のアクションをラムダ式で定義
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
    startGameButton.display(); // ボタンの表示
  }

  boolean handleClick(int mx, int my) {
    if (startGameButton.isClicked(mx, my)) {
      startGameButton.onClick(); // アクションを実行
      return true; // 画面切り替えを要求
    }
    return false; // それ以外は切り替えなし
  }
}

// 選択画面
class SelectionScreen implements IScreen {
  PImage dog1, dog2;
  float imgW, imgH;
  float dog1X, dog1Y, dog2X, dog2Y, btnW, btnH, btnX, btnY;
  boolean dog1Selected = false;
  Button confirmButton;

  SelectionScreen() {
    dog1 = loadImage("dog1.png");
    dog2 = loadImage("dog2.png");
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
    image(dog1, dog1X, dog1Y, imgW, imgH);
    image(dog2, dog2X, dog2Y, imgW, imgH);
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

  PImage getSelectedDogImage() {
    if (dog1Selected) {
      return dog1;
    } else {
      return dog2;
    }
  }
}
