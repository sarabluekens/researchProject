import 'dart:async';
import 'dart:ui';

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
  Timer? timer;
  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];
  Matrix4? cameraMatrix;
  Vector3? cameraPosition;
  Vector3? nodePosition;

  @override
  void dispose() {
    timer?.cancel(); // A
    super.dispose();
    arSessionManager!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Anchors & Objects on Planes'),
        ),
        body: Stack(children: [
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
                      child: const Text("Remove Everything")),
                ]),
          )
        ]));
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
    timer?.cancel();
    anchors.forEach((anchor) {
      arAnchorManager!.removeAnchor(anchor);
    });
    anchors = [];
  }

  Future<void> onNodeTapped(List<String> nodes) async {
    var number = nodes.length;
    arSessionManager!.onError("Tapped $number node(s)");
  }

  int count = 0;
  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    var singleHitTestResult = hitTestResults.firstWhere(
        (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);
    if (singleHitTestResult != null) {
      var newAnchor =
          ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
      bool? didAddAnchor = await arAnchorManager!.addAnchor(newAnchor);
      if (didAddAnchor!) {
        anchors.add(newAnchor);
        // Add note to anchor
        var newNode = ARNode(
            name: "node${count}",
            type: NodeType.localGLTF2,
            uri: "Models/Chicken_02/Chicken_02.gltf",
            scale: Vector3(1, 1, 1),
            position: Vector3(0.0, -1.0, -10.0),
            rotation: Vector4(0.0, 1.0, 0.0, pi / 2));
        bool? didAddNodeToAnchor =
            await arObjectManager!.addNode(newNode, planeAnchor: newAnchor);
        if (didAddNodeToAnchor!) {
          nodes.add(newNode);
          count++;

          timer =
              Timer.periodic(const Duration(milliseconds: 100), (timer) async {
            setState(() {
              // Assuming chickenNode is your ARNode representing the chicken
              newNode.transform =
                  newNode.transform * Matrix4.translationValues(-0.1, 0, 0.0);
            });
            cameraMatrix = await arSessionManager!.getCameraPose();
            cameraPosition = await cameraMatrix!.getTranslation();
            nodePosition = await newNode.transform.getTranslation();
            if (cameraPosition != null && nodePosition != null) {
              print("both: camera: ${cameraPosition}, anchor: ${nodePosition}");

              // TRESHOLD OP 0.2
              double distance = sqrt(
                  pow(cameraPosition![0] - nodePosition![0], 2) +
                      pow(cameraPosition![1] - nodePosition![1], 2) +
                      pow(cameraPosition![2] - nodePosition![2], 2));

              print("distance: ${distance}");
              if (distance < 1.0) {
                print("distance is kleiner dan 0.7");
                timer.cancel();
              }
            } else {
              print("Error: cameraPosition or nodePosition is null");
            }
          });
        } else {
          arSessionManager!.onError("Adding Node to Anchor failed");
        }
      } else {
        arSessionManager!.onError("Adding Anchor failed");
      }
    }
  }
}
