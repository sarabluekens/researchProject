import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:runner/src/components/brick2.dart';
import 'package:runner/src/components/components.dart';
import 'package:runner/src/config.dart';
import 'package:runner/src/endless_runner.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class Brick extends RectangleComponent
    with CollisionCallbacks, HasGameReference<EndlessRunner> {
  final int rows;
  final int columns;
  final String spriteImage;

  Brick(
      Vector2 position, this.rows, this.columns, this.spriteImage, Color color)
      : super(
          position: position,
          anchor: Anchor.center,
          paint: Paint()
            ..color = color
            ..style = PaintingStyle.fill,
        );

  double speed = obstacleSpeed;

  //Animation//
  late final SpriteAnimationComponent brick;
  SpriteAnimationComponent brick1Animation = SpriteAnimationComponent();

  @override
  Future<void> onLoad() async {
    print("brick1 created ${position.x}, ${position.y}");

    SpriteAnimationData data = SpriteAnimationData.sequenced(
      amountPerRow: columns,
      amount: columns * rows,
      stepTime: 0.1,
      textureSize: Vector2(265 / columns, 265 / rows),
    );
    final response = await http.get(Uri.parse(spriteImage!));
    print('Image downloaded');

    // download image -> flame doesnt do https
    final codec = await ui.instantiateImageCodec(response.bodyBytes);
    final frame = await codec.getNextFrame();

    final spriteSheet = frame.image;
    print('Image created');

    print('Demo image loaded');

    brick1Animation = SpriteAnimationComponent.fromFrameData(
      spriteSheet,
      data,
    )..size = Vector2(128, 128);

    print('Animation component created, ${brick1Animation.size}');
    add(RectangleHitbox(anchor: Anchor.topLeft, size: Vector2(128, 128)));

    add(brick1Animation);
    print('Animation added to the game');
  }

  ///end Animation///

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Bat) {
      print(
          "collision brick ${position.x}, ${position.y} with ${other.position.x}, ${other.position.y}");
      removeFromParent();
      game.playState = PlayState.gameOver;
      game.world.removeAll(game.world.children.query<Ball>());
      game.world.removeAll(game.world.children.query<Bat>());
      game.world.removeAll(game.world.children.query<Brick>());
      game.world.removeAll(game.world.children.query<Brick2>());
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
