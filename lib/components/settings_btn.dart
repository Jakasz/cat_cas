import 'package:flame/components.dart';
import 'package:flame/input.dart';

class SettingsButton extends SpriteComponent with Tappable {
  final Function openSettings;

  SettingsButton(this.openSettings);
  @override
  bool onTapDown(TapDownInfo info) {
    openSettings();
    return super.onTapDown(info);
  }
}
