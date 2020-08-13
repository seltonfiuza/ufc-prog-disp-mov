import 'package:flutter/material.dart';

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void operate() {
    var operator_1 = int.parse(controller_1.text);
    var operator_2 = int.parse(controller_2.text);
    if (operator_1 != null && operator_2 != null) {
      switch (operation) {
        case 'Adição':
          setState(() {
            res = (operator_1 + operator_2).toString();
          });
          break;
        case 'Subtração':
          setState(() {
            res = (operator_1 - operator_2).toString();
          });
          break;
        case 'Divisão':
          setState(() {
            res = (operator_1 / operator_2).toString();
          });
          break;
        case 'Multiplicação':
          setState(() {
            res = (operator_1 * operator_2).toString();
          });
          break;
        default:
      }
    }
  }

  final controller_1 = TextEditingController();
  final controller_2 = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    controller_1.dispose();
    controller_2.dispose();
    super.dispose();
  }

  InputDecoration inputDec = new InputDecoration(
    filled: true,
    fillColor: Colors.white,
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
  String operation = 'Adição';
  String res = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Task 01 - Calculadora Simples - Selton Fiuza'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 00.0, left: 50.0, right: 50.0),
        color: Colors.blueAccent,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage("assets/Calculator.jpeg"),
                  radius: 80,
                ),
                Column(
                  children: <Widget>[
                    new Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Operador 1',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            // child: numberField('operator_1'),
                            child: TextField(
                              decoration: inputDec,
                              style: new TextStyle(
                                fontSize: 18.0,
                                height: 1.0,
                              ),
                              keyboardType: TextInputType.number,
                              controller: controller_1,
                              // onChanged: (e) => stateOperador(, e),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    new Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Operador 2',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            // child: numberField('operator_2'),
                            child: TextField(
                              decoration: inputDec,
                              style: new TextStyle(
                                fontSize: 18.0,
                                height: 1.0,
                              ),
                              keyboardType: TextInputType.number,
                              controller: controller_2,
                              // onChanged: (e) => stateOperador(varName, e),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    new Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Operação',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 50),
                            child: DropdownButton<String>(
                              value: operation,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                color: Colors.black,
                              ),
                              underline: Container(
                                height: 2,
                                color: Colors.orange,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  operation = newValue;
                                });
                              },
                              items: <String>[
                                'Adição',
                                'Subtração',
                                'Multiplicação',
                                'Divisão'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    RaisedButton(
                      elevation: 5.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      color: Colors.deepOrange,
                      child: new Text('Calcular',
                          style: new TextStyle(
                              fontSize: 36.0, color: Colors.white)),
                      onPressed: () => operate(),
                    ),
                    SizedBox(height: 20),
                    Text(
                      res,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
