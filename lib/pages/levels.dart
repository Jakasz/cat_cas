import 'dart:async';

import 'package:cas_cat/components/lelel_list.dart';
import 'package:cas_cat/pages/main_game.dart';
import 'package:cas_cat/utils/text_render.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

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
    await super.onLoad();
    //background
    add(SpriteComponent()
      ..sprite = await Sprite.load('level_background.png')
      ..position = Vector2.zero()
      ..size = gameRef.size);
    final ActionButton backButton = ActionButton(returnBack);
    backButton
      ..sprite = await Sprite.load('left_btn.png')
      ..position = Vector2(2, 2)
      ..size = Vector2(6, 6);
    add(backButton);
    final levelList = LevelList(openLevel, buyLevel);
    final levels = await levelList.levels;

    for (var element in levels) {
      add(element);
    }
    final lockedLevels = levelList.lockedLevels;
    for (var element in lockedLevels) {
      add(element);
    }
    add(SpriteComponent()
      ..sprite = await Sprite.load('score_back.png')
      ..size = Vector2(15, 7)
      ..position = Vector2(13, 3));

    add(TextComponent(
        text: 'LEVELS',
        textRenderer: TextRenderPaint().render,
        position: Vector2(15.5, 4.7)));
  }

  @override
  void update(double dt) {
    super.update(dt);
    canUseLevels = gameRef.router.currentRoute.name == 'levels';
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
