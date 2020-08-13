import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:share/share.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vamos Rachar!',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Vamos Rachar!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum TtsState { playing, stopped, paused, continued }

class _MyHomePageState extends State<MyHomePage> {
  String res = 'R\$ -';
  String msg = '';

  FlutterTts flutterTts;

  final controller_1 = TextEditingController();
  final controller_2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    flutterTts.setLanguage('pt-BR');
  }

  @override
  void dispose() {
    controller_1.dispose();
    controller_2.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Future _speak() async {
    if (msg != null) {
      if (msg.isNotEmpty) {
        await flutterTts.speak(msg);
      }
    }
  }

  updateRes() {
    var resultado =
        double.parse(controller_1.text) / double.parse(controller_2.text);
    var r = (resultado.isNaN || resultado.isInfinite ? 0 : resultado)
        .toStringAsFixed(2);
    setState(() {
      res = "R\$ " + r;
      msg = 'A Conta de R\$ ${controller_1.text}' +
          ' dividida para ' +
          controller_2.text +
          ' é: $res';
    });
  }

  InputDecoration inputDec = new InputDecoration(
    filled: true,
    contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(25.7),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(25.7),
    ),
    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "Vamos\nRachar!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 54,
                  color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.attach_money,
                    size: 42.0,
                    color: Colors.white,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: TextField(
                        decoration: inputDec,
                        style: new TextStyle(
                          fontSize: 46.0,
                          color: Colors.white,
                          height: 1.0,
                        ),
                        keyboardType: TextInputType.number,
                        controller: controller_1,
                        onChanged: (e) => updateRes(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people,
                    size: 42.0,
                    color: Colors.white,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: TextField(
                        decoration: inputDec,
                        style: new TextStyle(
                          fontSize: 46.0,
                          color: Colors.white,
                          height: 1.0,
                        ),
                        keyboardType: TextInputType.number,
                        controller: controller_2,
                        onChanged: (e) => updateRes(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              res,
              style: TextStyle(
                fontSize: 46,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Share.share(msg);
                  },
                  child: Icon(
                    Icons.share,
                  ),
                ),
                FloatingActionButton(
                  onPressed: () => _speak(),
                  tooltip: 'Increment',
                  child: Icon(Icons.volume_up),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
