import 'package:flutter/material.dart';
import 'package:trab_02/models/FiveContacts.dart';
import 'package:trab_02/screens/Home.dart';
import 'package:trab_02/services/auth.dart';
import 'package:string_validator/string_validator.dart';

class RegisterPage extends StatefulWidget {
  String email;
  var auth;

  RegisterPage({Key key, this.email, this.auth}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isSwitched = true;
  void initState() {
    widget.auth.getLoggedIn();
  }

  String _errorMessage, _password, _name;

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

  @override
  Widget build(BuildContext context) {
    // auth.getLoggedIn();
    final mailField = TextFormField(
      initialValue: widget.email,
      keyboardType: TextInputType.emailAddress,
      maxLines: 1,
      onChanged: (value) => {
        this.setState(() {
          widget.email = value.trim();
        })
      },
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

    keepLogged(value) async {
      isSwitched = value;
    }

    register() async {
      print(_name);
      print(_password);
      print(widget.email);
      var regex =
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
      bool emailValid = RegExp(regex).hasMatch(widget.email);
      print(!isNumeric(_name));
      print(!emailValid);
      if (!isNumeric(_name) && emailValid) {
        var user = FiveContacts(
          keepLogged: isSwitched,
          name: _name[0].toUpperCase() + _name.substring(1),
          email: widget.email,
          pass: _password,
        );
        var done = await widget.auth.addNewUser(user);
        if (!done) {
          this.setState(() {
            _errorMessage = "Email alreay registered";
          });
          return false;
        }
        print('Register, 65, ${widget.auth.user}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              auth: widget.auth,
            ),
          ),
        );
      } else {
        this.setState(() {
          _errorMessage = 'Not valid username or email';
        });
      }
    }

    final passField = TextField(
      maxLines: 1,
      obscureText: true,
      onChanged: (value) => {
        this.setState(() {
          _password = value.trim();
        })
      },
      decoration: InputDecoration(
        icon: new Icon(
          Icons.lock,
          color: Colors.blue[800],
        ),
        border: OutlineInputBorder(),
        labelText: 'Senha',
      ),
      style: new TextStyle(
        fontSize: 18.0,
        height: 1.0,
      ),
    );
    final nameField = TextField(
      maxLines: 1,
      onChanged: (value) => {
        this.setState(() {
          _name = value.trim();
        })
      },
      decoration: InputDecoration(
        icon: new Icon(
          Icons.lock,
          color: Colors.blue[800],
        ),
        border: OutlineInputBorder(),
        labelText: 'Nome',
      ),
      style: new TextStyle(
        fontSize: 18.0,
        height: 1.0,
      ),
    );
    btnField(text) {
      return RaisedButton(
        elevation: 5.0,
        hoverElevation: 50,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0)),
        color: Colors.blue[800],
        child: new Text(text,
            style: new TextStyle(fontSize: 22.0, color: Colors.white)),
        onPressed: () => register(),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(top: 0.0, left: 50.0, right: 50.0),
          color: Colors.white24,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage('assets/logo.png'),
                ),
                Column(
                  children: <Widget>[
                    nameField,
                    SizedBox(height: 10.0),
                    mailField,
                    SizedBox(height: 10.0),
                    passField,
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        btnField(
                          'Cadastrar e entrar',
                        ),
                      ],
                    ),
                    // SizedBox(height: 18.0),
                    showErrorMessage(),
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
