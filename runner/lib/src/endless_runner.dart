import 'dart:async';
import 'dart:developer';
import 'dart:ffi';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/parallax.dart';
import 'package:runner/src/components/brick2.dart';
import 'config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'components/components.dart';

enum PlayState { welcome, playing, gameOver, won }

class EndlessRunner extends FlameGame
    with HasCollisionDetection, KeyboardEvents, TapDetector, PanDetector {
  final int rows;
  final int columns;
  final String spriteImage;
  EndlessRunner(this.rows, this.columns, this.spriteImage)
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );
  // String apiKey = dalle_key;
  final ValueNotifier<int> score = ValueNotifier<int>(0);
  final random = math.Random();
  late TimerComponent _timer;
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

        //drop images here

        log(" variables: $columns, $spriteImage, $rows");
      // clear intervam
      case PlayState.playing:
        overlays.remove(PlayState.welcome.name);
        overlays.remove(PlayState.gameOver.name);
        overlays.remove(PlayState.won.name);
    }
  }

  @override
  FutureOr<void> onLoad() async {
    debugMode = true;
    super.onLoad();
    //Configures the top left as the anchor for the viewfinder
    camera.viewfinder.anchor = Anchor.topLeft;
    world.add(PlayArea());
    playState = PlayState.welcome;
  }

  void startGame() async {
    world.removeAll(world.children.query<Ball>());
    world.removeAll(world.children.query<Bat>());
    world.removeAll(world.children.query<Brick>());
    ParallaxComponent bg = await loadParallaxComponent(
      [
        ParallaxImageData('background3.jpg'),
        ParallaxImageData('background2.jpeg'),
      ],
      repeat: ImageRepeat.repeatY,
      baseVelocity: Vector2(0, -20),
      velocityMultiplierDelta: Vector2(0, 2),
      size: Vector2(width, height),
    );
    world.add(bg);
    playState = PlayState.playing;
    score.value = 0;

    world.add(Bat(
      position: Vector2(width / 2, height * 0.90),
      size: Vector2(batWidth, batHeight),
      cornerRadius: const Radius.circular(ballRadius / 2),
    ));

    world.add(Brick(
        Vector2(
          random.nextDouble() * (width - brickWidth) + brickWidth / 2,
          (1 + 2.0) * brickHeight + 1 * brickGutter,
        ),
        rows,
        columns,
        spriteImage,
        Colors.red));
    List<int> lanes = [170, 410, 650];

    _timer = TimerComponent(
        period: 3.0,
        repeat: true,
        removeOnFinish: true,
        onTick: () => {
              if (playState == PlayState.playing)
                {
                  print(lanes[random.nextInt(3)].toDouble()),
                  print("timer tick, added brick"),
                  if (random.nextBool())
                    {
                      world.add(Brick(
                          Vector2(
                            lanes[random.nextInt(3)].toDouble(),
                            10,
                          ),
                          rows,
                          columns,
                          spriteImage,
                          Colors.red)),
                      print("timer tick, added 2nd brick"),
                    }
                  else
                    {
                      world.add(
                        Brick2(
                            Vector2(
                              lanes[random.nextInt(3)].toDouble(),
                              10,
                            ),
                            Colors.green),
                      ),
                    },
                }
            });

    add(_timer);
  }

  @override
  void onTap() {
    if (playState == PlayState.gameOver) {
      if (_timer.isLoaded) {
        remove(_timer);
      }
    }
    super.onTap();
    print("tapped");
    startGame();
  }

  @override
  void update(double dt) {
    if (playState == PlayState.playing) {
      // In this code, Duration.zero means the future will run as soon as possible, but not immediately, allowing the build phase to complete before the score is updated.
      Future.delayed(Duration.zero, () {
        score.value += 1;
      });
    }
    super.update(dt);
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
    } else {
      world.removeAll(world.children.query<Ball>());
      world.removeAll(world.children.query<Bat>());
      world.removeAll(world.children.query<Brick>());
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
