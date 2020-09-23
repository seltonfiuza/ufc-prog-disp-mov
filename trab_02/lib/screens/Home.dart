import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trab_02/models/FiveContacts.dart';
import 'package:trab_02/screens/widgets/Contacts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

// import 'package:trab_02/screens/widgets/Contacts.dart';
import 'package:flutter_contact/contacts.dart';

class HomePage extends StatefulWidget {
  var auth;
  FiveContactsList fiveContactsList;
  HomePage({Key key, this.auth}) : super(key: key);
  @override
  HomePageState createState() => HomePageState();
}

bool isSwitched = true;

class HomePageState extends State<HomePage> {
  List<bool> _selected;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  List _listViewData = [];

  @override
  void initState() {
    widget.auth.getLoggedIn();
    super.initState();
    isPermited();
  }

  Widget homePageWidget = Text("");
  keepLogged(value) {
    setState(() {
      isSwitched = value;
    });
    widget.auth.saveListWithNewKeep(widget.auth.user, value);
  }

  requestPhonePermission() async {}

  isPermited() async {
    // await Permission.contacts.request();
    if (await Permission.contacts.request().isGranted) {
      if (widget.auth.user != null) {
        if (widget.auth.user.fiveContacts != null) {
          if (widget.auth.user.fiveContacts.length != 0) {
            print(widget.auth.user.fiveContacts[0].toJson());
            setState(() {
              homePageWidget = ListView.builder(
                itemCount: widget.auth.user.fiveContacts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListTile(
                              // onTap: () => tap(index),
                              title: Text(
                                  widget.auth.user.fiveContacts[index].name)
                              // title: Text(''),
                              // subtitle: Text(
                              //   (widget.auth.user.fiveContacts[index].number
                              //       .toString()),
                              ),
                        ),
                        IconButton(
                          icon: Icon(Icons.phone),
                          color: Colors.blue[800],
                          onPressed: () => callDialogContact(
                              widget.auth.user.fiveContacts[index].number),
                        )
                      ],
                    ),
                  );
                },
              );
            });
          }
        }
      }
      await Contacts.streamContacts().forEach((contact) {
        // print("${contact.displayName}");
        if (contact.displayName.toString() != 'null' &&
            contact.phones.length != 0) {
          _listViewData.add(contact);
        }
      });
      _selected = List.generate(_listViewData.length - 1, (i) => false);
    }
  }

  logout() {
    widget.auth.saveListWithNewKeep(widget.auth.user, false);
    print(widget.auth.user.toJson().toString());
    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
  }

  makeCall(phone) async {
    if (await Permission.phone.request().isGranted) {
      await FlutterPhoneDirectCaller.callNumber(phone);
    } else {
      launch('tel://${phone}');
    }
  }

  callDialogContact(phones) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 400,
            child: ListView.builder(
                itemCount: phones.length,
                itemBuilder: (BuildContext buildContext, int index) => Column(
                      children: [
                        Container(
                          child: ListTile(
                            onTap: () => makeCall(phones[index]),
                            title: Text(phones[index]),
                          ),
                        ),
                        index != phones.length - 1
                            ? SizedBox(
                                height: 2,
                                child: Container(
                                  color: Colors.black,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                shrinkWrap: true),
          ),
        );
      },
    );
  }

  updateHomeUsers(listContacts) {
    var _contacts = [];
    var _contact;
    widget.auth.resetContactList();
    listContacts.forEach((index) => {
          _contact = FiveContactsList(
              name: _listViewData[index].displayName,
              number: _listViewData[index].phones),
          _contact = widget.auth.addContactList(_contact),
          _contacts.add(_contact)
        });
    setState(() {
      homePageWidget = ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ListTile(
                    // onTap: () => tap(index),
                    title: Text(_contacts[0][index].name),
                    // title: Text(''),
                    // subtitle: Text(
                    //   (_contacts[0][index].number.toString()),
                    // ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.phone),
                  color: Colors.blue[800],
                  onPressed: () =>
                      callDialogContact(_contacts[0][index].number),
                )
              ],
            ),
          );
        },
      );
      widget.auth.saveOnDevice();
      // print(widget.auth.listuser.toJson().toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
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
                  Column(
                    children: [
                      Text(
                        'Olá, ${widget.auth.user != null ? widget.auth.user.name : "ops"}',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CircleAvatar(
                        radius: 100,
                        backgroundImage: AssetImage('assets/man.png'),
                      ),
                    ],
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
                              // fontWeight: FontWeight.bold,
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
        ),
        backgroundColor: Colors.white,
        body: homePageWidget,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ContactsWidget(selected: _selected, data: _listViewData);
              },
            ).then((val) => updateHomeUsers(val));
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue[800],
        ),
      ),
    );
  }
}
