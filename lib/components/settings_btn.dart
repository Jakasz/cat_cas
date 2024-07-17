import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';

class SettingsButton extends SpriteComponent with TapCallbacks {
  final Function openSettings;

  SettingsButton(this.openSettings);
  @override
  void onTapDown(TapDownEvent event) {
    openSettings();
    super.onTapDown(event);
  }
}
