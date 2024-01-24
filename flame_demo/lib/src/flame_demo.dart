import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/components.dart';

enum PlayState { welcome, playing, gameOver, won }

class FlameDemo extends FlameGame
    with HasCollisionDetection, KeyboardEvents, TapDetector {
  FlameDemo()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );

  final ValueNotifier<int> score = ValueNotifier<int>(0);
  final random = math.Random();

  //You expose the width and height of the game
  //so that the children components, like PlayArea,
  //can set themselves to the appropriate size.
  double get width => size.x;
  double get height => size.y;

  late PlayState _playState;
  PlayState get playState => _playState;

  set playState(PlayState playState) {
    _playState = playState;
    switch (playState) {
      case PlayState.welcome:
      case PlayState.gameOver:
      case PlayState.won:
        overlays.add(playState.name);
      case PlayState.playing:
        overlays.remove(PlayState.welcome.name);
        overlays.remove(PlayState.gameOver.name);
        overlays.remove(PlayState.won.name);
    }
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    //Configures the top left as the anchor for the viewfinder
    camera.viewfinder.anchor = Anchor.topLeft;
    world.add(PlayArea());

    playState = PlayState.welcome;
  }

  void startGame() {
    if (playState == PlayState.playing) return;
    world.removeAll(world.children.query<Ball>());
    world.removeAll(world.children.query<Bat>());
    world.removeAll(world.children.query<Brick>());

    playState = PlayState.playing;
    score.value = 0;

    world.add(Ball(
        difficultyModifier: difficultyModifier,
        radius: ballRadius,
        position: size / 2,
        velocity: Vector2(random.nextDouble() - 0.5 * width, height * 0.2)
            .normalized()
          ..scale(height / 4)));

    world.add(Bat(
      position: Vector2(width / 2, height * 0.95),
      size: Vector2(batWidth, batHeight),
      cornerRadius: const Radius.circular(ballRadius / 2),
    ));
    world.addAll([
      for (var i = 0; i < brickColors.length; i++)
        for (var j = 0; j <= 5; j++)
          Brick(
            Vector2(
              (i + 0.5) * brickWidth + (i + 1) * brickGutter,
              (j + 2.0) * brickHeight + j * brickGutter,
            ),
            brickColors[i],
          )
    ]);
  }

  @override
  void onTap() {
    super.onTap();
    startGame();
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        world.children.query<Bat>().first.moveBy(-batStep);

      case LogicalKeyboardKey.arrowRight:
        world.children.query<Bat>().first.moveBy(batStep);
      case LogicalKeyboardKey.space:
      case LogicalKeyboardKey.enter:
        startGame();
    }
    return KeyEventResult.handled;
  }

  @override
  Color backgroundColor() => const Color(0xfff2e8cf);
}
