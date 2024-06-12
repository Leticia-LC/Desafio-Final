import 'package:flutter/material.dart';

class VeiculosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Veículos'),
      ),
      body: Center(
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: VeiculosScreen(),
  ));
}
