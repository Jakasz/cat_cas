import 'dart:async';

import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/components.dart';

class Lives extends Component with HasGameRef<MainGameScreen> {
  final Vector2 pos;

  Lives(this.pos);
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    add(SpriteComponent()
      ..sprite = await Sprite.load('live.png')
      ..size = Vector2(22, 22)
      ..position = pos);
  }
}
