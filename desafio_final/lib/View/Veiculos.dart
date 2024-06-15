import 'package:flutter/material.dart';
import 'Cadastro_veiculos.dart';

class VeiculosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Veículos', style: TextStyle(color: Colors.black)),
      ),
      body: Stack(
        children: [
          Center(
            child: Text('Listagem de Veículos'),
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
                    MaterialPageRoute(builder: (context) => CadastroVeiculosScreen()),
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

