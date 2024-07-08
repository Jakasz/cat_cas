import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class Coin extends BodyComponent<MainGameScreen> with CollisionCallbacks {
  final Vector2 impulseDirection;

  Coin(this.impulseDirection);

  @override
  Body createBody() {
    final BodyDef body = BodyDef(
      userData: this,
      type: BodyType.dynamic,
      position: Vector2(20, 20),
    );
    renderBody = false;
    final shape = CircleShape()..radius = 2.25;
    final fixtureDef =
        FixtureDef(shape, density: .1, restitution: .1, friction: .5);
    return world.createBody(body)..createFixture(fixtureDef);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(SpriteComponent(
        anchor: Anchor.center,
        sprite: await Sprite.load("coin.png"),
        size: Vector2(4.5, 4.5)));

    body.applyLinearImpulse(impulseDirection);
  }
}
