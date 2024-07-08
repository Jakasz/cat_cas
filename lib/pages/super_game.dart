import 'dart:async';

import 'package:cas_cat/components/brick_5.dart';
import 'package:cas_cat/components/lives.dart';
import 'package:cas_cat/components/simple_text.dart';
import 'package:cas_cat/components/super_g_basket.dart';
import 'package:cas_cat/components/timer_text.dart';
import 'package:cas_cat/components/wall.dart';
import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/brick_1.dart';
import '../components/brick_2.dart';
import '../components/brick_3.dart';
import '../components/brick_4.dart';
import '../components/coin.dart';

class SuperGame extends Component with HasGameRef<MainGameScreen> {
  bool isCanBeUsed = true;
  bool needToDestroy = false;
  int livesCount = 3;
  int coinAmount = 3;
  int timerTicks = 10;
  late TimerComponent timer;
  late SharedPreferences prefs;
  int score = 0;
  bool needToRebuild = false;

  @override
  void update(double dt) async {
    isCanBeUsed = gameRef.router.currentRoute.name == 'superGameStart';

    var failScore = prefs.getInt('failScore') ?? 0;
    if (failScore > 2) {
      coinAmount = 3;
      prefs.setInt('failScore', 0);
      needToDestroy = true;
    }
    if (!isCanBeUsed && !needToDestroy) {
      return;
    }
    if (timerTicks == -1) {
      needToDestroy = true;
      refreshGame(refreshTimer: false);
      await stopTimer();
    }
    if (needToDestroy) {
      needToDestroy = false;
      destroyBaskests();
      if (!gameRef.goInMenu) {
        gameRef.goInMenu = true;
      }
    }
    if (livesCount == 0) {
      needToDestroy = true;
      refreshGame(refreshTimer: false);
      stopTimer();
    }
    if (needToRebuild && !gameRef.goInMenu) {
      needToRebuild = false;
      createBaskets();
    }
    super.update(dt);
  }

  Future<void> stopTimer() async {
    for (final child in [...children]) {
      if (child is TimerComponent) {
        remove(child);
      }
    }
  }

  void addCoinRight() {
    if (!isCanBeUsed) {
      return;
    }
    if (coinAmount > 0) {
      coinAmount--;
      final body1 = Coin(Vector2(-30, 200) * 10);
      add(body1);
    }
  }

  void addCoinLeft() {
    if (!isCanBeUsed) {
      return;
    }
    if (coinAmount > 0) {
      coinAmount--;
      final body2 = Coin(Vector2(95, 100) * 10);
      add(body2);
    }
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad;
    prefs = await SharedPreferences.getInstance();
    score = prefs.getInt('score') ?? 0;

    RightBtn rightBtn = RightBtn(addCoinRight);
    LeftBtn leftBtn = LeftBtn(addCoinLeft);
    SpriteComponent background = SpriteComponent()
      ..sprite = await Sprite.load('background_2.png')
      ..position = Vector2.zero()
      ..size = gameRef.size;
    add(background);
    add(SpriteComponent()
      ..sprite = await Sprite.load('cat_with_coin.png')
      ..position = Vector2(9, 2)
      ..size = Vector2(20, 20));
    rightBtn
      ..sprite = await Sprite.load('right_btn.png')
      ..position = Vector2(30, 20)
      ..size = Vector2(6, 6);
    add(rightBtn);
    leftBtn
      ..sprite = await Sprite.load('left_btn.png')
      ..position = Vector2(5, 20)
      ..size = Vector2(6, 6);
    add(leftBtn);
    add(Brick());
    add(Brick2());
    add(Brick3());
    add(Brick4());
    add(Brick5());

    await createBaskets();

    add(SpriteComponent()
      ..sprite = await Sprite.load('score_back.png')
      ..size = Vector2(9.1, 4.2)
      ..position = Vector2(2, 2));

    add(Walls(Vector2.zero(), Vector2(0, gameRef.size.y)));
    add(Walls(
        Vector2(gameRef.size.x, 0), Vector2(gameRef.size.x, gameRef.size.y)));
    addAll(addLives());

    add(addTimer());

    add(TimerText(pos: Vector2(4, 3.3), textSize: Vector2(10, 1)));
    add(SimpleText(
        fontTextSize: 1.5,
        inputText: 'TIME',
        pos: Vector2(4.3, 2),
        textSize: Vector2(10, 1)));
    final RefreshBtn refreshBtn = RefreshBtn(refreshGame);
    refreshBtn
      ..sprite = await Sprite.load('refresh.png')
      ..size = Vector2(8, 8)
      ..position = Vector2(15, 70);
    add(refreshBtn);
  }

