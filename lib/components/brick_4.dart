import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class Brick4 extends BodyComponent<MainGameScreen>
    with ContactCallbacks, HasGameRef<MainGameScreen> {
  late double bodyX;
  late double bodyY;
  @override
  Body createBody() {
    final BodyDef body = BodyDef(
      type: BodyType.static,
      position: Vector2(gameRef.size.x * 0.3, gameRef.size.y * 0.48),
    );
    final List<Vector2> vertices = [
      Vector2(-bodyX / 2 * 0.73, bodyY / 2),
      Vector2(bodyX / 2, -bodyY / 2 * 0.63),
      Vector2(bodyX / 2 * 0.73, -bodyY / 2),
      Vector2(-bodyX / 2, bodyY / 2 * 0.63),
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
    bodyX = gameRef.size.x * (0.141 * 2);
    bodyY = gameRef.size.y * (0.080 * 2);
    add(SpriteComponent(
        anchor: Anchor.center,
        sprite: await Sprite.load("brick_4.png"),
        size: Vector2(bodyX, bodyY)));
    await super.onLoad();
  }
}
