import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:get_ip/get_ip.dart';

SocketServerState pageState;

class SocketServer extends StatefulWidget {
  @override
  SocketServerState createState() {
    pageState = SocketServerState();
    return pageState;
  }
}

class SocketServerState extends State<SocketServer> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<MessageItem> items = List<MessageItem>();

  String localIP = "";

  ServerSocket serverSocket;
  Socket clientSocket;
  int port = 9000;

  TextEditingController msgCon = TextEditingController();

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
  final number = TextEditingController();

  @override
  void dispose() {
    stopServer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getIP();
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          !this.connected
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
                  onPressed: this.isEnabled ? () => this.startServer() : null,
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
          : Padding(
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
                          "${this.localIP}:${this.port}",
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
                        onPressed: () => this.submitMessage(),
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
          // ipInfoArea(),
          // messageListArea(),
          // submitArea(),
        ],
      ),
    );
  }

  Widget ipInfoArea() {
    return Card(
      child: ListTile(
        dense: true,
        leading: Text("IP"),
        title: Text(localIP),
        trailing: RaisedButton(
          child: Text((serverSocket == null) ? "Start" : "Stop"),
          onPressed: (serverSocket == null) ? startServer : stopServer,
        ),
      ),
    );
  }

  Widget messageListArea() {
    return Expanded(
      child: ListView.builder(
          reverse: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            MessageItem item = items[index];
            return Container(
              alignment: (item.owner == localIP)
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: (item.owner == localIP)
                        ? Colors.blue[100]
                        : Colors.grey[200]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      (item.owner == localIP) ? "Server" : "Client",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      item.content,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget submitArea() {
    return Card(
      child: ListTile(
        title: TextField(
          controller: msgCon,
        ),
        trailing: IconButton(
          icon: Icon(Icons.send),
          color: Colors.blue,
          disabledColor: Colors.grey,
          onPressed: (clientSocket != null) ? submitMessage : null,
        ),
      ),
    );
  }

  void getIP() async {
    var ip = await GetIp.ipAddress;
    setState(() {
      localIP = ip;
    });
  }

  void startServer() async {
    setState(() {
      btnColor = Colors.grey;
      isEnabled = false;
      btnText = 'Esperando outro jogador conectar';
      msgEmbaixoDoBtn = "${localIP}:${port}";
    });
    print(serverSocket);
    serverSocket =
        await ServerSocket.bind(InternetAddress.anyIPv4, port, shared: true);
    print(serverSocket);
    serverSocket.listen(handleClient);
  }

  void handleClient(Socket client) {
    clientSocket = client;

    showSnackBarWithKey(
        "A new client has connected from ${clientSocket.remoteAddress.address}:${clientSocket.remotePort}");
    setState(() {
      
          connected = true;
          countPlayers = 2;
    });
    clientSocket.listen(
      (onData) {
        print(String.fromCharCodes(onData).trim());
        setState(() {
          items.insert(
              0,
              MessageItem(clientSocket.remoteAddress.address,
                  String.fromCharCodes(onData).trim()));
        });
      },
      onError: (e) {
        showSnackBarWithKey(e.toString());
        disconnectClient();
      },
      onDone: () {
        showSnackBarWithKey("Connection has terminated.");
        disconnectClient();
      },
    );
  }

  void stopServer() {
    disconnectClient();
    serverSocket.close();
    setState(() {
      serverSocket = null;
    });
  }

  void disconnectClient() {
    if (clientSocket != null) {
      clientSocket.close();
      clientSocket.destroy();
    }

    setState(() {
      clientSocket = null;
    });
  }

  void submitMessage() async {
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
    setState(() {
      items.insert(0, MessageItem(localIP, cep));
    });
    sendMessage(msgCon.text);
    msgCon.clear();
  }

  void sendMessage(String message) {
    clientSocket.write("$message\n");
  }

  showSnackBarWithKey(String message) {
    scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'Done',
          onPressed: () {},
        ),
      ));
  }
}

class MessageItem {
  String owner;
  String content;

  MessageItem(this.owner, this.content);
}
