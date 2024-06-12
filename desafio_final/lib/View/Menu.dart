import 'package:flutter/material.dart';
import '../Model/Usuario.dart';
import 'Alugueis.dart';
import 'Clientes.dart';
import 'Gerentes.dart';
import 'Perfil.dart';
import 'Veiculos.dart';

class MenuScreen extends StatelessWidget {
  final Usuario usuario;

  MenuScreen({required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Menu', style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(usuario: usuario),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Text('Perfil'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClientesScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 90, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Text('Clientes'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GerentesScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 90, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Text('Gerentes'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VeiculosScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 90, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Text('Veículos'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlugueisScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 90, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Text('Aluguéis'),
            ),
          ],
        ),
      ),
    );
  }
}



