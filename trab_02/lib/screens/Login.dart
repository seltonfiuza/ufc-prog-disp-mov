import 'package:flutter/material.dart';
import 'package:trab_02/screens/Home.dart';
import 'package:trab_02/screens/Register.dart';
import 'package:trab_02/services/auth.dart';

class LoginPage extends StatefulWidget {
  var auth;
  LoginPage({Key key, this.auth}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isSwitched = true;
  String _errorMessage, _email, _password;
  @override
  void initState() {
    widget.auth.getLoggedIn();
    if (widget.auth.listuser.userlist != null) {
      print(widget.auth.listuser.userlist.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    submit(_email, password) async {
      if (await widget.auth.login(_email, password, isSwitched)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(auth: widget.auth),
            ),
          );
        });
      } else {
        setState(() {
          _errorMessage = 'User not exist or password mismatch';
        });
      }
    }

    final mailField = TextField(
      keyboardType: TextInputType.emailAddress,
      maxLines: 1,
      onChanged: (value) => this.setState(() {
        _email = value.trim();
      }),
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
      onChanged: (value) => this.setState(() {
        _password = value.trim();
      }),
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

    btnField(text, callback, email, pass) {
      return RaisedButton(
        elevation: 5.0,
        hoverElevation: 50,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0)),
        color: Colors.blue[800],
        child: new Text(text,
            style: new TextStyle(fontSize: 22.0, color: Colors.white)),
        onPressed: () => callback(email, pass),
      );
    }

    goToRegister(email, pass) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterPage(
            email: email,
            auth: widget.auth,
          ),
        ),
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

    keepLogged(value) {}
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
                    mailField,
                    SizedBox(height: 10.0),
                    passField,
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        btnField(
                          'Login',
                          submit,
                          _email,
                          _password,
                        ),
                        btnField(
                          'Cadastro',
                          goToRegister,
                          _email,
                          _password,
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
