import 'package:cas_cat/components/coin.dart';
import 'package:cas_cat/pages/main_game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomWall extends BodyComponent<MainGameScreen> with ContactCallbacks {
  late final SharedPreferences prefs;
  @override
  Body createBody() {
    final BodyDef body = BodyDef(
      userData: this,
      type: BodyType.static,
      position: Vector2.zero(),
    );
    renderBody = false;

    final shape = EdgeShape()
      ..set(
          Vector2(0, gameRef.size.y), Vector2(gameRef.size.x, gameRef.size.y));

    final fixtureDef = FixtureDef(shape)
      ..friction = .7
      ..restitution = 0.1;

    return world.createBody(body)..createFixture(fixtureDef);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is Coin) {
      var failScore = prefs.getInt('failScore') ?? 0;
      prefs.setInt('failScore', failScore + 1);
      other.removeFromParent();
    }
  }
}
