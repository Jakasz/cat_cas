import 'package:cas_cat/utils/routes.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainGameScreen extends Forge2DGame with HasTappables {
  MainGameScreen() : super(gravity: Vector2(0, 10));
  bool openStart = false;
  bool openSuperGame = false;
  bool openStore = false;
  bool goInMenu = false;
  bool goSuperGame = false;
  bool openSettings = false;
  bool openLevels = false;
  int timerValue = 60;
  final router = CasRoutes().router;
  bool isInMenu = false;
  int score = 0;
  late final SharedPreferences prefs;

  @override
  void onLoad() async {
    super.onLoad();
    prefs = await SharedPreferences.getInstance();
    add(router);
  }

  @override
  void update(double dt) async {
    if (router.isMounted) {
      isInMenu = router.currentRoute.name == 'menu';
      score = prefs.getInt('score') ?? 0;
    }
    if (openLevels && isInMenu) {
      openLevels = false;
      router.pushNamed('levels');
    }

    if (openStart) {
      openStart = false;
      router.pushNamed('game');
    }
    if (openSuperGame && isInMenu) {
      openSuperGame = false;

      router.pushNamed('superGame');
    }
    if (openStore && isInMenu) {
      openStore = false;

      router.pushNamed('shop');
    }
    if (goInMenu) {
      goInMenu = false;
      router.pushNamed('menu');
    }
    if (openSettings) {
      openSettings = false;
      router.pushNamed('settings');
    }
    if (goSuperGame) {
      goSuperGame = false;
      router.pushNamed('superGameStart');
    }

    super.update(dt);
  }
}
