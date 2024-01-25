import 'package:google_fonts/google_fonts.dart';
import 'package:runner/src/widgets/game_app.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const NavigationBarApp());
}

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Bar',
      theme: ThemeData(useMaterial3: true),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    GameApp(),
    Text(
      'Index 1: AR',
    ),
    Text(
      'Index 2: Combo',
    ),
    Text(
      'Index 3: Unity',
    ),
  ];

  void _onItemTapped(int index) {}

  @override
  Widget build(BuildContext context) {
    final ThemeData = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          indicatorColor: ThemeData.colorScheme.primary,
          selectedIndex: _selectedIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.gamepad),
              icon: Icon(Icons.gamepad_outlined),
              label: 'Game',
            ),
            NavigationDestination(
              icon: Icon(Icons.video_camera_back),
              label: 'AR',
            ),
            NavigationDestination(
              icon: Icon(Icons.plus_one),
              label: 'Combo',
            ),
            NavigationDestination(
              icon: Icon(Icons.engineering),
              label: 'Unity',
            ),
          ]),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
