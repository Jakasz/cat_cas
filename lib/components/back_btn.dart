import 'package:flame/components.dart';
import 'package:flame/input.dart';

class BackButton extends SpriteComponent with Tappable {
  final Function back;

  BackButton(this.back);
  @override
  bool onTapDown(TapDownInfo info) {
    back();
    return super.onTapDown(info);
  }
}
