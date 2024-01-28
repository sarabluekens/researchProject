import 'package:flutter/material.dart';
import 'package:runner/src/widgets/ARscreen.dart';
import 'package:runner/src/widgets/input.dart';

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

  final List<Widget> _widgetOptions = <Widget>[
    InputScreen(),
    // ignore: prefer_const_constructors
    ARScreen(),
    const Text(
      'Index 2: Combo',
    ),
    const Text(
      'Index 3: Unity',
    ),
  ];

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
