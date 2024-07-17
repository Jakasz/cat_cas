import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'coin.dart';

class SuperGameBasket extends BodyComponent<MainGameScreen>
    with ContactCallbacks, HasGameRef<MainGameScreen> {
  final Vector2 pos;
  final Function basketCollision;
  final SpriteComponent basketSprite;
  late double bodyX;
  late double bodyY;

  SuperGameBasket(
      {required this.pos,
      required this.basketCollision,
      required this.basketSprite});
  @override
  Body createBody() {
    final BodyDef body = BodyDef(
      userData: this,
      type: BodyType.static,
      position: pos,
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
    bodyX = (basketSprite.size.x);
    bodyY = (basketSprite.size.y);
    super.onLoad();

    add(basketSprite);
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is Coin) {
      other.removeFromParent();
      basketCollision();
    }
  }
}
