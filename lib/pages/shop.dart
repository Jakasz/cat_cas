import 'dart:async';

import 'package:cas_cat/components/price_text.dart';
import 'package:cas_cat/components/score.dart';
import 'package:cas_cat/components/shop_backgrounds.dart';
import 'package:cas_cat/components/shop_image.dart';

import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Shop extends Component with HasGameRef<MainGameScreen> {
  bool pageCanBeUsed = true;
  late List<Component> imageList;
  late SharedPreferences prefs;
  int imageIndex = 0;
  String inputText = 'BUY';
  String coinAmount = '10';
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
    imageIndex++;
    if (imageIndex == imageList.length) {
      imageIndex = 0;
    }
    resetBuyButton();
  }

  void leftArrowAction() {
    if (!pageCanBeUsed) {
      return;
    }
    imageIndex--;

    if (imageIndex == -1) {
      imageIndex = imageList.length - 1;
    }

    resetBuyButton();
  }

  void resetBuyButton() {
    removeButtonComponents();
    for (final child in [...children]) {
      if (child is ShopImage) {
        remove(child);
      }
    }
    addButtonComponents();
    add(imageList[imageIndex]);
  }

  void buy() {
    if (!pageCanBeUsed) {
      return;
    }

    Set<String>? boughtItems =
        prefs.getStringList('storedBackgrounds')!.toSet();

    if (!boughtItems.contains(imageIndex.toString())) {
      var score = prefs.getInt('score') ?? 0;
      if (score < 10) {
        return;
      }
      prefs.setInt('score', score - 10);
      boughtItems.add(imageIndex.toString());
      prefs.setStringList('storedBackgrounds', boughtItems.toList());
      resetBuyButton();
    } else if (boughtItems.contains(imageIndex.toString())) {
      if (prefs.getInt('selected') == imageIndex) {
        return;
      }
      prefs.setInt('selected', imageIndex);
      resetBuyButton();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    pageCanBeUsed = gameRef.router.currentRoute.name == 'shop';
  }

  void resetTextFields() {
    inputText = 'BUY';
    coinAmount = '10';
  }

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    imageList = ShopBackground().backgrounds;
    prefs = gameRef.prefs;
    add(SpriteComponent()
      ..sprite = Sprite(gameRef.images.fromCache('shop_background.png'))
      ..size = gameRef.size
      ..position = Vector2.zero());
    final LeftArrow backButton = LeftArrow(goBack);
    backButton
      ..sprite = Sprite(gameRef.images.fromCache('left_btn.png'))
      ..position =
          Vector2(gameRef.size.x * 0.014 * 2, gameRef.size.y * 0.020 * 2)
      ..size = Vector2(gameRef.size.x * 0.06 * 2, gameRef.size.x * 0.06 * 2);
    add(backButton);
    add(SpriteComponent()
      ..sprite = Sprite(gameRef.images.fromCache('score_back.png'))
      ..size =
          Vector2(gameRef.size.x * 0.117 * 2.6, gameRef.size.x * 0.054 * 2.5)
      ..position = Vector2(gameRef.size.x - gameRef.size.x * 0.117 * 2.65,
          gameRef.size.x * 0.054));
    add(SpriteComponent()
      ..sprite = Sprite(gameRef.images.fromCache('score_coin.png'))
      ..size = Vector2.all(gameRef.size.x * 0.03 * 3)
      ..position = Vector2(gameRef.size.x - gameRef.size.x * 0.117 * 2.4,
          gameRef.size.x * 0.054 * 1.5));
    add(ScoreText(Vector2(gameRef.size.x - gameRef.size.x * 0.117 * 1.6,
        gameRef.size.x * 0.054 * 1.5)));
    var boardPositionX = gameRef.size.x / 2 - gameRef.size.x * 0.282 * 2.5 / 2;
    add(SpriteComponent()
      ..sprite = Sprite(gameRef.images.fromCache('board.png'))
      ..size = Vector2.all(gameRef.size.x * 0.282 * 2.5)
      ..position = Vector2(boardPositionX, gameRef.size.y * 0.15));
    var rightArrowPositionX = boardPositionX +
        gameRef.size.x * 0.282 * 2.5 -
        gameRef.size.x * 0.047 * 3.5 / 2;
    var rightArrowPositionY = gameRef.size.y * 0.15 +
        (gameRef.size.x * 0.282 * 2.5) / 2 -
        gameRef.size.x * 0.068;
    final RightArrow rightArrow = RightArrow(rightArrowAction);
    rightArrow
      ..sprite = Sprite(gameRef.images.fromCache('ritgh_arrow.png'))
      ..size = Vector2(gameRef.size.x * 0.047 * 3.5, gameRef.size.x * 0.068 * 2)
      ..position = Vector2(rightArrowPositionX, rightArrowPositionY);
    add(rightArrow);

    var leftArrowPositionX = boardPositionX - gameRef.size.x * 0.047 * 3.5 / 2;
    var leftArrowPositionY = gameRef.size.y * 0.15 +
        (gameRef.size.x * 0.282 * 2.5) / 2 -
        gameRef.size.x * 0.068;
    final LeftArrow leftArrow = LeftArrow(leftArrowAction);
    leftArrow
      ..sprite = Sprite(gameRef.images.fromCache('left_arrow.png'))
      ..size = Vector2(gameRef.size.x * 0.047 * 3.5, gameRef.size.x * 0.068 * 2)
      ..position = Vector2(leftArrowPositionX, leftArrowPositionY);
    add(leftArrow);
    add(imageList[0]);
    final BuyButton buyButton = BuyButton(buy);
    buyButton
      ..sprite = Sprite(gameRef.images.fromCache('buy_btn_background.png'))
      ..size = Vector2(gameRef.size.x * .163 * 2, gameRef.size.x * .075 * 2)
      ..position = Vector2(gameRef.size.x / 2 - gameRef.size.x * .163,
          gameRef.size.y * 0.15 + gameRef.size.x * 0.282 * 2.2);
    add(buyButton);

    addButtonComponents();

    add(SpriteComponent()
      ..sprite = Sprite(gameRef.images.fromCache('box_area.png'))
      ..size = Vector2(gameRef.size.x * 0.9, gameRef.size.y * 0.262 * 1.3)
      ..position = Vector2(
          gameRef.size.x / 2 - gameRef.size.x * 0.9 / 2, gameRef.size.y * .55));
    var basketSize =
        Vector2(gameRef.size.x * .129 * 3, gameRef.size.y * .06 * 2);
    add(SpriteComponent()
      ..sprite = Sprite(gameRef.images.fromCache('basket_1.png'))
      ..size = basketSize
      ..position = Vector2(
          gameRef.size.x / 2 - gameRef.size.x * 0.8 / 2, gameRef.size.y * .59));
    add(SpriteComponent()
      ..sprite = Sprite(gameRef.images.fromCache('basket_2.png'))
      ..size = basketSize
      ..position = Vector2(
          gameRef.size.x / 2 -
              gameRef.size.x * 0.8 / 2 +
              gameRef.size.x * .129 * 3.2,
          gameRef.size.y * .59));
    add(SpriteComponent()
      ..sprite = Sprite(gameRef.images.fromCache('basket_3.png'))
      ..size = basketSize
      ..position = Vector2(gameRef.size.x / 2 - gameRef.size.x * 0.8 / 2,
          gameRef.size.y * .62 + basketSize.y));
    add(SpriteComponent()
      ..sprite = Sprite(gameRef.images.fromCache('basket_4.png'))
      ..size = basketSize
      ..position = Vector2(
          gameRef.size.x / 2 -
              gameRef.size.x * 0.8 / 2 +
              gameRef.size.x * .129 * 3.2,
          gameRef.size.y * .62 + basketSize.y));
  }

  void addButtonComponents() {
    Set<String>? boughtItems =
        prefs.getStringList('storedBackgrounds')!.toSet();
    var selectedBackgdound = prefs.getInt('selected') ?? -1;

    if (boughtItems.contains(imageIndex.toString())) {
      coinAmount = '';
      if (selectedBackgdound == imageIndex) {
        inputText = 'USED';
      } else {
        inputText = 'USE';
      }
    } else {
      resetTextFields();
    }
    add(ShopText(
        Vector2(gameRef.size.x / 2.45,
            gameRef.size.y * 0.15 + gameRef.size.x * 0.282 * 2.22),
        inputText));
    add(ShopText(
        Vector2(gameRef.size.x / 2.45,
            gameRef.size.y * 0.15 + gameRef.size.x * 0.282 * 2.4),
        coinAmount));
    if (coinAmount != '') {
      add(BuyCoin());
    }
  }

  void removeButtonComponents() {
    for (final child in [...children]) {
      if (child is ShopText) {
        remove(child);
      } else if (child is BuyCoin) {
        remove(child);
      }
    }
  }
}

class BuyButton extends SpriteComponent with TapCallbacks {
  final Function buy;

  BuyButton(this.buy);
  @override
  void onTapDown(TapDownEvent event) {
    buy();
    super.onTapDown(event);
  }
}

class LeftArrow extends SpriteComponent with TapCallbacks {
  final Function left;

  LeftArrow(this.left);
  @override
  void onTapDown(TapDownEvent event) {
    left();
    super.onTapDown(event);
  }
}

class RightArrow extends SpriteComponent with TapCallbacks {
  final Function right;

  RightArrow(this.right);
  @override
  void onTapDown(TapDownEvent event) {
    right();
    super.onTapDown(event);
  }
}

class BuyCoin extends Component with HasGameRef<MainGameScreen> {
  @override
  FutureOr<void> onLoad() {
    add(SpriteComponent()
      ..sprite = Sprite(gameRef.images.fromCache('coin.png'))
      ..size = Vector2.all(gameRef.size.x * 0.03 * 1.8)
      ..position = Vector2(gameRef.size.x / 2,
          gameRef.size.y * 0.15 + gameRef.size.x * 0.282 * 2.48));
    super.onLoad();
  }
}
