import 'dart:async';
import 'package:flame/components.dart';
import '../endless_runner.dart';

class PlayArea extends RectangleComponent with HasGameReference<EndlessRunner> {
  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, game.height);
  }
}