  Future<void> createBaskets() async {
    final SpriteComponent loseBasket = SpriteComponent(
      anchor: Anchor.center,
      sprite: await Sprite.load("basket_1_bad.png"),
      size: Vector2(14.4, 7.3),
    );
    final SpriteComponent winBasket = SpriteComponent(
      anchor: Anchor.center,
      sprite: await Sprite.load("basket_1.png"),
      size: Vector2(14.4, 7.3),
    );

    add(SuperGameBasket(
        pos: Vector2(gameRef.size.x / 6 + 4, gameRef.size.y / 1.4),
        basketCollision: winBasketCollision,
        basketSprite: winBasket));
    add(SuperGameBasket(
        pos: Vector2(gameRef.size.x / 1.4, gameRef.size.y / 1.4),
        basketCollision: looseBasketCollision,
        basketSprite: loseBasket));
  }

  void winBasketCollision() {
    score++;
    prefs.setInt('score', score);
  }

  void looseBasketCollision() {
    livesCount--;
    int failScore = prefs.getInt('failScore') ?? 0;
    prefs.setInt('failScore', failScore + 1);
    for (final child in [...children]) {
      if (child is Lives) {
        //destroy only one life per coin in bad box
        remove(child);
        return;
      }
    }
  }

  //clear all lives
  void clearLives() {
    for (final child in [...children]) {
      if (child is Lives) {
        remove(child);
      }
    }
  }

  void destroyBaskests() {
    needToRebuild = true;
    for (final child in [...children]) {
      if (child is SuperGameBasket) {
        for (final fixture in [...child.body.fixtures]) {
          child.body.destroyFixture(fixture);
        }
        gameRef.world.destroyBody(child.body);
        remove(child);
      }
    }
  }

  void removeCoins() {
    for (final child in [...children]) {
      if (child is Coin) {
        for (final fixture in [...child.body.fixtures]) {
          child.body.destroyFixture(fixture);
        }
        gameRef.world.destroyBody(child.body);
        remove(child);
      }
    }
  }

  void refreshGame({bool refreshTimer = true}) async {
    if (!isCanBeUsed) {
      return;
    }
    destroyBaskests();
    livesCount = 3;
    timerTicks = 10;
    prefs.setInt('failScore', 0);
    stopTimer();
    removeCoins();
    clearLives();
    addAll(addLives());
    if (refreshTimer) {
      coinAmount = 3;
      add(addTimer());
    }
  }

  List<Component> addLives() {
    final List<Component> alllives = [];
    for (var i = 0; i < 3; i++) {
      alllives.add(Lives(Vector2(
          gameRef.size.x - 5 - i * 2.3, gameRef.size.y / gameRef.size.y + 1)));
    }
    return alllives;
  }

  addTimer() {
    return timer = TimerComponent(
      period: 1,
      repeat: true,
      onTick: () {
        gameRef.timerValue = timerTicks--;
      },
    );
  }
}

class RightBtn extends SpriteComponent with Tappable {
  final Function addCoin;

  RightBtn(this.addCoin);

  @override
  bool onTapDown(TapDownInfo info) {
    addCoin();
    return super.onTapDown(info);
  }
}

class LeftBtn extends SpriteComponent with Tappable {
  final Function addCoin;

  LeftBtn(this.addCoin);
  @override
  bool onTapDown(TapDownInfo info) {
    addCoin();
    return super.onTapDown(info);
  }
}

class RefreshBtn extends SpriteComponent with Tappable {
  final Function refreshGame;

  RefreshBtn(this.refreshGame);
  @override
  bool onTapDown(TapDownInfo info) {
    refreshGame();
    return super.onTapDown(info);
  }
}
