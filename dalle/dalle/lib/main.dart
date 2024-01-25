import 'package:flutter/material.dart';
import 'api_key.dart';

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

  void _handleSendButton() {
    print('Send button pressed with input: $_inputValue');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        onPressed: () {},
        tooltip: 'Generate AI Image',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
