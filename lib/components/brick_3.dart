import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class Brick3 extends BodyComponent<MainGameScreen> with ContactCallbacks {
  bool needToDestroy = false;

  @override
  Body createBody() {
    final BodyDef body = BodyDef(
      type: BodyType.static,
      position: Vector2(10, 29),
    );
    final List<Vector2> vertices = [
      Vector2(-7, -1.8),
      Vector2(-7, 0),
      Vector2(7, -2),
      Vector2(7, 0),
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
        sprite: await Sprite.load("brick_3.png"),
        size: Vector2(15, 4)));
    return super.onLoad();
  }
}
