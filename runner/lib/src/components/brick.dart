import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:runner/src/components/components.dart';
import 'package:runner/src/config.dart';
import 'package:runner/src/endless_runner.dart';
import 'package:flutter/material.dart';

class Brick extends RectangleComponent
    with CollisionCallbacks, HasGameReference<EndlessRunner> {
  Brick(Vector2 position, Color color)
      : super(
            position: position,
            size: Vector2(brickWidth, brickHeight),
            anchor: Anchor.center,
            paint: Paint()
              ..color = color
              ..style = PaintingStyle.fill,
            children: [RectangleHitbox()]);

  double speed = obstacleSpeed;
  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    removeFromParent();
    game.playState = PlayState.gameOver;
    game.world.removeAll(game.world.children.query<Ball>());
    game.world.removeAll(game.world.children.query<Bat>());

    // if (game.world.children.query<Brick>().length == 1) {
    //   game.playState = PlayState.won;
    // }
  }

  @override
  void update(double dt) {
    super.update(dt);
    y += speed * dt;
  }
}
