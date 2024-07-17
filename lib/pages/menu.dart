import 'dart:async';

import 'package:cas_cat/components/score.dart';
import 'package:cas_cat/components/settings_btn.dart';
import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
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
      ..sprite = Sprite(gameRef.images.fromCache('background_7.png'))
      ..size = gameRef.size
      ..position = Vector2.zero());
    final SuperGameBtn superGameBtn = SuperGameBtn(openSuperGame);
    startBtn
      ..sprite = Sprite(gameRef.images.fromCache('start.png'))
      ..position = Vector2(81, 179)
      ..size = Vector2(230, 80);
    add(startBtn);
    superGameBtn
      ..sprite = Sprite(gameRef.images.fromCache('super_game.png'))
      ..position = Vector2(80, 357)
      ..size = Vector2(230, 80);
    add(superGameBtn);

    final StoreBtn storeBtn = StoreBtn(openStore);
    storeBtn
      ..sprite = Sprite(gameRef.images.fromCache('store.png'))
      ..position = Vector2(80, 535)
      ..size = Vector2(230, 80);
    add(storeBtn);
    add(SpriteComponent()
      ..sprite = Sprite(gameRef.images.fromCache('score_back.png'))
      ..size = Vector2(117, 54)
      ..position = Vector2(17, 14));
    add(SpriteComponent()
      ..sprite = Sprite(gameRef.images.fromCache('score_coin.png'))
      ..size = Vector2.all(26)
      ..position = Vector2(26, 30));
    add(ScoreText(Vector2(67, 24)));
    final SettingsButton settingsButton = SettingsButton(openSettings);
    settingsButton
      ..sprite = Sprite(gameRef.images.fromCache('settings.png'))
      ..position = Vector2(gameRef.size.x - 74, 17)
      ..size = Vector2(56, 56);
    add(settingsButton);
  }
}

class StartBtn extends SpriteComponent with TapCallbacks {
  final Function addCoin;

  StartBtn(this.addCoin);
  @override
  void onTapDown(TapDownEvent event) {
    addCoin();
    return super.onTapDown(event);
  }
}

class SuperGameBtn extends SpriteComponent with TapCallbacks {
  final Function addCoin;

  SuperGameBtn(this.addCoin);
  @override
  void onTapDown(TapDownEvent event) {
    addCoin();
    return super.onTapDown(event);
  }
}

class StoreBtn extends SpriteComponent with TapCallbacks {
  final Function addCoin;

  StoreBtn(this.addCoin);
  @override
  void onTapDown(TapDownEvent event) {
    addCoin();
    return super.onTapDown(event);
  }
}
