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

/////////////////////////////////////////////////

// import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
// import 'package:flutter/material.dart';

// class ArScreen extends StatefulWidget {
//   @override
//   _arScreenState createState() => _arScreenState();
// }

// class _arScreenState extends State<ArScreen> {
//   ARCoreController arCoreController;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('AR Flutter Plugin Example')),
//       body: ARView(
//         onARViewCreated: onARViewCreated,
//         planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
//       ),
//     );
//   }

//   void onARViewCreated(ARCoreController arCoreController) {
//     this.arCoreController = arCoreController;
//     this.arCoreController.onPlaneOrPointTapped = onPlaneOrPointTapped;
//   }

//   void onPlaneOrPointTapped(List<ARHitTestResult> hits) {
//     final hit = hits.first;
//     // Add your code to handle the tap event here
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
// import 'package:vector_math/vector_math_64.dart' hide Colors;

// class ArScreen extends StatefulWidget {
//   @override
//   _ARScreenState createState() => _ARScreenState();
// }

// class _ARScreenState extends State<ArScreen> {
//   late ArCoreController arCoreController;

//   void _onArCoreViewCreated(ArCoreController controller) {
//     arCoreController = controller;

//     // Add AR content setup here
//     final cube = ArCoreCube(
//       materials: [ArCoreMaterial(color: Colors.blue)],
//       size: Vector3(0.5, 0.5, 0.5),
//     );

//     final cubeNode = ArCoreNode(shape: cube);
//     arCoreController.addArCoreNode(cubeNode);
//   }

//   void _createCube(ArCoreHitTestResult plane) {
//     final cube = ArCoreCube(
//       materials: [ArCoreMaterial(color: Colors.blue)],
//       size: Vector3(0.5, 0.5, 0.5),
//     );

//     final cubeNode = ArCoreNode(
//       shape: cube,
//       position: plane.pose.translation,
//     );
//     arCoreController.addArCoreNode(cubeNode);
//     Future.delayed(Duration(milliseconds: 100), () {
//       arCoreController.removeNode(nodeName: cubeNode.name);
//     });
//   }

//   void _onTapArView(List<ArCoreHitTestResult> hits) {
//     // Handle tap events on the AR view
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('AR App'),
//       ),
//       body: ArCoreView(
//         onArCoreViewCreated: _onArCoreViewCreated,
//         enableTapRecognizer: true,
//         // onTap: _onTapArView,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     arCoreController.dispose();
//     super.dispose();
//   }
// }
////////////////////////////////////////////

// import 'dart:async';
// import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
// import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
// import 'package:flutter/material.dart';
// import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
// import 'package:vector_math/vector_math_64.dart' as vector;

// class ArScreen extends StatefulWidget {
//   @override
//   _ArScreenState createState() => _ArScreenState();
// }

// class _ArScreenState extends State<ArScreen> {
//   late ArCoreController arCoreController;
//   late Timer _timer;
//   late vector.Vector3 _cubePosition;
//   late vector.Vector3 _cameraPosition;

//   @override
//   void dispose() {
//     _timer?.cancel();
//     arCoreController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('AR Flutter Plugin Example')),
//       body: ARView(
//         onARViewCreated: onARViewCreated,
//         planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
//       ),
//     );
//   }

//   void onARViewCreated(ArCoreController arCoreController) {
//     this.arCoreController = arCoreController;
//     this.arCoreController.onPlaneOrPointTapped = onPlaneOrPointTapped;
//     this.arCoreController.onCameraTransformUpdate = onCameraTransformUpdate;
//   }

//   void onCameraTransformUpdate(Matrix4 cameraTransform) {
//     _cameraPosition = vector.Vector3.zero();
//     cameraTransform.getTranslation(_cameraPosition);
//   }

//   void onPlaneOrPointTapped(List<ARHitTestResult> hits) {
//     final hit = hits.first;
//     _cubePosition = hit.worldTransform.getTranslation();
//     _timer =
//         Timer.periodic(Duration(seconds: 5), (timer) => createMovingCube());
//   }

//   void createMovingCube() {
//     final cube = ArCoreCube(
//       materials: [ArCoreMaterial(color: Colors.blue)],
//       size: vector.Vector3(0.1, 0.1, 0.1),
//     );

//     final cubeNode = ArCoreNode(
//       shape: cube,
//       position: _cubePosition,
//       name: 'cubeNode',
//     );

//     arCoreController.addArCoreNode(cubeNode);

//     Future.delayed(Duration(milliseconds: 100), () {
//       moveCubeTowardsCamera();
//     });
//   }

//   void moveCubeTowardsCamera() {
//     final direction = _cameraPosition - _cubePosition;
//     final speed = 0.01;
//     final movement = direction.normalized() * speed;
//     _cubePosition += movement;

//     arCoreController.removeNode(nodeName: 'cubeNode');
//     createMovingCube();
//   }
// }
////////////////////////////////////////////
///import 'dart:async';
// import 'dart:math';
// import "package:arcore_flutter_plugin/arcore_flutter_plugin.dart";
// import 'package:flame/game.dart';
// import 'package:flutter/material.dart';
// import "package:ar_flutter_plugin/ar_flutter_plugin.dart";

// class ArScreen extends StatefulWidget {
//   @override
//   _ARScreenState createState() => _ARScreenState();
// }

// class _ARScreenState extends State<ArScreen> {
//   late ArCoreCube cubeRenderable;
//   late ArCoreController arCoreController;
//   int count = 0;
//   @override
//   void initState() {
//     super.initState();
//     initializeModels();
//   }

