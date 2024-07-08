import 'dart:async';

import 'package:cas_cat/components/simple_text.dart';
import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

class LoaderPage extends Component with HasGameRef<MainGameScreen> {
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    add(SpriteComponent()
      ..sprite = await Sprite.load('loader_back.png')
      ..size = gameRef.size
      ..position = Vector2.zero());
    add(SpriteComponent()
      ..sprite = await Sprite.load('loader.png')
      ..size = Vector2.all(20)
      ..anchor = Anchor.center
      ..position = Vector2(gameRef.size.x / 2, gameRef.size.y - 20)
      ..add(RotateEffect.to(-5, EffectController(duration: 3), onComplete: () {
        gameRef.goInMenu = true;
      })));
    add(
      SimpleText(
          inputText: '50%',
          pos: Vector2(gameRef.size.x / 2 - 5, gameRef.size.y - 20 - 3),
          textSize: Vector2(5, 5),
          fontTextSize: 3.7),
    );
  }
}
