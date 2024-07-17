import 'dart:async';
import 'package:cas_cat/components/back_btn.dart';
import 'package:cas_cat/components/basket_1.dart';
import 'package:cas_cat/components/bottom_wall.dart';
import 'package:cas_cat/components/brick_5.dart';
import 'package:cas_cat/components/refresh_btn.dart';
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

class NormalLevel extends Component with HasGameRef<MainGameScreen> {
  bool needToDestroy = false;
  bool levelCanBeUsed = true;
  late final SharedPreferences prefs;
  void returnBack() {
    if (!levelCanBeUsed) {
      return;
    }
    levelCanBeUsed = false;
    prefs.setInt('failScore', 0);
    needToDestroy = true;
    if (!gameRef.goInMenu) {
      gameRef.goInMenu = true;
    }
  }

  @override
  void update(double dt) {
    levelCanBeUsed = gameRef.router.currentRoute.name == 'game';

    if (!levelCanBeUsed && !needToDestroy) {
      return;
    }
    var failScore = prefs.getInt('failScore') ?? 0;
    if (failScore > 2) {
      prefs.setInt('failScore', 0);
      needToDestroy = true;
      if (!gameRef.goInMenu) {
        gameRef.goInMenu = true;
      }
    }
    if (needToDestroy) {
      needToDestroy = false;
      for (final child in [...children]) {
        if (child is Coin) {
          for (final fixture in [...child.body.fixtures]) {
            child.body.destroyFixture(fixture);
          }
          gameRef.world.destroyBody(child.body);
          remove(child);
        }
      }
      // if (!gameRef.goInMenu) {
      //   gameRef.goInMenu = true;
      // }
    }
    super.update(dt);
  }

  @override
  FutureOr<void> onLoad() {
    super.onLoad;
    prefs = gameRef.prefs;

    void addCoinRight() {
      if (!levelCanBeUsed) {
        return;
      }

      final body1 = Coin(Vector2(-19, 200) * 100);
      add(body1);
    }

    void addCoinLeft() {
      if (!levelCanBeUsed) {
        return;
      }

      final body2 = Coin(Vector2(10, 100) * 100);
      add(body2);
    }

    void refreshGame() {
      prefs.setInt('failScore', 0);
      needToDestroy = true;
    }

    RightBtn rightBtn = RightBtn(addCoinRight);
    LeftBtn leftBtn = LeftBtn(addCoinLeft);
    var backgroundId = prefs.getInt('selected') ?? 6;
    SpriteComponent background = SpriteComponent()
      ..sprite =
          Sprite(gameRef.images.fromCache('background_$backgroundId.png'))
      ..position = Vector2.zero()
      ..size = gameRef.size;
    add(background);
    add(SpriteComponent()
      ..sprite = Sprite(gameRef.images.fromCache('cat_with_coin.png'))
      ..position = Vector2(gameRef.size.x / 4.5, gameRef.size.y * 0.01)
      ..size = Vector2(223, 247));
    rightBtn
      ..sprite = Sprite(gameRef.images.fromCache('right_btn.png'))
      ..position = Vector2(gameRef.size.x * 0.75, gameRef.size.y * 0.22)
      ..size = Vector2(60, 60);
    add(rightBtn);
    leftBtn
      ..sprite = Sprite(gameRef.images.fromCache('left_btn.png'))
      ..position = Vector2(gameRef.size.x * 0.1, gameRef.size.y * 0.22)
      ..size = Vector2(60, 60);
    add(leftBtn);
    add(Brick());
    add(Brick2());
    add(Brick3());
    add(Brick4());
    add(Brick5());
    add(Basket1());

    add(RefreshButton(refreshGame));
    final BackButton backButton = BackButton(returnBack);
    backButton
      ..sprite = Sprite(gameRef.images.fromCache('left_btn.png'))
      ..position =
          Vector2(gameRef.size.x * 0.014 * 2, gameRef.size.y * 0.020 * 2)
      ..size = Vector2.all(gameRef.size.x * 0.060 * 2);
    add(backButton);
    add(Walls(Vector2.zero(), Vector2(0, gameRef.size.y)));
    add(Walls(
        Vector2(gameRef.size.x, 0), Vector2(gameRef.size.x, gameRef.size.y)));
    add(BottomWall());
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
}
