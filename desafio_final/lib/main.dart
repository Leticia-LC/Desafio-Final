import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Controller/Theme_provider.dart';
import 'View/Login.dart';
import 'View/Register.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Cadastro de Usuário',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeProvider.themeMode,
          initialRoute: '/login',
          routes: {
            '/register': (context) => UserRegistrationScreen(),
            '/login': (context) => LoginScreen(),
          },
        );
      },
    );
  }
}
