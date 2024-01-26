import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as Vector64;

class ArScreen extends StatefulWidget {
  const ArScreen({Key? key}) : super(key: key);
  @override
  _ArScreenState createState() => _ArScreenState();
}

class _ArScreenState extends State<ArScreen> {
  late ArCoreController augmentedRealityCoreController;

  _augmentedRealityViewCreated(ArCoreController coreController) {
    augmentedRealityCoreController = coreController;
    displayEarthMapSphere(augmentedRealityCoreController);
  }

  displayEarthMapSphere(ArCoreController coreController) async {
    final ByteData earthtextureBytes =
        await rootBundle.load("assets/images/earth_map.jpg");
    final materials = ArCoreMaterial(
      color: Colors.blue,
      textureBytes: earthtextureBytes.buffer.asUint8List(),
    );

    final sphere = ArCoreSphere(
      materials: [materials],
      radius: 0.1,
    );

    final node = ArCoreNode(
      shape: sphere,
      position: Vector64.Vector3(0, 0, -1.5),
    );

    augmentedRealityCoreController.addArCoreNode(node);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Anchors & Objects on Planes'),
        ),
        body: ArCoreView(
          onArCoreViewCreated: _augmentedRealityViewCreated,
        ));
  }
}
