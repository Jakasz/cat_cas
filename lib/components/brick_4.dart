import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class Brick4 extends BodyComponent with ContactCallbacks {
  @override
  Body createBody() {
    final BodyDef body = BodyDef(
      type: BodyType.static,
      position: Vector2(12, 38),
    );
    final List<Vector2> vertices = [
      Vector2(-3.8, 6),
      Vector2(-4, 5),
      Vector2(5, -4),
      Vector2(3.8, -6),
    ];
    renderBody = false;
    final shape = PolygonShape()..set(vertices);

    final fixtureDef = FixtureDef(shape)
      ..friction = .1
      ..restitution = 0.1;

    return world.createBody(body)..createFixture(fixtureDef);
  }

  @override
  Future<void> onLoad() async {
    add(SpriteComponent(
        anchor: Anchor.center,
        sprite: await Sprite.load("brick_4.png"),
        size: Vector2(11, 13)));
    return super.onLoad();
  }
}
