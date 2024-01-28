import 'package:flutter/material.dart';
import 'package:runner/src/widgets/ARscreen.dart';

class Collision extends StatefulWidget {
  const Collision({Key? key}) : super(key: key);

  @override
  _CollisionState createState() => _CollisionState();
}

class _CollisionState extends State<Collision> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Over!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You collided with an object!',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              child: const Text('Replay'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ARScreen()), // Replace ARScreen with the actual class name of your AR screen
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
