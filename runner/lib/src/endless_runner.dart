import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/timer.dart';
import 'package:flame/events.dart';
import 'package:flame/parallax.dart';
import 'config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'components/components.dart';

enum PlayState { welcome, playing, gameOver, won }

class EndlessRunner extends FlameGame
    with HasCollisionDetection, KeyboardEvents, TapDetector, PanDetector {
  EndlessRunner()
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
    //world.add(Player());
  }

  void startGame() async {
    if (playState == PlayState.playing) return;
    world.removeAll(world.children.query<Ball>());
    world.removeAll(world.children.query<Bat>());
    world.removeAll(world.children.query<Brick>());
    ParallaxComponent bg = await loadParallaxComponent([
      ParallaxImageData('background3.jpg'),
      ParallaxImageData('background2.jpeg'),
    ],
        repeat: ImageRepeat.repeatY,
        baseVelocity: Vector2(0, -20),
        velocityMultiplierDelta: Vector2(0, 2),
        size: Vector2(width, height));
    world.add(bg);
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
      position: Vector2(width / 2, height * 0.90),
      size: Vector2(batWidth, batHeight),
      cornerRadius: const Radius.circular(ballRadius / 2),
    ));

    add(TimerComponent(
      period: 3,
      repeat: true,
      onTick: () => world.add(Brick(
          Vector2(
            (1 + 0.5) * brickWidth + (1 + 1) * brickGutter,
            (1 + 2.0) * brickHeight + 1 * brickGutter,
          ),
          Colors.red)),
    ));
  }

  @override
  void onTap() {
    if (playState != PlayState.playing) {
      super.onTap();
      print("tapped");
      startGame();
    }
  }

  @override
  void onPanEnd(details) {
    if (playState == PlayState.playing) {
      print("swiped");

      if (details.velocity[0] > 0) {
        print("swiped right ${world.children.query<Bat>().first.position[0]}");
        if (world.children.query<Bat>().first.position[0] < 600.0) {
          world.children.query<Bat>().first.moveBy(batStep);
        } else {
          print("swiped blocked");
        }
      } else if (details.velocity[0] < 0) {
        if (world.children.query<Bat>().first.position[0] > 170) {
          print("swiped left");
          world.children.query<Bat>().first.moveBy(-batStep);
        } else {
          print("swiped blocked");
        }
      }
    }
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
}
