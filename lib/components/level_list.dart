import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

class LevelList {
  final Function openFunction;
  final Function buyLevel;
  final Game reference;

  LevelList(this.openFunction, this.buyLevel, this.reference);

  Future<List<Component>> get levels => _getLevels(openFunction);
  List<Component> get lockedLevels => _lockedLevels;
  final List<Component> _lockedLevels = [];

  Future<List<Component>> _getLevels(Function openLevel) async {
    final gameRefSize = reference.size;
    final List<double> xlocation = [
      gameRefSize.x / 8,
      gameRefSize.x / 2.2,
      gameRefSize.x / 1.3
    ];
    final List<double> ylocation = [
      gameRefSize.y * 0.13,
      gameRefSize.y * 0.22,
      gameRefSize.y * 0.31,
      gameRefSize.y * 0.40,
      gameRefSize.y * 0.49,
      gameRefSize.y * 0.58,
      gameRefSize.y * 0.67,
      gameRefSize.y * 0.76,
      gameRefSize.y * 0.85,
      gameRefSize.y * 0.92
    ];
    final List<Component> levels = [];
    var xIndex = 0;
    var yIndex = 0;
    for (var i = 1; i < 31; i++) {
      OpenLevelButton openLevel =
          OpenLevelButton(i > 21 ? buyLevel : openFunction);
      openLevel
        ..sprite = Sprite(reference.images.fromCache('level_$i.png'))
        ..size = Vector2(60, 60)
        ..position = Vector2(xlocation[xIndex], ylocation[yIndex]);

      levels.add(openLevel);
      if (i > 21 && i < 31) {
        await _getLockedLelevs(
            buyLevel, Vector2(xlocation[xIndex] + 10, ylocation[yIndex] + 9.8));
      }
      if (xIndex == 2) {
        xIndex = 0;
        yIndex++;
      } else {
        xIndex++;
      }
    }
    return levels;
  }

  _getLockedLelevs(Function buyLevelAction, Vector2 pos) async {
    final BuyLevel buyLevel = BuyLevel(buyLevelAction);
    buyLevel
      ..sprite = Sprite(reference.images.fromCache('lock.png'))
      ..size = Vector2(32, 42)
      ..position = pos;
    lockedLevels.add(buyLevel);
  }
}

class OpenLevelButton extends SpriteComponent with TapCallbacks {
  final Function open;

  OpenLevelButton(this.open);
  @override
  void onTapDown(TapDownEvent event) {
    open();
    super.onTapDown(event);
  }
}

class BuyLevel extends SpriteComponent with TapCallbacks {
  final Function buyLevelAction;

  BuyLevel(this.buyLevelAction);
  @override
  void onTapDown(TapDownEvent event) {
    buyLevelAction();
    super.onTapDown(event);
  }
}
