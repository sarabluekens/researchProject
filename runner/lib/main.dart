import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: Runner()));
}

class Runner extends FlameGame {
  @override
  void onLoad() async {
    super.onLoad();
    ParallaxComponent bg = await loadParallaxComponent(
      [
        ParallaxImageData('background.jpeg'),
      ],
      baseVelocity: Vector2(20, 0),
      velocityMultiplierDelta: Vector2(20, 0),
    );
    add(bg);
  }
}
