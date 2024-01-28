import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Collision extends StatefulWidget {
  const Collision({Key? key}) : super(key: key);

  @override
  _CollisionState createState() => _CollisionState();
}

class _CollisionState extends State<Collision> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.pressStart2pTextTheme().apply(
          bodyColor: const Color(0xff184e77),
          displayColor: const Color(0xff184e77),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Game Over'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/images/gameOver.jpeg",
                  width: 250, height: 250),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'You collided with an object!',
                ),
              ),
              ElevatedButton(
                child: const Text('Replay'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
