import 'package:flutter/material.dart';
import 'package:trab_02/main.dart';
import 'package:trab_02/screens/widgets/List.dart';
import 'package:trab_02/services/auth.dart';

class HomePage extends StatefulWidget {
  final List<ListItem> items = List<ListItem>.generate(
    5,
    (i) => MessageItem("Sender $i", "Message body $i"),
  );
  final auth = Auth();
  final PageRouteBuilder _rootRoute = new PageRouteBuilder(
    pageBuilder: (BuildContext context, _, __) {
      return Root();
    },
  );

  @override
  HomePageState createState() => HomePageState();
}

bool isSwitched = true;

class HomePageState extends State<HomePage> {
  keepLogged(value) {
    setState(() {
      isSwitched = value;
    });
    if (!value) {
      widget.auth.clear();
    } else {
      widget.auth.setLogged('', '', value);
    }
  }

  logout() {
    widget.auth.clear();
    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage('assets/man.png'),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Manter Logado?",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Switch(
                            value: isSwitched,
                            onChanged: (value) => keepLogged(value),
                            activeTrackColor: Colors.blue,
                            activeColor: Colors.blue[800],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 200,
                        child: RaisedButton(
                          onPressed: () => logout(),
                          color: Colors.blue[800],
                          child: const Text(
                            'Sair',
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        appBar: AppBar(
          title: Text("Five Contacts"),
          backgroundColor: Colors.blue[800],
          // automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.white,
        body: ListView.builder(
          // Let the ListView know how many items it needs to build.
          itemCount: widget.items.length,
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            final item = widget.items[index];
            return ListTile(
              title: item.buildTitle(context),
              subtitle: item.buildSubtitle(context),
            );
          },
        ),
      ),
    );
  }
}

keepLogged() {}
