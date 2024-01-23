import 'package:flame/game.dart';
import 'package:runner/src/config.dart';
import 'package:runner/src/endless_runner.dart';
import 'package:runner/src/widgets/overlay_screen.dart';
import 'package:runner/src/widgets/score_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  late final EndlessRunner game;

  @override
  void initState() {
    super.initState();
    game = EndlessRunner();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.pressStart2pTextTheme().apply(
          bodyColor: const Color(0xff184e77),
          displayColor: const Color(0xff184e77),
        ),
      ),
      home: Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xffa9d6e5),
                Color(0xfff2e8cf),
              ],
            )),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                    child: Column(
                  children: [
                    ScoreCard(score: game.score),
                    Expanded(
                      child: FittedBox(
                        child: SizedBox(
                          width: gameWidth,
                          height: gameHeight,
                          child: GameWidget(
                            game: game,
                            overlayBuilderMap: {
                              PlayState.welcome.name: (context, game) =>
                                  const OverlayScreen(
                                    title: 'F L A M E   D E M O',
                                    subtitle: 'Use key arrows or swipe to play',
                                  ),
                              PlayState.gameOver.name: (context, game) =>
                                  const OverlayScreen(
                                    title: 'G A M E   O V E R',
                                    subtitle: 'Tap to play again',
                                  ),
                              PlayState.won.name: (context, game) =>
                                  const OverlayScreen(
                                    title: "Y O U   W O N",
                                    subtitle: "Tap to play again",
                                  )
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
              ),
            )),
      ),
    );
  }
}
