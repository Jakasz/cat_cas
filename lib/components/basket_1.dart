import 'package:cas_cat/components/coin.dart';
import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Basket1 extends BodyComponent<MainGameScreen>
    with ContactCallbacks, HasGameRef<MainGameScreen> {
  late final SharedPreferences prefs;
  int score = 0;
  late double bodyX;
  late double bodyY;
  @override
  Body createBody() {
    final BodyDef body = BodyDef(
      userData: this,
      type: BodyType.static,
      position: Vector2(gameRef.size.x * 0.50, gameRef.size.y * 0.75),
    );
    final List<Vector2> vertices = [
      Vector2(-bodyX / 2, -bodyY / 2),
      Vector2(-bodyX / 2, bodyY / 2),
      Vector2(bodyX / 2, -bodyY / 2),
      Vector2(bodyX / 2, bodyY / 2),
    ];
    renderBody = false;
    final shape = PolygonShape()..set(vertices);

    final fixtureDef = FixtureDef(shape);

    return world.createBody(body)..createFixture(fixtureDef);
  }

  @override
  Future<void> onLoad() async {
    bodyX = (gameRef.size.x * 0.228 * 2.5);
    bodyY = (gameRef.size.x * 0.117 * 2.5);
    await super.onLoad();
    prefs = await SharedPreferences.getInstance();
    score = prefs.getInt('score') ?? 0;
    add(SpriteComponent(
        anchor: Anchor.center,
        sprite: Sprite(gameRef.images.fromCache("basket_1.png")),
        size: Vector2(bodyX, bodyY)));
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