//   void initializeModels() {
//     cubeRenderable = ArCoreCube(
//       materials: [
//         ArCoreMaterial(
//           color: Color.fromARGB(255, 255, 0, 0),
//         ),
//       ],
//       size: Vector3(50, 50, 50),
//     );
//   }

//   bool isARViewReady = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('AR App'),
//       ),
//       body: Stack(
//         children: [
//           ArCoreView(
//             onArCoreViewCreated: _onArCoreViewCreated,
//             enablePlaneRenderer: true,
//             enableTapRecognizer: true,
//             enableUpdateListener: true,
//             type: ArCoreViewType.STANDARDVIEW,
//           ),
//           if (!isARViewReady)
//             Center(
//               child: CircularProgressIndicator(),
//             ),
//         ],
//       ),
//     );
//   }

//   void _onArCoreViewCreated(ArCoreController controller) {
//     print("onArCoreViewCreated (plane)");
//     arCoreController = controller;
//     _setupTapGesture();
//     _setupPlaneDetection();
//     // Notify that the AR view is ready
//     setState(() {
//       isARViewReady = true;
//     });
//   }

//   void _setupTapGesture() {
//     arCoreController.onPlaneTap = _handleOnPlaneTap;
//     print("onPlaneTap set");
//   }

//   void _setupPlaneDetection() {
//     arCoreController.onPlaneDetected = _handleOnPlaneDetected;
//     print("onPlaneDetected set");
//   }

//   void _handleOnPlaneDetected(ArCorePlane plane) {
//     print("Plane detected: ${plane.type}");
//     // Handle the plane detection event here
//   }

//   void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
//     int countTap = 0;
//     print("tapped on plane");
//     final hit = hits.first;
//     final cube = ArCoreCube(
//       size: Vector3(0.1, 0.1, 0.1),
//       materials: [ArCoreMaterial(color: Colors.red)],
//     );
//     countTap++;
//     Timer.periodic(Duration(milliseconds: 100), (timer) {
//       final node = ArCoreNode(
//         shape: cube,
//         position: hit.pose.translation +
//             Vector3(
//                 0,
//                 0,
//                 -timer.tick *
//                     0.01), // Move the cube towards the camera over time
//         rotation: hit.pose.rotation,
//         name: "cube$count",
//       );
//       arCoreController.addArCoreNode(node);
//       print("${node.name} addded");
//       print(arCoreController.toString());

//       count++;

//       Future.delayed(Duration(milliseconds: 100), () {
//         arCoreController.removeNode(nodeName: "cube${count - 2}");
//         print("${node.name} removed");
//       });
//     });
//   }

//   @override
//   void dispose() {
//     arCoreController.dispose();
//     super.dispose();
//   }
// }
////////////////////////////////////////////
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart';
import 'dart:math';

class ObjectsOnPlanesWidget extends StatefulWidget {
  ObjectsOnPlanesWidget({Key? key}) : super(key: key);
  @override
  _ObjectsOnPlanesWidgetState createState() => _ObjectsOnPlanesWidgetState();
}

class _ObjectsOnPlanesWidgetState extends State<ObjectsOnPlanesWidget> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;

  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];

  @override
  void dispose() {
    super.dispose();
    arSessionManager!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Anchors & Objects on Planes'),
        ),
        body: Container(
            child: Stack(children: [
          ARView(
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: onRemoveEverything,
                      child: Text("Remove Everything")),
                ]),
          )
        ])));
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager!.onInitialize(
          showFeaturePoints: false,
          showPlanes: true,
          customPlaneTexturePath: "Images/triangle.png",
          showWorldOrigin: true,
        );
    this.arObjectManager!.onInitialize();

    this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
    this.arObjectManager!.onNodeTap = onNodeTapped;
  }

  Future<void> onRemoveEverything() async {
    /*nodes.forEach((node) {
      this.arObjectManager.removeNode(node);
    });*/
    anchors.forEach((anchor) {
      this.arAnchorManager!.removeAnchor(anchor);
    });
    anchors = [];
  }

  Future<void> onNodeTapped(List<String> nodes) async {
    var number = nodes.length;
    this.arSessionManager!.onError("Tapped $number node(s)");
  }

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    var singleHitTestResult = hitTestResults.firstWhere(
        (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);
    if (singleHitTestResult != null) {
      var newAnchor =
          ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
      bool? didAddAnchor = await this.arAnchorManager!.addAnchor(newAnchor);
      if (didAddAnchor!) {
        this.anchors.add(newAnchor);
        // Add note to anchor
        var newNode = ARNode(
            type: NodeType.localGLTF2,
            uri: "Models/Chicken_01/Chicken_01.gltf",
            scale: Vector3(0.2, 0.2, 0.2),
            position: Vector3(0.0, 0.0, 0.0),
            rotation: Vector4(1.0, 0.0, 0.0, 0.0));
        bool? didAddNodeToAnchor = await this
            .arObjectManager!
            .addNode(newNode, planeAnchor: newAnchor);
        if (didAddNodeToAnchor!) {
          this.nodes.add(newNode);
        } else {
          this.arSessionManager!.onError("Adding Node to Anchor failed");
        }
      } else {
        this.arSessionManager!.onError("Adding Anchor failed");
      }
      /*
      // To add a node to the tapped position without creating an anchor, use the following code (Please mind: the function onRemoveEverything has to be adapted accordingly!):
      var newNode = ARNode(
          type: NodeType.localGLTF2,
          uri: "Models/Chicken_01/Chicken_01.gltf",
          scale: Vector3(0.2, 0.2, 0.2),
          transformation: singleHitTestResult.worldTransform);
      bool didAddWebNode = await this.arObjectManager.addNode(newNode);
      if (didAddWebNode) {
        this.nodes.add(newNode);
      }*/
    }
  }
}
