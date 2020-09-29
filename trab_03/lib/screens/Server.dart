import 'dart:io';

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
      appBar: AppBar(title: Text("Socket Server")),
      body: Column(
        children: <Widget>[
          ipInfoArea(),
          messageListArea(),
          submitArea(),
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

  void submitMessage() {
    if (msgCon.text.isEmpty) return;
    setState(() {
      items.insert(0, MessageItem(localIP, msgCon.text));
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
