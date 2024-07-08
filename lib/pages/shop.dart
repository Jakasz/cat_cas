import 'dart:async';

import 'package:cas_cat/components/price_text.dart';
import 'package:cas_cat/components/score.dart';
import 'package:cas_cat/components/shop_backgrounds.dart';
import 'package:cas_cat/components/shop_image.dart';

import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Shop extends Component with HasGameRef<MainGameScreen> {
  bool pageCanBeUsed = true;
  late List<Component> imageList;
  late SharedPreferences prefs;
  int imageIndex = 1;
  void goBack() {
    if (!pageCanBeUsed) {
      return;
    }
    pageCanBeUsed = false;
    gameRef.goInMenu = true;
  }

  void rightArrowAction() {
    if (!pageCanBeUsed) {
      return;
    }
    if (imageIndex < imageList.length - 1) {
      imageIndex++;
      for (final child in [...children]) {
        if (child is ShopImage) {
          remove(child);
        }
      }
      add(imageList[imageIndex]);
    }
  }

  void leftArrowAction() {
    if (!pageCanBeUsed) {
      return;
    }
    if (imageIndex > 0) {
      imageIndex--;
      for (final child in [...children]) {
        if (child is ShopImage) {
          remove(child);
        }
      }
      add(imageList[imageIndex]);
    }
  }

  void buy() {
    if (!pageCanBeUsed) {
      return;
    }
    var score = prefs.getInt('score') ?? 0;
    if (score < 10) {
      return;
    }
    prefs.setInt('score', score - 10);
  }

  @override
  void update(double dt) {
    pageCanBeUsed = gameRef.router.currentRoute.name == 'shop';
    super.update(dt);
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    imageList = ShopBackground().backgrounds;
    prefs = await SharedPreferences.getInstance();
    add(SpriteComponent()
      ..sprite = await Sprite.load('shop_background.png')
      ..size = gameRef.size
      ..position = Vector2.zero());
    final LeftArrow backButton = LeftArrow(goBack);
    backButton
      ..sprite = await Sprite.load('left_btn.png')
      ..position = Vector2(2, 4)
      ..size = Vector2(6, 6);
    add(backButton);

    add(SpriteComponent()
      ..sprite = await Sprite.load('score_back.png')
      ..size = Vector2(11, 5)
      ..position = Vector2(25, 3));
    add(SpriteComponent()
      ..sprite = await Sprite.load('score_coin.png')
      ..size = Vector2.all(3)
      ..position = Vector2(25.2, 4.5));
    add(ScoreText(Vector2(28.2, 3.6)));
    add(SpriteComponent()
      ..sprite = await Sprite.load('board.png')
      ..size = Vector2.all(26)
      ..position = Vector2(7, 13));
    final RightArrow rightArrow = RightArrow(rightArrowAction);
    rightArrow
      ..sprite = await Sprite.load('ritgh_arrow.png')
      ..size = Vector2(6, 5)
      ..position = Vector2(30, 23);
    add(rightArrow);
    final LeftArrow leftArrow = LeftArrow(leftArrowAction);
    leftArrow
      ..sprite = await Sprite.load('left_arrow.png')
      ..size = Vector2(6, 5)
      ..position = Vector2(4, 23);
    add(leftArrow);
    add(imageList[0]);
    final BuyButton buyButton = BuyButton(buy);
    buyButton
      ..sprite = await Sprite.load('buy_btn_background.png')
      ..size = Vector2(13, 7)
      ..position = Vector2(14, 34);
    add(buyButton);
    add(ShopText(Vector2(17.5, 34.5), 'BUY'));
    add(ShopText(Vector2(17, 36.5), '10'));
    add(SpriteComponent()
      ..sprite = await Sprite.load('coin.png')
      ..size = Vector2.all(2.5)
      ..position = Vector2(20.5, 37.5));
    add(SpriteComponent()
      ..sprite = await Sprite.load('box_area.png')
      ..size = Vector2(35, 26)
      ..position = Vector2(2, 45));

    add(SpriteComponent()
      ..sprite = await Sprite.load('basket_1.png')
      ..size = Vector2(14.5, 10)
      ..position = Vector2(3, 47));
    add(SpriteComponent()
      ..sprite = await Sprite.load('basket_2.png')
      ..size = Vector2(14.5, 10)
      ..position = Vector2(20.5, 47));
    add(SpriteComponent()
      ..sprite = await Sprite.load('basket_3.png')
      ..size = Vector2(14.5, 10)
      ..position = Vector2(3, 59));
    add(SpriteComponent()
      ..sprite = await Sprite.load('basket_4.png')
      ..size = Vector2(14.5, 10)
      ..position = Vector2(20.5, 59));
  }
}

class BuyButton extends SpriteComponent with Tappable {
  final Function buy;

  BuyButton(this.buy);
  @override
  bool onTapDown(TapDownInfo info) {
    buy();
    return super.onTapDown(info);
  }
}

class LeftArrow extends SpriteComponent with Tappable {
  final Function left;

  LeftArrow(this.left);
  @override
  bool onTapDown(TapDownInfo info) {
    left();
    return super.onTapDown(info);
  }
}

class RightArrow extends SpriteComponent with Tappable {
  final Function right;

  RightArrow(this.right);
  @override
  bool onTapDown(TapDownInfo info) {
    right();
    return super.onTapDown(info);
  }
}
