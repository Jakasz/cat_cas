import 'dart:async';

import 'package:cas_cat/components/level_list.dart';
import 'package:cas_cat/pages/main_game.dart';
import 'package:cas_cat/utils/text_render.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class Levels extends Component with HasGameRef<MainGameScreen> {
  bool canUseLevels = true;
  void returnBack() {
    gameRef.goInMenu = true;
    canUseLevels = false;
  }

  void buyLevel() {
    if (!canUseLevels) return;
  }

  void openLevel() {
    if (!canUseLevels) return;
    gameRef.openStart = true;
    canUseLevels = false;
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    //background
    add(SpriteComponent()
      ..sprite = Sprite(gameRef.images.fromCache('level_background.png'))
      ..position = Vector2.zero()
      ..size = gameRef.size);
    final ActionButton backButton = ActionButton(returnBack);
    backButton
      ..sprite = Sprite(gameRef.images.fromCache('left_btn.png'))
      ..position = Vector2(14, 18)
      ..size = Vector2(52, 52);
    add(backButton);
    final levelList = LevelList(openLevel, buyLevel, gameRef);
    final levels = await levelList.levels;

    for (var element in levels) {
      add(element);
    }
    final lockedLevels = levelList.lockedLevels;
    for (var element in lockedLevels) {
      add(element);
    }
    add(SpriteComponent()
      ..sprite = Sprite(gameRef.images.fromCache('score_back.png'))
      ..size = Vector2(165, 76)
      ..position = Vector2(113, 24));

    add(TextComponent(
        text: 'LEVELS',
        textRenderer: TextRenderPaint().render,
        position: Vector2(150, 47)));
  }

  @override
  void update(double dt) {
    super.update(dt);
    canUseLevels = gameRef.router.currentRoute.name == 'levels';
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
