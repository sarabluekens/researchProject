import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:runner/src/components/components.dart';
import 'package:runner/src/config.dart';
import 'package:runner/src/endless_runner.dart';
import 'package:flutter/material.dart';

//  set array with urls to all three images,
// let a random function pick one of them
// and then use that url to create the image
// and add it to the world

class Brick2 extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameReference<EndlessRunner> {
  Brick2(Vector2 position, Color color)
      : super(
          position: position,
          anchor: Anchor.center,
          paint: Paint()
            ..color = color
            ..style = PaintingStyle.fill,
        );

  double speed = obstacleSpeed;

  //Animation//
  late final SpriteAnimationComponent brick2;
  SpriteAnimationComponent brickAnimation = SpriteAnimationComponent();

  @override
  Future<void> onLoad() async {
    print("brick2 created ${position.x}, ${position.y}");

    final sprite = await Flame.images.load("sprite_sheet_2.png");
    SpriteAnimationData data = SpriteAnimationData.sequenced(
      amount: 11,
      stepTime: 0.1,
      textureSize: Vector2(16, 18),
    );

    brickAnimation = SpriteAnimationComponent.fromFrameData(
      sprite,
      data,
    )..size = Vector2(128, 128);
    add(RectangleHitbox(anchor: Anchor.topLeft, size: Vector2(128, 128)));
    add(brickAnimation);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    print(
        "collision brick ${position.x}, ${position.y} with ${other.position.x}, ${other.position.y}");

    if (other is Bat) {
      removeFromParent();
      game.playState = PlayState.gameOver;
      game.world.removeAll(game.world.children.query<Ball>());
      game.world.removeAll(game.world.children.query<Bat>());
      game.world.removeAll(game.world.children.query<Brick2>());
      game.world.removeAll(game.world.children.query<Brick>());
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    y += speed * dt;

    if (y > game.height) {
      removeFromParent();
    }
  }
}
