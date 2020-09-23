import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class CreatedPage extends StatefulWidget {
  final ip, port;
  CreatedPage({Key key, this.ip, this.port}) : super(key: key);

  @override
  _CreatedPageState createState() => _CreatedPageState();
}

class _CreatedPageState extends State<CreatedPage> {
  final number = TextEditingController();
  int countPlayers, tentativas = 0;
  String logradouro, cidade, estado, pontuacao, status = '';
  final dio = Dio();
  var msg = '';
  final url = 'https://viacep.com.br/cep/json/';
  var cepResto = "750-650";

  submit() async {
    var cep = number.text + cepResto.replaceAll('-', '');
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
    return SafeArea(
      child: Scaffold(
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
                    "${widget.ip}:${widget.port}",
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
                            controller: this.number,
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
