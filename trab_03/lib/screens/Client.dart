import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:get_ip/get_ip.dart';
import 'package:shared_preferences/shared_preferences.dart';

SocketClientState pageState;

class SocketClient extends StatefulWidget {
  @override
  SocketClientState createState() {
    pageState = SocketClientState();
    return pageState;
  }
}

class SocketClientState extends State<SocketClient> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String localIP = "";
  int port = 9000;
  List<MessageItem> items = List<MessageItem>();

  TextEditingController ipCon = TextEditingController();
  TextEditingController msgCon = TextEditingController();

  Socket clientSocket;

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
final ipController = TextEditingController();
  final portController = TextEditingController();
  final cepController = TextEditingController();
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
  void initState() {
    super.initState();
    getIP();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadServerIP();
    });
  }

  @override
  void dispose() {
    disconnectFromServer();
    super.dispose();
  }

  void getIP() async {
    var ip = await GetIp.ipAddress;
    setState(() {
      localIP = ip;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomPadding: false,
        // appBar: AppBar(title: Text("Socket Client")),
        body: Column(
          children: <Widget>[
            !this.connected
          ?  Column(
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
                  onPressed: this.isEnabled ? () => connectToServer() : null,
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
          :  Padding(
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
                          "${this.ipController.text}:${this.port}",
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
            // ipInfoArea(),
            // connectArea(),
            // messageListArea(),
            // submitArea(),
          ],
        ));
  }

  Widget ipInfoArea() {
    return Card(
      child: ListTile(
        dense: true,
        leading: Text("IP"),
        title: Text(localIP),
      ),
    );
  }

  Widget connectArea() {
    return Card(
      child: ListTile(
        dense: true,
        leading: Text("Server IP"),
        title: TextField(
          controller: ipCon,
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              isDense: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(color: Colors.grey[300]),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(color: Colors.grey[400]),
              ),
              filled: true,
              fillColor: Colors.grey[50]),
        ),
        trailing: RaisedButton(
          child: Text((clientSocket != null) ? "Disconnect" : "Connect"),
          onPressed:
              (clientSocket != null) ? disconnectFromServer : connectToServer,
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
                      (item.owner == localIP) ? "Client" : "Server",
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

  void connectToServer() async {
    print("Destination Address: ${this.ipController.text}");
    _storeServerIP();

    Socket.connect(this.ipController.text, 9000, timeout: Duration(seconds: 5))
        .then((socket) {
      setState(() {
        connected = true;
        countPlayers = 2;
        clientSocket = socket;
      });

      showSnackBarWithKey(
          "Connected to ${socket.remoteAddress.address}:${socket.remotePort}");
      socket.listen(
        (onData) {
          print(String.fromCharCodes(onData).trim());
          setState(() {
            items.insert(
                0,
                MessageItem(clientSocket.remoteAddress.address,
                    String.fromCharCodes(onData).trim()));
          });
        },
        onDone: onDone,
        onError: onError,
      );
    }).catchError((e) {
      showSnackBarWithKey(e.toString());
    });
  }

  void onDone() {
    showSnackBarWithKey("Connection has terminated.");
    disconnectFromServer();
  }

  void onError(e) {
    print("onError: $e");
    showSnackBarWithKey(e.toString());
    disconnectFromServer();
  }

  void disconnectFromServer() {
    print("disconnectFromServer");

    clientSocket.close();
    setState(() {
      clientSocket = null;
    });
  }

  void sendMessage(String message) {
    clientSocket.write("$message\n");
  }

  void _storeServerIP() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("serverIP", ipCon.text);
  }

  void _loadServerIP() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      ipCon.text = sp.getString("serverIP");
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
      items.insert(0, MessageItem(localIP, msgCon.text));
    });
    sendMessage(msgCon.text);
    msgCon.clear();
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
