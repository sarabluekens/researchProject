// import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:vector_math/vector_math_64.dart' as Vector64;

// class ArScreen extends StatefulWidget {
//   const ArScreen({Key? key}) : super(key: key);
//   @override
//   _ArScreenState createState() => _ArScreenState();
// }

// class _ArScreenState extends State<ArScreen> {
//   late ArCoreController augmentedRealityCoreController;

//   _augmentedRealityViewCreated(ArCoreController coreController) {
//     augmentedRealityCoreController = coreController;
//     displayEarthMapSphere(augmentedRealityCoreController);
//   }

//   displayEarthMapSphere(ArCoreController coreController) async {
//     final ByteData earthtextureBytes =
//         await rootBundle.load("assets/images/earth_map.jpg");
//     final materials = ArCoreMaterial(
//       color: Colors.blue,
//       textureBytes: earthtextureBytes.buffer.asUint8List(),
//     );

//     final sphere = ArCoreSphere(
//       materials: [materials],
//       radius: 0.1,
//     );

//     final node = ArCoreNode(
//       shape: sphere,
//       position: Vector64.Vector3(0, 0, -1.5),
//     );

//     augmentedRealityCoreController.addArCoreNode(node);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Anchors & Objects on Planes'),
//         ),
//         body: ArCoreView(
//           onArCoreViewCreated: _augmentedRealityViewCreated,
//         ));
//   }
// }

import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';

class ArScreen extends StatefulWidget {
  @override
  _ARScreenState createState() => _ARScreenState();
}

class _ARScreenState extends State<ArScreen> {
  late ArCoreCube cubeRenderable;
  late ArCoreController arCoreController;

  @override
  void initState() {
    super.initState();
    initializeModels();
  }

  void initializeModels() {
    cubeRenderable = ArCoreCube(
      materials: [
        ArCoreMaterial(
          color: Color.fromARGB(255, 255, 0, 0),
        ),
      ],
      size: Vector3(50, 50, 50),
    );
  }

  bool isARViewReady = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AR App'),
      ),
      body: Stack(
        children: [
          ArCoreView(
            onArCoreViewCreated: _onArCoreViewCreated,
            enablePlaneRenderer: true,
            enableTapRecognizer: true,
            enableUpdateListener: true,
          ),
          if (!isARViewReady)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    print("onArCoreViewCreated (plane)");
    arCoreController = controller;
    _setupTapGesture();
    _setupPlaneDetection();
    // Notify that the AR view is ready
    setState(() {
      isARViewReady = true;
    });
  }

  void _setupTapGesture() {
    arCoreController.onPlaneTap = _handleOnPlaneTap;
    print("onPlaneTap set");
  }

  void _setupPlaneDetection() {
    arCoreController.onPlaneDetected = _handleOnPlaneDetected;
    print("onPlaneDetected set");
  }

  void _handleOnPlaneDetected(ArCorePlane plane) {
    print("Plane detected: ${plane.type}");
    // Handle the plane detection event here
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    print("tapped on plane");
    final hit = hits.first;
    final pose = hit.pose;

    print("${pose.rotation} and ${pose.translation}");

    final node = ArCoreNode(
      shape: cubeRenderable,
      position: pose.translation,
      rotation: pose.rotation,
    );
    arCoreController.addArCoreNode(node);
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }
}
