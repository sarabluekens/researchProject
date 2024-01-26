import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

class Player extends FlameGame {
  Player() : super();

// insert sprite here
  @override
  Future<void> onLoad() async {
    final image = await images.load('sprite_sheet_2.png');
    final spriteSheet = SpriteSheet(
      image: image,
      srcSize: Vector2(16.0, 18.0),
    );

    final ghostAnimation =
        spriteSheet.createAnimation(row: 1, stepTime: 0.1, from: 0, to: 7);

    final spriteSize = Vector2(80.0, 90.0);

    final ghostComponent = SpriteAnimationComponent(
      animation: ghostAnimation,
      position: Vector2(0, 0),
      size: spriteSize,
    );

    add(ghostComponent);
  }
}
