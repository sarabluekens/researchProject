import 'dart:developer';

import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Unity Flutter Demo'),
        ),
        body: Card(
          margin: const EdgeInsets.all(8),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            children: <Widget>[
              UnityWidget(
                onUnityCreated: onUnityCreated,
                onUnitySceneLoaded: onUnitySceneLoaded,
                onUnityMessage: onUnityMessage,
                fullscreen: false,
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                // <You need a PointerInterceptor here on web>
                child: Card(
                  elevation: 10,
                  child: Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text("Rotation speed:"),
                      ),
                      Slider(
                        onChanged: (value) {
                          setState(() {
                            slidervalue = value;
                          });
                          setRotationSpeed(value.toString());
                        },
                        value: slidervalue,
                        min: 0,
                        max: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setRotationSpeed(String speed) {
    print('Send message to unity: ${speed}');
    // Assume that _unityWidgetController is an instance of UnityWidgetController

    if (_unityWidgetController != null) {
      log("_unityWidgetController is not null");

      _unityWidgetController?.postMessage(
        'Cube2',
        'SetRotationSpeed',
        speed,
      );
      log("success");
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
      log('Unity controller is connected');
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
