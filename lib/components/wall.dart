import 'package:cas_cat/pages/main_game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class Walls extends BodyComponent<MainGameScreen> with ContactCallbacks {
  final Vector2 start;
  final Vector2 end;

  Walls(this.start, this.end);
  @override
  Body createBody() {
    final BodyDef body = BodyDef(
      type: BodyType.static,
      position: Vector2.zero(),
    );
    renderBody = false;

    final shape = EdgeShape()..set(start, end);

    final fixtureDef = FixtureDef(shape)
      ..friction = .7
      ..restitution = 0.1;

    return world.createBody(body)..createFixture(fixtureDef);
  }
}
