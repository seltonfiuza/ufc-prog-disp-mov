import 'package:flutter/material.dart';
import 'package:trab_02/screens/Home.dart';
import 'package:trab_02/screens/Login.dart';
import 'package:trab_02/services/auth.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Root(),
    );
  }
}

class Root extends StatefulWidget {
  var root;
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  void initState() {
    widget.root = Scaffold(body: Text(''));
    // TODO: implement initState
    root();
    super.initState();
  }

  root() async {
    await Permission.contacts.request();
    var w = await Auth().hasData();
    print(w);
    setState(() {
      widget.root = w ? HomePage(auth: Auth()) : LoginPage(auth: Auth());
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.root;
  }
}
