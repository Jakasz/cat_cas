import 'dart:async';
import 'package:cas_cat/components/back_btn.dart';
import 'package:cas_cat/components/basket_1.dart';
import 'package:cas_cat/components/bottom_wall.dart';
import 'package:cas_cat/components/brick_5.dart';
import 'package:cas_cat/components/refresh_btn.dart';
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

class NormalLevel extends Component with HasGameRef<MainGameScreen> {
  bool needToDestroy = false;
  bool levelCanBeUsed = true;
  int coinAmount = 3;
  late final SharedPreferences prefs;
  void returnBack() {
    if (!levelCanBeUsed) {
      return;
    }
    levelCanBeUsed = false;
    coinAmount = 3;
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
      coinAmount = 3;
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
  FutureOr<void> onLoad() async {
    super.onLoad;
    prefs = await SharedPreferences.getInstance();

    void addCoinRight() {
      if (!levelCanBeUsed) {
        return;
      }
      if (coinAmount > 0) {
        coinAmount--;
        final body1 = Coin(Vector2(-19, 200) * 10);
        add(body1);
      }
    }

    void addCoinLeft() {
      if (!levelCanBeUsed) {
        return;
      }
      if (coinAmount > 0) {
        coinAmount--;
        final body2 = Coin(Vector2(10, 100) * 10);
        add(body2);
      }
    }

    void refreshGame() {
      coinAmount = 3;
      prefs.setInt('failScore', 0);
      needToDestroy = true;
    }

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
    add(Basket1());

    add(RefreshButton(refreshGame));
    final BackButton backButton = BackButton(returnBack);
    backButton
      ..sprite = await Sprite.load('left_btn.png')
      ..position = Vector2(2, 4)
      ..size = Vector2(6, 6);
    add(backButton);
    add(Walls(Vector2.zero(), Vector2(0, gameRef.size.y)));
    add(Walls(
        Vector2(gameRef.size.x, 0), Vector2(gameRef.size.x, gameRef.size.y)));
    add(BottomWall());
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
