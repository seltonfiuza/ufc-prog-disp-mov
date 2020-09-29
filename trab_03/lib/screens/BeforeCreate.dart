import 'package:flutter/material.dart';
import 'package:get_ip/get_ip.dart';
import 'package:dio/dio.dart';

import 'package:socket_io/socket_io.dart';

class BeforeCreate extends StatefulWidget {
  @override
  _BeforeCreateState createState() => _BeforeCreateState();
}

class _BeforeCreateState extends State<BeforeCreate> {
  final number = TextEditingController();
  var io = new Server();
  var ipAddress;
  var port = 3000;
  var connected = false;
  var isEnabled = true;
  var btnColor = Colors.lightBlue;
  final number2 = TextEditingController();
  int countPlayers, tentativas = 0;
  String logradouro, cidade, estado, pontuacao, status = '-';
  String msgEmbaixoDoBtn = '';
  final dio = Dio();
  var msg = '';
  final url = 'https://viacep.com.br/cep/json/';
  var cepResto = "750-650";
  var btnText = 'Criar';

  @override
  void initState() {
    getIp();
    super.initState();
  }

  getIp() async {
    var ip = await GetIp.ipAddress;
    this.setState(() {
      ipAddress = ip;
    });
  }

  @override
  dispose() {
    io.close();
  }

  initServer() {
    setState(() {
      btnColor = Colors.grey;
      isEnabled = false;
      btnText = 'Esperando outro jogador conectar';
      msgEmbaixoDoBtn = "${ipAddress}:${port}";
    });
    io.on('connection', (client) {
      setState(() {
        connected = true;
        countPlayers = 2;
      });
      // print('connection default namespace');
      // client.on('msg', (data) {
      //   print('data from default => $data');
      //   client.emit('fromServer', "ok");
      // });
    });
    io.on('disconnect', (client) {
      setState(() {
        connected = false;
        countPlayers = 1;
      });
    });
    io.listen(3000);
  }

  submit() async {
    var cep = number2.text + cepResto.replaceAll('-', '');
    try {
      Response response =
          await dio.get('https://viacep.com.br/ws/${cep}/json/');
      print(response.data);
      var data = response.data;
      io.emit('msg', cep);
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
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: !this.connected
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: 200,
                    child: TextField(
                      controller: this.number,
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
                ),
                RaisedButton(
                  onPressed: this.isEnabled ? () => this.initServer() : null,
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
            )
          : Scaffold(
              resizeToAvoidBottomPadding: false,
              body: Padding(
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
                          style:
                              TextStyle(color: Colors.teal[800], fontSize: 36),
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
                          "Try",
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
            ),
    );
  }
}
