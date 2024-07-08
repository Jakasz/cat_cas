import 'package:cas_cat/components/coin.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Basket1 extends BodyComponent with ContactCallbacks {
  late final SharedPreferences prefs;
  int score = 0;
  @override
  Body createBody() {
    final BodyDef body = BodyDef(
      userData: this,
      type: BodyType.static,
      position: Vector2(19, 60),
    );
    final List<Vector2> vertices = [
      Vector2(-11, -5),
      Vector2(-11, 5),
      Vector2(11, -5),
      Vector2(11, 5),
    ];
    renderBody = false;
    final shape = PolygonShape()..set(vertices);

    final fixtureDef = FixtureDef(shape);

    return world.createBody(body)..createFixture(fixtureDef);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    prefs = await SharedPreferences.getInstance();
    score = prefs.getInt('score') ?? 0;
    add(SpriteComponent(
        anchor: Anchor.center,
        sprite: await Sprite.load("basket_1.png"),
        size: Vector2(22, 11)));
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is Coin) {
      score++;
      prefs.setInt('score', score);
      other.removeFromParent();
    }
  }
}
