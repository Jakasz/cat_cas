import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class TextRenderPaint {
  TextPaint get render => _regular;

  final TextPaint _regular = TextPaint(
    style: TextStyle(
        fontSize: 25, color: BasicPalette.white.color, fontFamily: 'Erica One'),
  );
}
