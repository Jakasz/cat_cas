import 'dart:async';

import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class TimerText extends TextComponent with HasGameRef<MainGameScreen> {
  String timerValue = '60';
  final Vector2 pos;
  final Vector2 textSize;

  TimerText({required this.pos, required this.textSize});
  final regular = TextPaint(
    style: TextStyle(
        fontSize: 1.5,
        color: BasicPalette.white.color,
        fontFamily: 'Erica One'),
  );
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    text = text;
    textRenderer = regular;
    position = pos;
    size = textSize;
  }

  @override
  void update(double dt) {
    super.update(dt);
    timerValue = gameRef.timerValue.toString();
    text = '00:${timerValue.toString()}';
  }
}
