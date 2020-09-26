import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class JoinedPage extends StatefulWidget {
  @override
  _JoinedPageState createState() => _JoinedPageState();
}

class _JoinedPageState extends State<JoinedPage> {
  final ipController = TextEditingController();
  final portController = TextEditingController();
  final cepController = TextEditingController();
  final number2 = TextEditingController();
  var ipAddress;
  var port = 3000;
  int countPlayers, tentativas = 0;
  var connected = false;
  var isEnabled = true;
  var btnColor = Colors.lightBlue;
  String logradouro, cidade, estado, pontuacao, status = '';
  String msgEmbaixoDoBtn = '';
  final dio = Dio();
  var msg = '';
  final url = 'https://viacep.com.br/cep/json/';
  var cepResto = "750-650";
  var btnText = 'Entrar';
  IO.Socket socket;
  var btnTry = "Try";

  @override
  void dipose() {
    print('closing');
    // socket.dispose();
    super.dispose();
  }

  joinServer() {
    print('http://${this.ipController.text}:${this.portController.text}');
    socket =
        IO.io('http://${this.ipController.text}:${this.portController.text}');
    // IO.io('http://${this.ipController.text}:${this.portController.text}');
    print(socket);
    socket.on('connect_error', (e) {
      print(e);
    });
    socket.on('connect_timeout', (timeout) {
      print('timeout, $timeout');
    });
    socket.on('error', (e) {
      print(e);
    });
    socket.on('ping', (_) {
      print('ping');
    });
    socket.on('connection', (_) {
      print('connect1');
      this.setState(() {
        connected = true;
      });
    });
    socket.on('connect', (_) {
      print('connect');
      this.setState(() {
        connected = true;
      });
    });
    socket.on(
        'msg',
        (data) => () {
              print('iiiuiuiuiuiu');
              print(data);
              this.setState(() {
                connected = true;
              });
              // var result = checkCep(data);
              // socket.emit(result);
              // if (result == 1) {
              //   setState(() {
              //     status = 'Perdeu :(';
              //     btnTry = 'Você perdeu';
              //   });
              // }
            });
    socket.on('disconnect', (_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));
  }

  checkCep(cep) {
    if (double.parse(cep) < double.parse(cepController.text)) {
      return 0;
    } else if (double.parse(cep) > double.parse(cepController.text)) {
      return 2;
    } else {
      return 1;
    }
  }

  submit() async {
    var cep = number2.text + cepResto.replaceAll('-', '');
    try {
      Response response =
          await dio.get('https://viacep.com.br/ws/${cep}/json/');
      print(response.data);
      var data = response.data;
      if (!data.containsKey('erro')) {
        setState(() {
          logradouro = data['logradouro'];
          cidade = data['localidade'];
          estado = data['uf'];
          status = 'Errou';
          tentativas = tentativas + 1;
        });
      } else {
        setState(() {
          msg = 'CEP nao encontrado';
          tentativas = tentativas + 1;
        });
      }
    } catch (e) {
      setState(() {
        msg = 'CEP nao encontrado';
        tentativas = tentativas + 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return !this.connected
        ? Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('IP'),
                        Container(
                          width: 200,
                          child: TextField(
                            controller: this.ipController,
                            // maxLength: 8,
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold),
                            autocorrect: true,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ]),
                ),
                Center(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Port'),
                        Container(
                          width: 200,
                          child: TextField(
                            controller: this.portController,
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold),
                            autocorrect: true,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ]),
                ),
                Center(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('CEP'),
                        Container(
                          width: 200,
                          child: TextField(
                            controller: this.cepController,
                            maxLength: 8,
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold),
                            autocorrect: true,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ]),
                ),
                RaisedButton(
                  onPressed: this.isEnabled ? () => joinServer() : null,
                  color: this.btnColor,
                  child: Text(
                    this.btnText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Text(
                  this.msgEmbaixoDoBtn,
                  style: TextStyle(
                    fontSize: 32.0,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
          )
        : SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${this.ipAddress}:${this.port}",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.teal[800], fontSize: 36),
                      ),
                      Center(
                        child: Text(
                          "Players: ${this.countPlayers}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.lightBlue[700],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 200,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 70,
                            color: Colors.lightBlue[300],
                            child: Center(
                              child: TextField(
                                controller: this.number2,
                                // maxLength: 3,
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32.0,
                                    fontWeight: FontWeight.bold),
                                autocorrect: true,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            child: Text(
                              this.cepResto,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32.0,
                                  color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Center(
                    child: RaisedButton(
                      onPressed: () => this.submit(),
                      color: Colors.lightBlue,
                      child: Text(
                        this.btnTry,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      this.msg,
                      style: TextStyle(color: Colors.red[400]),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        // left: 40.0,
                        top: 40.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Logradouro: ${this.logradouro}',
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                          Text(
                            'Cidade: ${this.cidade}',
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                          Text(
                            'Estado: ${this.estado}',
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'Status: ${this.status}',
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                          // Text(
                          //   'Pontuação: ${this.pontuacao}',
                          //   style: TextStyle(
                          //       color: Colors.black87,
                          //       fontWeight: FontWeight.bold,
                          //       fontSize: 18.0),
                          // ),
                          Text(
                            'Tentativas: ${this.tentativas.toString()}',
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
