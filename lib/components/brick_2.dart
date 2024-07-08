import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class Brick2 extends BodyComponent with ContactCallbacks {
  @override
  Body createBody() {
    final BodyDef body = BodyDef(
      type: BodyType.static,
      position: Vector2(29.4, 31.5),
    );
    final List<Vector2> vertices = [
      Vector2(-4.5, -6),
      Vector2(0, -7),
      Vector2(-0.1, 7),
      Vector2(3, 6.5),
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
        sprite: await Sprite.load("brick_2.png"),
        size: Vector2(9.5, 15)));
    return super.onLoad();
  }
}
