import 'package:flutter/material.dart';
import 'package:trab_02/screens/Home.dart';
import 'package:trab_02/services/auth.dart';

class LoginPage extends StatefulWidget {
  final auth = Auth();
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isSwitched = true;
  @override
  Widget build(BuildContext context) {
    String _errorMessage, _email, _password;
    bool _isLoading = false;
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

    submit(_email, password) async {
      if (await widget.auth.setLogged(_email, password, isSwitched)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // retorna um objeto do tipo Dialog
            return AlertDialog(
              title: new Text("Alert Dialog titulo"),
              content: new Text("Alert Dialog body"),
              actions: <Widget>[
                // define os botões na base do dialogo
                new FlatButton(
                  child: new Text("Fechar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }

    final mailField = TextField(
      keyboardType: TextInputType.emailAddress,
      maxLines: 1,
      onChanged: (value) => _email = value.trim(),
      decoration: InputDecoration(
        icon: Icon(
          Icons.mail,
          color: Colors.blue[800],
        ),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
        labelText: 'Email',
      ),
      style: new TextStyle(
        fontSize: 18.0,
        height: 1.0,
      ),
    );

    final passField = TextField(
      maxLines: 1,
      obscureText: true,
      onChanged: (value) => _password = value.trim(),
      decoration: InputDecoration(
        icon: new Icon(
          Icons.lock,
          color: Colors.blue[800],
        ),
        border: OutlineInputBorder(),
        labelText: 'Password',
      ),
      style: new TextStyle(
        fontSize: 18.0,
        height: 1.0,
      ),
    );

    final btnField = RaisedButton(
      elevation: 5.0,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0)),
      color: Colors.blue[800],
      child: new Text('Login',
          style: new TextStyle(fontSize: 22.0, color: Colors.white)),
      onPressed: () => submit(_email, _password),
    );

    Widget _showCircularProgress() {
      if (_isLoading) {
        return Center(child: CircularProgressIndicator());
      }
      return Container(
        height: 0.0,
        width: 0.0,
      );
    }

    Widget showErrorMessage() {
      if (_errorMessage != null) {
        return new Text(
          _errorMessage,
          style: TextStyle(
              fontSize: 13.0,
              color: Colors.red,
              height: 1.0,
              fontWeight: FontWeight.w300),
        );
      } else {
        return new Container(
          height: 0.0,
        );
      }
    }

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(top: 50.0, left: 50.0, right: 50.0),
          color: Colors.white24,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // Image(
                //     image: AssetImage("assets/delfosim_logo.png"),
                //     height: 200.0),
                Column(
                  children: <Widget>[
                    mailField,
                    SizedBox(height: 10.0),
                    passField,
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Manter Logado?",
                          style: TextStyle(
                            fontSize: 16,
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
                    btnField,
                    // SizedBox(height: 18.0),
                    showErrorMessage(),
                    _showCircularProgress()
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
