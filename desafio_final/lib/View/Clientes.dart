import 'package:flutter/material.dart';
import 'cadastro_clientes.dart';

class ClientesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Clientes', style: TextStyle(color: Colors.black)),
      ),
      body: Stack(
        children: [
          Center(
            child: Text('Listagem de Clientes'),
          ),
          Positioned(
            bottom: 60,
            right: 30,
            child: Container(
              width: 70,
              height: 70,
              child: FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CadastroClientesScreen()),
                  );
                },
                backgroundColor: Colors.red,
                child: Icon(Icons.add, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
