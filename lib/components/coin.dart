import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class Coin extends BodyComponent<MainGameScreen>
    with CollisionCallbacks, HasGameRef<MainGameScreen> {
  final Vector2 impulseDirection;

  Coin(this.impulseDirection);

  @override
  Body createBody() {
    final BodyDef body = BodyDef(
      userData: this,
      type: BodyType.dynamic,
      position: Vector2(200, 200),
    );
    renderBody = false;
    final shape = CircleShape()..radius = 22;
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
        size: Vector2(45, 45)));
    body.gravityOverride = Vector2(0, 100);
    // body.applyForce(Vector2(10, 1000));
    Vector2 deltaPos = position - body.position;
    body.applyLinearImpulse(
        Vector2(gameRef.size.x / 2 + 100, gameRef.size.y) * 1000);
    // body.applyAngularImpulse(200);
  }
}
