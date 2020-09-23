import 'package:flutter/material.dart';
import 'package:trab_03/screens/Created.dart';

import 'package:socket_io/socket_io.dart';

class BeforeCreate extends StatefulWidget {
  @override
  _BeforeCreateState createState() => _BeforeCreateState();
}

class _BeforeCreateState extends State<BeforeCreate> {
  final number = TextEditingController();

  initServer() {
    var io = new Server();
    var nsp = io.of('/some');
    nsp.on('connection', (Socket client) {
      print('connection /some');
      client.on('msg', (data) {
        print('data from /some => $data');
        client.emit('fromServer', "ok 2");
      });
    });
    io.on('connection', (Socket client) {
      print('connection default namespace');
      client.on('msg', (data) {
        print('data from default => $data');
        client.emit('fromServer', "ok");
      });
    });
    io.listen(3000);
  }

  createGame() {
    Map conf = {
      "ip": '192.168.1.15',
      "port": '18494',
    };
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatedPage(
          ip: conf['ip'],
          port: conf['port'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
            onPressed: () => this.createGame(),
            color: Colors.lightBlue,
            child: Text(
              "Criar",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
