import 'dart:async';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;

import 'package:flame/components.dart';
import 'package:flame/game.dart';

class Animation extends FlameGame {
  final int rows;
  final int columns;
  final String spriteImage;

  static Future<Animation> create(int rows, int columns, String image) async {
    // Load the image and create the animation
    // ...

    return Animation(rows, columns, image);
  }

  Animation(this.rows, this.columns, this.spriteImage);
  late final SpriteAnimationComponent brick2;
  SpriteAnimationComponent brickAnimation = SpriteAnimationComponent();

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    print("$rows, $columns, $spriteImage");

    camera.viewfinder.anchor = Anchor.topLeft;

    SpriteAnimationData data = SpriteAnimationData.sequenced(
      amountPerRow: columns,
      amount: columns * rows,
      stepTime: 0.1,
      textureSize: Vector2(256 / columns, 256 / rows),
    );
    final response = await http.get(Uri.parse(spriteImage!));
    print('Image downloaded');

    // download image -> flame doesnt do https
    final codec = await ui.instantiateImageCodec(response.bodyBytes);
    final frame = await codec.getNextFrame();

    final spriteSheet = frame.image;
    print('Image created');

    debugMode = true;
    print('Demo image loaded');

    brickAnimation = SpriteAnimationComponent.fromFrameData(
      spriteSheet,
      data,
    )..size = Vector2(128, 128);

    print('Animation component created');
    add(brickAnimation);
    print('Animation added to the game');
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
