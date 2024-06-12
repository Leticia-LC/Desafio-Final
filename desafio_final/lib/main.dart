import 'package:flutter/material.dart';
import 'View/Cadastro.dart';
import 'View/Login.dart';

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
      initialRoute: '/login',
      routes: {
        '/cadastro': (context) => UserRegistrationScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}