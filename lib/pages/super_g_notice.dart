import 'dart:async';

import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';

class SuperGameNotice extends Component with HasGameRef<MainGameScreen> {
  bool canUsePage = true;
  void returnBack() {
    if (!canUsePage) {
      return;
    }
    gameRef.goInMenu = true;
    canUsePage = false;
  }

  void goGame() {
    if (canUsePage) {
      gameRef.goSuperGame = true;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    canUsePage = gameRef.router.currentRoute.name == 'superGame';
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    add(SpriteComponent()
      ..sprite = await Sprite.load('super_g_notice.png')
      ..size = gameRef.size
      ..position = Vector2.zero());
    final ActionButton backButton = ActionButton(returnBack);
    backButton
      ..sprite = await Sprite.load('left_btn.png')
      ..position = Vector2(2, 4)
      ..size = Vector2(6, 6);
    add(backButton);

    final ActionButton goSuperGame = ActionButton(goGame);
    goSuperGame
      ..sprite = await Sprite.load('start.png')
      ..size = Vector2(24, 10)
      ..position = Vector2(8, 46);
    add(goSuperGame);
  }
}

class ActionButton extends SpriteComponent with Tappable {
  final Function action;

  ActionButton(this.action);
  @override
  bool onTapDown(TapDownInfo info) {
    action();
    return super.onTapDown(info);
  }
}
