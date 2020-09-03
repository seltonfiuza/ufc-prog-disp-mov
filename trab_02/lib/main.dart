import 'package:flutter/material.dart';
import 'package:trab_02/screens/Home.dart';
import 'package:trab_02/screens/Login.dart';
import 'package:trab_02/services/auth.dart';

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
        home: Auth().getLoggedIn() ? HomePage() : LoginPage()
        // initialRoute: '/',
        // routes: {
        //   // When navigating to the "/" route, build the FirstScreen widget.
        //   '/': (context) => Root(),
        //   // When navigating to the "/second" route, build the SecondScreen widget.
        //   '/login': (context) => LoginPage(),
        //   '/home': (context) => HomePage()
        // },
        );
  }
}

class Root extends StatelessWidget {
  final auth = Auth();
  @override
  Widget build(BuildContext context) {
    // if (auth.getLoggedIn()) {
    //   Navigator.pushNamed(context, '/home');
    // } else {
    //   Navigator.pushNamed(context, '/login');
    // }
    return Container();
  }
}
