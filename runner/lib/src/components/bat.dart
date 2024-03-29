import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:runner/src/components/brick2.dart';
import 'package:runner/src/components/components.dart';
import 'package:runner/src/endless_runner.dart';
import 'package:flutter/material.dart';

class Bat extends PositionComponent
    with CollisionCallbacks, HasGameRef<EndlessRunner> {
  //DragCallbacks
  Bat({
    required this.cornerRadius,
    required super.position,
    required super.size,
  }) : super(
          anchor: Anchor.center,
          children: [RectangleHitbox()],
        );

  late final SpriteAnimationComponent bat;
  SpriteAnimationComponent batAnimation = SpriteAnimationComponent();

  final Radius cornerRadius;

  @override
  Future<void> onLoad() async {
    print("player created ${position.x}, ${position.y}");

    final sprite = await Flame.images.load("player.png");
    SpriteAnimationData data = SpriteAnimationData.sequenced(
      amount: 18,
      stepTime: 0.2,
      textureSize: Vector2(32, 29),
    );

    batAnimation = SpriteAnimationComponent.fromFrameData(
      sprite,
      data,
    )
      ..size = Vector2(196, 196)
      ..scale = Vector2(1.3, 1.3);
    add(RectangleHitbox(
        position: Vector2(80.0, 90.0),
        anchor: Anchor.center,
        size: Vector2(150, 200)));
    add(batAnimation);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    print(
        "collision brick ${position.x}, ${position.y} with ${other.position.x}, ${other.position.y}");

    if (other is Brick || other is Brick2) {
      removeFromParent();
      game.playState = PlayState.gameOver;
      game.world.removeAll(game.world.children.query<Ball>());
      game.world.removeAll(game.world.children.query<Bat>());
      game.world.removeAll(game.world.children.query<Brick2>());
      game.world.removeAll(game.world.children.query<Brick>());
    }
  }

  void moveBy(double dx) {
    add(MoveToEffect(
        Vector2(
          (position.x + dx).clamp(width / 2, game.width - width / 2),
          position.y,
        ),
        EffectController(duration: 0.1)));
  }
}
