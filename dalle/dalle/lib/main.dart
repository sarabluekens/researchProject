import 'dart:async';
import 'dart:ui' as ui;
import 'dart:convert';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'api_key.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class Animation extends FlameGame {
  final int rows;
  final int columns;
  final String spriteImage;

  static Future<Animation> create(int rows, int columns, String image) async {
    // Load the image and create the animation
    // ...

    return Animation(rows, columns, image);
  }

  Animation(this.rows, this.columns, this.spriteImage);
  late final SpriteAnimationComponent brick2;
  SpriteAnimationComponent brickAnimation = SpriteAnimationComponent();

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    print("$rows, $columns, $spriteImage");

    camera.viewfinder.anchor = Anchor.topLeft;

    SpriteAnimationData data = SpriteAnimationData.sequenced(
      amountPerRow: columns,
      amount: columns * rows,
      stepTime: 0.1,
      textureSize: Vector2(256 / columns, 256 / rows),
    );
    final response = await http.get(Uri.parse(spriteImage!));
    print('Image downloaded');

    // download image -> flame doesnt do https
    final codec = await ui.instantiateImageCodec(response.bodyBytes);
    final frame = await codec.getNextFrame();

    final spriteSheet = frame.image;
    print('Image created');

    debugMode = true;
    print('Demo image loaded');

    brickAnimation = SpriteAnimationComponent.fromFrameData(
      spriteSheet,
      data,
    )..size = Vector2(128, 128);

    print('Animation component created');
    add(brickAnimation);
    print('Animation added to the game');
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Future<Animation>? myAnimation;

  TextEditingController inputText = TextEditingController();
  TextEditingController inputRows = TextEditingController();

  TextEditingController inputColumns = TextEditingController();

  String apiKey = MyDalleKey;
  String url = "https://api.openai.com/v1/images/edits";
  String? image;
  Image? spriteImage;
  bool _showGame = false;
  Image gridTemplate = Image.asset("grid.png");

  void EditAIImages() async {
    var uri = Uri.parse("https://api.openai.com/v1/images/edits");
    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = "Bearer ${apiKey}"
      ..fields['prompt'] = inputText.text
      ..fields['n'] = "1"
      ..fields['size'] = "256x256";

    var imageBytes = await rootBundle.load('assets/images/grid.png');
    var imageFile = http.MultipartFile.fromBytes(
      'image',
      imageBytes.buffer.asUint8List(),
      filename: 'grid.png',
    );

    request.files.add(imageFile);

    var res = await request.send();
    if (res.statusCode == 200) {
      res.stream.transform(utf8.decoder).listen((value) {
        var jsonResponse = jsonDecode(value);
        print(jsonResponse);

        image = jsonResponse["data"][0]["url"];

        setState(() {});
      });
    } else {
      print("Error ${res.statusCode}");
    }
  }

  void _handleSendButton() {
    print('Send button pressed with input: ${inputText}');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Open AI DALL.E"),
        ),
        body: Center(
          child: ListView(
            children: <Widget>[
              image != null
                  ? Image.network(image!, width: 256, height: 265)
                  : Image.asset("assets/images/grid.png",
                      width: 256, height: 256),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: 250,
                      height: 70,
                      child: TextField(
                        controller: inputText,
                        decoration: InputDecoration(
                            hintText: "Enter Text to Generate AI Image",
                            filled: true,
                            fillColor: Colors.blue.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            )),
                      ),
                    ),
                  ),
                  Container(
                    width: 70,
                    height: 70,
                    child: ElevatedButton(
                      onPressed: () {
                        EditAIImages();
                      },
                      child: Text("Generate animation"),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    child: TextField(
                      controller: inputRows,
                      decoration: InputDecoration(
                          hintText: "Rows",
                          filled: true,
                          fillColor: Colors.blue.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          )),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Container(
                      width: 100,
                      height: 70,
                      child: TextField(
                        controller: inputColumns,
                        decoration: InputDecoration(
                            hintText: "Columns",
                            filled: true,
                            fillColor: Colors.blue.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            )),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 70,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showGame = true;
                          myAnimation = Animation.create(
                            int.parse(inputRows.text),
                            int.parse(inputColumns.text),
                            image!,
                          );
                        });
                      },
                      child: Text("Generate animation"),
                    ),
                  ),
                ],
              ),
              if (_showGame)
                FutureBuilder<Animation>(
                  future: myAnimation,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show a loading spinner
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Container(
                        width: 100, // Set the width of the game
                        height: 100,
                        child: GameWidget(game: snapshot.data!),
                      );
                    }
                  },
                ),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
