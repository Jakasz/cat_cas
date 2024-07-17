import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class Brick3 extends BodyComponent<MainGameScreen>
    with ContactCallbacks, HasGameRef<MainGameScreen> {
  bool needToDestroy = false;
  late double bodyX;
  late double bodyY;
  @override
  Body createBody() {
    final BodyDef body = BodyDef(
      type: BodyType.static,
      position: Vector2(gameRef.size.x * 0.3, gameRef.size.y * 0.35),
    );
    final List<Vector2> vertices = [
      Vector2(bodyX / 2, bodyY / 2),
      Vector2(bodyX / -2, bodyY / 2),
      Vector2(bodyX / 2, bodyY / -2),
      Vector2(bodyX / -2, bodyY / -2),
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
    bodyX = gameRef.size.x * (0.171 * 2);
    bodyY = gameRef.size.x * (0.046 * 2);
    add(SpriteComponent(
        anchor: Anchor.center,
        sprite: Sprite(gameRef.images.fromCache("brick_3.png")),
        size: Vector2(bodyX, bodyY)));
    return super.onLoad();
  }
}
