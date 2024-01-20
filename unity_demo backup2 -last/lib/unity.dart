import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class UnityViewPage extends StatefulWidget {
  const UnityViewPage({Key? key}) : super(key: key);

  @override
  _UnityViewPageState createState() => _UnityViewPageState();
}

class _UnityViewPageState extends State<UnityViewPage> {
  UnityWidgetController? _unityWidgetController;
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
              onUnityCreated: onUnityCreated,
              onUnitySceneLoaded: onUnitySceneLoaded,
              onUnityMessage: onUnityMessage,
              fullscreen: false,
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

  void setRotationSpeed(String speed) {
    print('Send message to unity: ${speed}');
    // Assume that _unityWidgetController is an instance of UnityWidgetController

    if (_unityWidgetController != null) {
      log("_unityWidgetController is not null");
      // _unityWidgetController!.resume();
      _unityWidgetController!.postMessage(
        'Cube2',
        'SB_SetRotationSpeed',
        speed,
      );
      log("success");
      log(_unityWidgetController?.isPaused() == true ? "paused" : "unpaused");
    } else {
      print('Error occurred: Unity Controller is null');
    }
  }

  // Communication from Unity to Flutter
  void onUnityMessage(message) {
    log('Received message from unity: ${message.toString()}');
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    _unityWidgetController = controller;

    if (_unityWidgetController != null) {
      log('Unity controller is connected $_unityWidgetController');
    } else {
      log('Unity controller is not connected');
    }
  }

  // Communication from Unity when new scene is loaded to Flutter
  void onUnitySceneLoaded(SceneLoaded? sceneInfo) {
    if (sceneInfo != null) {
      log('Received scene loaded from unity: ${sceneInfo.name}');
      log('Received scene loaded from unity buildIndex: ${sceneInfo.buildIndex}');
    }
  }
}
