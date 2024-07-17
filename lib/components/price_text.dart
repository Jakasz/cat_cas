import 'dart:async';

import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class ShopText extends TextComponent with HasGameRef<MainGameScreen> {
  final Vector2 positionScore;
  final String inputText;
  final regular = TextPaint(
    style: TextStyle(
        fontSize: 23, color: BasicPalette.white.color, fontFamily: 'Erica One'),
  );
  ShopText(this.positionScore, this.inputText);
  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    text = inputText;
    textRenderer = regular;
    position = positionScore;
  }
}
