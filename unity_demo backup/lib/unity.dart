import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class UnityViewPage extends StatefulWidget {
  const UnityViewPage({Key? key}) : super(key: key);

  @override
  _UnityViewPageState createState() => _UnityViewPageState();
}

class _UnityViewPageState extends State<UnityViewPage> {
  late UnityWidgetController controller;
  double slidervalue = 0.0;

  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unity View'),
      ),
      body: Card(
        margin: const EdgeInsets.all(8.0),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            UnityWidget(
              fullscreen: false,
              onUnityCreated: createdUnityWidget,
            ),
            const Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Card(
                elevation: 10,
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text("rotation speed")),
                  ],
                ),
              ),
            ),
            Slider(
              value: slidervalue,
              min: 0.0,
              max: 30.0,
              divisions: 30,
              label: '${slidervalue.round()}',
              onChanged: (double value) {
                setState(() {
                  slidervalue = value;
                });
                setRotationSpeed(value.toString());
              },
            ),
          ],
        ),
      ),
    );
  }

  void createdUnityWidget(controller) {
    this.controller = controller;
  }

  void setRotationSpeed(String speed) {
    log("executing setRotationSpeed, speed: $speed");
    controller.postMessage(
      'Cube2',
      'SetRotationSpeed',
      speed,
    );
  }
}
