import 'dart:async';

import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreText extends TextComponent with HasGameRef<MainGameScreen> {
  final Vector2 positionScore;
  int score = 0;
  late final SharedPreferences prefs;
  final regular = TextPaint(
    style: TextStyle(
        fontSize: 22.0,
        color: BasicPalette.white.color,
        fontFamily: 'Erica One'),
  );

  ScoreText(this.positionScore);
  @override
  FutureOr<void> onLoad() {
    super.onLoad();

    text = score.toString();
    textRenderer = regular;
    position = positionScore;
    size = Vector2(10, 1);
  }

  @override
  void update(double dt) {
    super.update(dt);
    score = gameRef.score;
    text = score.toString();
  }
}
