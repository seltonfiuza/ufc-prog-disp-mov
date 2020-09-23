import 'package:flutter/material.dart';
import 'package:trab_03/screens/BeforeCreate.dart';
import 'package:trab_03/screens/Created.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    createGame() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BeforeCreate(),
        ),
      );
    }

    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () => createGame(),
                  color: Colors.blue[700],
                  child: Text(
                    'Criar um jogo',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.blue[700],
                  onPressed: () => null,
                  child: Text(
                    'Entrar em um jogo',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
