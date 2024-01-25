import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'api_key.dart';
import 'package:http/http.dart' as http;

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
  String url = "https://api.openai.com/v1/images/generations";
  String? image;

  void GetAIImages() async {
    if (inputText.text.isNotEmpty) {
      var data = {
        "prompt": inputText.text,
        "n": 1,
        "size": "256x256",
      };

      var res = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${apiKey}",
          "Content-Type": "application/json"
        },
        body: jsonEncode(data),
      );

      var jsonResponse = jsonDecode(res.body);

      image = jsonResponse["data"][0]["url"];

      setState(() {
        // image = image;
      });
    } else {
      print("Please Enter Text To Generate AI image");
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
                  : Container(
                      child: Text("Please Enter Text To Generate AI image"),
                    ),
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
            GetAIImages();
          },
          tooltip: 'Generate AI Image',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
