import 'package:flutter/material.dart';
import 'Cadastro.dart';
import 'Login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Usuário',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserRegistrationScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
