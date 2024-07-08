import 'dart:async';

import 'package:cas_cat/components/score.dart';
import 'package:cas_cat/components/settings_btn.dart';
import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CasCatMenu extends Component with HasGameRef<MainGameScreen> {
  late final SharedPreferences prefs;
  //how mush coins user won
  int score = 0;
  //how many coins user lost
  int lostCoins = 0;
  //user's lives remain
  int lives = 3;
  int totalScore = 0;

  void openLevels() {
    if (gameRef.router.currentRoute.name == 'menu') gameRef.openLevels = true;
  }

  void openSuperGame() {
    if (gameRef.router.currentRoute.name == 'menu') {
      gameRef.openSuperGame = true;
    }
  }

  void openStore() {
    if (gameRef.router.currentRoute.name == 'menu') gameRef.openStore = true;
  }

  void openSettings() {
    if (gameRef.router.currentRoute.name == 'menu') gameRef.openSettings = true;
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    prefs = await SharedPreferences.getInstance();
    totalScore = prefs.getInt('score') ?? 0;

    final startBtn = StartBtn(openLevels);
    add(SpriteComponent()
      ..sprite = await Sprite.load('background_1.png')
      ..size = gameRef.size
      ..position = Vector2.zero());
    final SuperGameBtn superGameBtn = SuperGameBtn(openSuperGame);
    startBtn
      ..sprite = await Sprite.load('start.png')
      ..position = Vector2(8, 17.9)
      ..size = Vector2(22, 8);
    add(startBtn);
    superGameBtn
      ..sprite = await Sprite.load('super_game.png')
      ..position = Vector2(8, 35)
      ..size = Vector2(22, 8);
    add(superGameBtn);

    final StoreBtn storeBtn = StoreBtn(openStore);
    storeBtn
      ..sprite = await Sprite.load('store.png')
      ..position = Vector2(8, 53)
      ..size = Vector2(22, 8);
    add(storeBtn);
    add(SpriteComponent()
      ..sprite = await Sprite.load('score_back.png')
      ..size = Vector2(11, 5)
      ..position = Vector2(3, 3));
    add(SpriteComponent()
      ..sprite = await Sprite.load('score_coin.png')
      ..size = Vector2.all(3)
      ..position = Vector2(4, 4.5));
    add(ScoreText(Vector2(7, 3.6)));
    final SettingsButton settingsButton = SettingsButton(openSettings);
    settingsButton
      ..sprite = await Sprite.load('settings.png')
      ..position = Vector2(gameRef.size.x - 8, 3)
      ..size = Vector2(6, 6);
    add(settingsButton);
  }
}

class StartBtn extends SpriteComponent with Tappable {
  final Function addCoin;

  StartBtn(this.addCoin);
  @override
  bool onTapDown(TapDownInfo info) {
    addCoin();
    return super.onTapDown(info);
  }
}

class SuperGameBtn extends SpriteComponent with Tappable {
  final Function addCoin;

  SuperGameBtn(this.addCoin);
  @override
  bool onTapDown(TapDownInfo info) {
    addCoin();
    return super.onTapDown(info);
  }
}

class StoreBtn extends SpriteComponent with Tappable {
  final Function addCoin;

  StoreBtn(this.addCoin);
  @override
  bool onTapDown(TapDownInfo info) {
    addCoin();
    return super.onTapDown(info);
  }
}
