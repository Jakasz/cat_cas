import 'dart:async';

import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class SimpleText extends TextComponent with HasGameRef<MainGameScreen> {
  final String inputText;
  final Vector2 pos;
  final Vector2 textSize;
  final double fontTextSize;

  SimpleText(
      {required this.inputText,
      required this.pos,
      required this.textSize,
      required this.fontTextSize});
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    final regular = TextPaint(
      style: TextStyle(
          fontSize: fontTextSize,
          color: BasicPalette.white.color,
          fontFamily: 'Erica One'),
    );
    text = inputText;
    textRenderer = regular;
    position = pos;
    size = textSize;
  }
}
