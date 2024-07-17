import 'dart:async';

import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class RefreshButton extends Component with HasGameRef<MainGameScreen> {
  final Function refresh;

  RefreshButton(this.refresh);
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    final RefreshLevel button = RefreshLevel(refresh);
    add(button
      ..sprite = await Sprite.load('refresh.png')
      ..size = Vector2(gameRef.size.x * 0.170, gameRef.size.x * 0.170)
      ..position = Vector2(gameRef.size.x * 0.45, gameRef.size.y * 0.9));
  }
}

class RefreshLevel extends SpriteComponent with TapCallbacks {
  final Function addCoin;

  RefreshLevel(this.addCoin);
  @override
  void onTapDown(TapDownEvent event) {
    addCoin();
    super.onTapDown(event);
  }
}
