// @dart=2.9
import 'package:flutter/material.dart';
import 'package:morse/morse.dart';
import 'package:torch_light/torch_light.dart';

void main() => runApp(MaterialApp(
      home: Home(),
    ));

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _text = TextEditingController();
  String userInput = '';
  String morseCode = '';
  String display = 'Enter the Word to convert';
  final Morse morse = new Morse();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
            ),
            Text(
              display,
              style: TextStyle(
                fontSize: 30
                fontFamily: 'Montserrat',
                ),
            ),
            Expanded(
              child: Container(
                child: Center(
                  child: Text(
                    morseCode,
                    style: TextStyle(fontSize: 30.0),
                  ),
                ),
              ),
            ),
            TextField(
              controller: _text,
              decoration: InputDecoration(
                hintText: "Enter the Word",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    _text.clear();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      display = "Morse Code is";
                      userInput = _text.text;
                      morseCode = morse.encode(userInput);
                    });
                  },
                  child: Text("Convert"),
                  color: Colors.teal[100],
                ),
                MaterialButton(
                  onPressed: () async {
                    for (var i = 0; i < morseCode.length; i++) {
                      userInput = _text.text;
                      morseCode = morse.encode(userInput);
                      if (morseCode[i] == '-') {
                        _turnOnFlash(context);
                        await Future.delayed(const Duration(seconds: 1), () {});
                      } else if (morseCode[i] == '.') {
                        _turnOffFlash(context);
                        await Future.delayed(const Duration(seconds: 1), () {});
                      }
                    }
                    _turnOffFlash(context);
                  },
                  child: Text("Flash"),
                  color: Colors.teal[100],
                )
              ],
            ),
            SizedBox(
              height: 200,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _turnOnFlash(BuildContext context) async {
    try {
      await TorchLight.enableTorch();
    } on Exception catch (_) {
      _showErrorMes('Could not enable Flashlight', context);
    }
  }

  Future<void> _turnOffFlash(BuildContext context) async {
    try {
      await TorchLight.disableTorch();
    } on Exception catch (_) {
      _showErrorMes('Could not enable Flashlight', context);
    }
  }

  void _showErrorMes(String mes, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mes)));
  }
}
