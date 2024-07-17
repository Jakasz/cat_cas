import 'dart:async';

import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
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
  FutureOr<void> onLoad() {
    super.onLoad();
    add(SpriteComponent()
      ..sprite = Sprite(gameRef.images.fromCache('super_g_notice.png'))
      ..size = gameRef.size
      ..position = Vector2.zero());
    final ActionButton backButton = ActionButton(returnBack);
    backButton
      ..sprite = Sprite(gameRef.images.fromCache('left_btn.png'))
      ..position = Vector2(12, 20)
      ..size = Vector2(66, 63);
    add(backButton);

    final ActionButton goSuperGame = ActionButton(goGame);
    goSuperGame
      ..sprite = Sprite(gameRef.images.fromCache('start.png'))
      ..size = Vector2(229, 81)
      ..position = Vector2(gameRef.size.x / 2 - 110, gameRef.size.y / 2 + 40);
    add(goSuperGame);
  }
}

class ActionButton extends SpriteComponent with TapCallbacks {
  final Function action;

  ActionButton(this.action);
  @override
  void onTapDown(TapDownEvent event) {
    action();
    super.onTapDown(event);
  }
}
