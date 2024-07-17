import 'dart:async';

import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/components.dart';

class ShopImage extends Component with HasGameRef<MainGameScreen> {
  final int img;

  ShopImage(this.img);
  @override
  FutureOr<void> onLoad() {
    add(SpriteComponent()
      ..sprite = Sprite(gameRef.images.fromCache('shop_back_$img.png'))
      ..size = Vector2.all(gameRef.size.x * 0.183 * 3)
      ..position = Vector2(
          gameRef.size.x / 2 - gameRef.size.x * 0.183 * 1.5,
          (gameRef.size.y * 0.15 + gameRef.size.x * 0.282 * 3.5) / 2 -
              gameRef.size.x * 0.183 * 1.5));
    super.onLoad();
  }
}
