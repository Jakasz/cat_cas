import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class Brick5 extends BodyComponent with ContactCallbacks {
  @override
  Body createBody() {
    final BodyDef body = BodyDef(
      type: BodyType.static,
      position: Vector2(7, 47),
    );
    final List<Vector2> vertices = [
      Vector2(3.7, -1),
      Vector2(-3.6, 1),
      Vector2(-3.7, -1),
      Vector2(3.7, 1),
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
        sprite: await Sprite.load("brick_5.png"),
        size: Vector2(8, 2)));
    return super.onLoad();
  }
}
