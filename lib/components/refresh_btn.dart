import 'dart:async';

import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';

class RefreshButton extends Component with HasGameRef<MainGameScreen> {
  final Function refresh;

  RefreshButton(this.refresh);
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    final RefreshLevel button = RefreshLevel(refresh);
    add(button
      ..sprite = await Sprite.load('refresh.png')
      ..size = Vector2(8, 8)
      ..position = Vector2(15, 70));
  }
}

class RefreshLevel extends SpriteComponent with Tappable {
  final Function addCoin;

  RefreshLevel(this.addCoin);
  @override
  bool onTapDown(TapDownInfo info) {
    addCoin();
    return super.onTapDown(info);
  }
}
