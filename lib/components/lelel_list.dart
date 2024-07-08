import 'package:flame/components.dart';
import 'package:flame/input.dart';

class LevelList {
  final Function openFunction;
  final Function buyLevel;

  LevelList(this.openFunction, this.buyLevel);

  Future<List<Component>> get levels => _getLevels(openFunction);
  List<Component> get lockedLevels => _lockedLevels;
  final List<Component> _lockedLevels = [];
  final List<double> _xlocation = [3, 17, 31];
  final List<double> _ylocation = [11, 18, 25, 32, 39, 46, 53, 60, 67, 74];
  Future<List<Component>> _getLevels(Function openLevel) async {
    final List<Component> levels = [];
    var xIndex = 0;
    var yIndex = 0;
    for (var i = 1; i < 31; i++) {
      OpenLevelButton openLevel =
          OpenLevelButton(i > 21 ? buyLevel : openFunction);
      openLevel
        ..sprite = await Sprite.load('level_$i.png')
        ..size = Vector2(6, 6)
        ..position = Vector2(_xlocation[xIndex], _ylocation[yIndex]);

      levels.add(openLevel);
      if (i > 21 && i < 31) {
        await _getLockedLelevs(buyLevel,
            Vector2(_xlocation[xIndex] + 1, _ylocation[yIndex] + 0.8));
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
      ..sprite = await Sprite.load('lock.png')
      ..size = Vector2(3.2, 4.2)
      ..position = pos;
    lockedLevels.add(buyLevel);
  }
}

class OpenLevelButton extends SpriteComponent with Tappable {
  final Function open;

  OpenLevelButton(this.open);
  @override
  bool onTapDown(TapDownInfo info) {
    open();
    return super.onTapDown(info);
  }
}

class BuyLevel extends SpriteComponent with Tappable {
  final Function buyLevelAction;

  BuyLevel(this.buyLevelAction);
  @override
  bool onTapDown(TapDownInfo info) {
    buyLevelAction();
    return super.onTapDown(info);
  }
}
