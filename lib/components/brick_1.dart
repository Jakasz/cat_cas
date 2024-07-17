import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class Brick extends BodyComponent<MainGameScreen>
    with ContactCallbacks, HasGameRef<MainGameScreen> {
  late double bodyX;
  late double bodyY;
  @override
  Body createBody() {
    final BodyDef body = BodyDef(
      type: BodyType.static,
      position: Vector2(gameRef.size.x * 0.65, gameRef.size.y * 0.6),
    );
    renderBody = false;
    // final shape = EdgeShape()..set(Vector2(-10.5, 2), Vector2(10.5, 2));
    final List<Vector2> vertices = [
      Vector2(bodyX / 2, bodyY / 2.3),
      Vector2(-bodyX / 2, bodyY / 2.3),
      Vector2(bodyX / 2, -bodyY / 1.85),
      Vector2(-bodyX / 2, -bodyY / 2.3),
    ];
    // final shape = PolygonShape()..setAsBoxXY(8.4, 2.3);
    final shape = PolygonShape()..set(vertices);
    final fixtureDef = FixtureDef(shape)..friction = 0;

    return world.createBody(body)..createFixture(fixtureDef);
  }

  @override
  Future<void> onLoad() async {
    bodyX = gameRef.size.x * (0.180 * 2.5);
    bodyY = gameRef.size.y * (0.031 * 2.1);

    await super.onLoad();
    add(SpriteComponent(
        anchor: Anchor.center,
        sprite: Sprite(gameRef.images.fromCache("brick_1.png")),
        size: Vector2(bodyX, bodyY)));
  }
}
