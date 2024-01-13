import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Navigation(),
    );
  }
}

class Navigation extends StatelessWidget {
  const Navigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SafeArea(
                child: NavigationBar(
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.video_call),
                      label: 'AR',
                    ),
                  ],
                  selectedIndex: 0,
                  onDestinationSelected: (value) {
                    //ignore: avoid_print
                    print('selected: $value');
                  },
                ),
              ),
            ),
          ],
        ),
        const Expanded(child: TestComponent()),
      ],
    );
  }
}

class TestComponent extends StatelessWidget {
  const TestComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text("Hello scary world");
  }
}
