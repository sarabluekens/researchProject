import 'dart:convert';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:runner/src/widgets/game_app.dart';
import '../../api_key.dart';
import 'package:http/http.dart' as http;

class InputScreen extends StatefulWidget {
  InputScreen({super.key});

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  //Dalle-vars
  final TextEditingController _controller = TextEditingController();
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
  //
  void EditAIImages() async {
    var uri = Uri.parse("https://api.openai.com/v1/images/edits");
    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = "Bearer ${apiKey}"
      ..fields['prompt'] = inputText.text
      ..fields['n'] = "1"
      ..fields['size'] = "256x256";

    // to edit image.png
    var imageBytes = await rootBundle.load('assets/images/grid.png');
    var imageFile = http.MultipartFile.fromBytes(
      'image',
      imageBytes.buffer.asUint8List(),
      filename: 'grid.png',
    );

    // toevoegen van image.png aan de request
    request.files.add(imageFile);

    // versturen van de request en opvangen van het antwoord
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
              Column(
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          EditAIImages();
                        },
                        child: Text("Generate image"),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 100,
                    height: 70,
                    child: TextField(
                      controller: inputRows,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          hintText: "#Rows",
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
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            hintText: "#Columns",
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
                ],
              ),
              Container(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GameApp(
                                int.parse(inputRows.text),
                                int.parse(inputColumns.text),
                                image!,
                              )),
                    );
                  },
                  child: Text("play game"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
