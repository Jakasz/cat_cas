import 'package:cas_cat/pages/levels.dart';
import 'package:cas_cat/pages/loader.dart';
import 'package:cas_cat/pages/menu.dart';
import 'package:cas_cat/pages/normal_level.dart';
import 'package:cas_cat/pages/settings.dart';
import 'package:cas_cat/pages/shop.dart';
import 'package:cas_cat/pages/super_g_notice.dart';
import 'package:cas_cat/pages/super_game.dart';
import 'package:flame/game.dart';

class CasRoutes {
  final router = RouterComponent(initialRoute: 'loader', routes: {
    'menu': Route(CasCatMenu.new),
    'superGame': Route(SuperGameNotice.new),
    'game': Route(NormalLevel.new),
    'superGameStart': Route(SuperGame.new),
    'settings': Route(Settings.new),
    'shop': Route(Shop.new),
    'levels': Route(Levels.new),
    'loader': Route(LoaderPage.new)
  });
}
