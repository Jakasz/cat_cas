import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';

class BackButton extends SpriteComponent with TapCallbacks {
  final Function back;

  BackButton(this.back);
  @override
  void onTapDown(TapDownEvent event) {
    back();
    super.onTapDown(event);
  }
}
