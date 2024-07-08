import 'dart:async';

import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/components.dart';

class ShopImage extends Component with HasGameRef<MainGameScreen> {
  final int img;

  ShopImage(this.img);
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    add(SpriteComponent()
      ..sprite = await Sprite.load('shop_back_$img.png')
      ..size = Vector2(18, 18)
      ..position = Vector2(11, 17));
  }
}
