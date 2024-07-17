import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class Brick2 extends BodyComponent<MainGameScreen>
    with ContactCallbacks, HasGameRef<MainGameScreen> {
  @override
  Body createBody() {
    final BodyDef body = BodyDef(
      type: BodyType.static,
      position: Vector2(gameRef.size.x * 0.75, gameRef.size.y * 0.4),
    );
    final List<Vector2> vertices = [
      Vector2(-45.5, -70),
      Vector2(0, -70),
      Vector2(0, 70),
      Vector2(45.5, 70),
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
        sprite: Sprite(gameRef.images.fromCache("brick_2.png")),
        size: Vector2(95, 150)));
    return super.onLoad();
  }
}
