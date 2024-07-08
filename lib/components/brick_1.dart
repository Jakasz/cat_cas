import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class Brick extends BodyComponent with ContactCallbacks {
  @override
  Body createBody() {
    final BodyDef body = BodyDef(
      type: BodyType.static,
      position: Vector2(25.6, 45.5),
    );
    renderBody = false;
    // final shape = EdgeShape()..set(Vector2(-10.5, 2), Vector2(10.5, 2));
    final List<Vector2> vertices = [
      Vector2(-8.5, -1.9),
      Vector2(9, -2.2),
      Vector2(-8.5, 0.5),
      Vector2(9, 0.5),
    ];
    // final shape = PolygonShape()..setAsBoxXY(8.4, 2.3);
    final shape = PolygonShape()..set(vertices);
    final fixtureDef = FixtureDef(shape)..friction = 0;

    return world.createBody(body)..createFixture(fixtureDef);
  }

  @override
  Future<void> onLoad() async {
    add(SpriteComponent(
        anchor: Anchor.center,
        sprite: await Sprite.load("brick_1.png"),
        size: Vector2(18.1, 5.5)));
    return super.onLoad();
  }
}
