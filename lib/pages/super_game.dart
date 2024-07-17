import 'dart:async';

import 'package:cas_cat/components/brick_5.dart';
import 'package:cas_cat/components/lives.dart';
import 'package:cas_cat/components/refresh_btn.dart';
import 'package:cas_cat/components/simple_text.dart';
import 'package:cas_cat/components/super_g_basket.dart';
import 'package:cas_cat/components/timer_text.dart';
import 'package:cas_cat/components/wall.dart';
import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
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
  int timerTicks = 60;
  late TimerComponent timer;
  late SharedPreferences prefs;
  int score = 0;
  bool needToRebuild = false;

  @override
  void update(double dt) async {
    isCanBeUsed = gameRef.router.currentRoute.name == 'superGameStart';

    var failScore = prefs.getInt('failScore') ?? 0;
    if (failScore > 2) {
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

    final body1 = Coin(Vector2(-30, 200) * 1000);
    add(body1);
  }

  void addCoinLeft() {
    if (!isCanBeUsed) {
      return;
    }

    final body2 = Coin(Vector2(95, 100) * 1000);
    add(body2);
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
      ..position = Vector2(gameRef.size.x / 4.5, gameRef.size.y * 0.01)
      ..size = Vector2(223, 247));
    rightBtn
      ..sprite = await Sprite.load('right_btn.png')
      ..position = Vector2(gameRef.size.x * 0.75, gameRef.size.y * 0.22)
      ..size = Vector2(60, 60);
    add(rightBtn);
    leftBtn
      ..sprite = await Sprite.load('left_btn.png')
      ..position = Vector2(gameRef.size.x * 0.1, gameRef.size.y * 0.22)
      ..size = Vector2(60, 60);
    add(leftBtn);
    add(Brick());
    add(Brick2());
    add(Brick3());
    add(Brick4());
    add(Brick5());

    await createBaskets();

    add(SpriteComponent()
      ..sprite = await Sprite.load('score_back.png')
      ..size = Vector2(117, 54)
      ..position = Vector2(17, 14));

    add(Walls(Vector2.zero(), Vector2(0, gameRef.size.y)));
    add(Walls(
        Vector2(gameRef.size.x, 0), Vector2(gameRef.size.x, gameRef.size.y)));
    addAll(addLives());

    add(addTimer());

    add(TimerText(
        pos: Vector2(gameRef.size.x * 0.07, gameRef.size.y * 0.025),
        textSize: Vector2(10, 1)));
    add(SimpleText(
        fontTextSize: 1.5,
        inputText: 'TIME',
        pos: Vector2(4.3, 2),
        textSize: Vector2(10, 1)));
    add(RefreshButton(refreshGame));
  }

  Future<void> createBaskets() async {
    final SpriteComponent loseBasket = SpriteComponent(
      anchor: Anchor.center,
      sprite: await Sprite.load("basket_1_bad.png"),
      size: Vector2(gameRef.size.x * 0.193 * 2, gameRef.size.y * .073 * 1.5),
    );
    final SpriteComponent winBasket = SpriteComponent(
      anchor: Anchor.center,
      sprite: await Sprite.load("basket_1.png"),
      size: Vector2(gameRef.size.x * 0.193 * 2, gameRef.size.y * .073 * 1.5),
    );

    add(SuperGameBasket(
        pos: Vector2(gameRef.size.x * 0.25, gameRef.size.y * 0.75),
        basketCollision: winBasketCollision,
        basketSprite: winBasket));
    add(SuperGameBasket(
        pos: Vector2(gameRef.size.x * 0.75, gameRef.size.y * 0.75),
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
    timerTicks = 60;
    prefs.setInt('failScore', 0);
    stopTimer();
    removeCoins();
    clearLives();
    addAll(addLives());
    if (refreshTimer) {
      add(addTimer());
    }
  }

  List<Component> addLives() {
    final List<Component> alllives = [];
    for (var i = 0; i < 3; i++) {
      alllives.add(
          Lives(Vector2(gameRef.size.x * 0.9 - i * 23, gameRef.size.y * 0.02)));
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

class RightBtn extends SpriteComponent with TapCallbacks {
  final Function addCoin;

  RightBtn(this.addCoin);

  @override
  void onTapDown(TapDownEvent event) {
    addCoin();
    super.onTapDown(event);
  }
}

class LeftBtn extends SpriteComponent with TapCallbacks {
  final Function addCoin;

  LeftBtn(this.addCoin);
  @override
  void onTapDown(TapDownEvent event) {
    addCoin();
    super.onTapDown(event);
  }
  // @override
  // bool onTapDown(TapDownInfo info) {
  //   addCoin();
  //   return super.onTapDown(info);
  // }
}
