import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'api_key.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  TextEditingController inputText = TextEditingController();
  String apiKey = MyDalleKey;
  String url = "https://api.openai.com/v1/images/edits";
  String? image;

  Image gridTemplate = Image.asset("grid.png");

  // void GetAIImages() async {
  //   if (inputText.text.isNotEmpty) {
  //     var data = {
  //       "prompt": inputText.text,
  //       "image":
  //           "https://media.discordapp.net/attachments/1026757369390178315/1200107746905825470/grid2.png",
  //       "n": 1,
  //       "size": "256x256",
  //     };

  //     var res = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         "Authorization": "Bearer ${apiKey}",
  //         "Content-Type": "multipart/form-data"
  //       },
  //       body: jsonEncode(data),
  //     );

  //     var jsonResponse = jsonDecode(res.body);
  //     print(jsonResponse);

  //     image = jsonResponse["data"][0]["url"];

  //     setState(() {
  //       // image = image;
  //     });
  //   } else {
  //     print("Please Enter Text To Generate AI image");
  //   }
  // }

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

        setState(() {
          // image = image;
        });
      });
    } else {
      print("Error ${res.statusCode}");
    }
  }

  void _handleSendButton() {
    print('Send button pressed with input: ${inputText}');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Open AI DALL.E"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              image != null
                  ? Image.network(image!, width: 256, height: 265)
                  : Image.asset("assets/images/grid.png",
                      width: 256, height: 256),
              Padding(
                padding: const EdgeInsets.all(16.0),
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
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            EditAIImages();
          },
          tooltip: 'Generate AI Image',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
