import 'dart:io';
import 'package:flutter/material.dart';
import '../Model/Database.dart';
import '../Model/Veiculo.dart';
import 'Cadastro_veiculos.dart';

class VeiculosScreen extends StatefulWidget {
  @override
  _VeiculosScreenState createState() => _VeiculosScreenState();
}

class _VeiculosScreenState extends State<VeiculosScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Veiculo>> _fetchVeiculos() async {
    return await _dbHelper.getVeiculos();
  }

  void _deleteVeiculo(String placa) async {
    await _dbHelper.deleteVeiculo(placa);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Veículos', style: TextStyle(color: Colors.black)),
      ),
      body: FutureBuilder<List<Veiculo>>(
        future: _fetchVeiculos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os veículos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum veículo cadastrado'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final veiculo = snapshot.data![index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                        child: veiculo.imagemPath != null
                            ? Image.file(
                          File(veiculo.imagemPath!),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                            : Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Marca: ${veiculo.marca}',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8.0),
                            Text('Modelo: ${veiculo.modelo}'),
                            SizedBox(height: 8.0),
                            Text('Placa: ${veiculo.placa}'),
                            SizedBox(height: 8.0),
                            Text('Ano de Fabricação: ${veiculo.anoFabricacao}'),
                            SizedBox(height: 8.0),
                            Text('Custo: ${veiculo.custo}'),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Deseja deletar veículo?'),
                                content: Text('Tem certeza que deseja deletar o veículo de placa ${veiculo.placa}?'),
                                actions: [
                                  TextButton(
                                    child: Text('Não'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Sim'),
                                    onPressed: () {
                                      _deleteVeiculo(veiculo.placa);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? veiculoCadastrado = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CadastroVeiculosScreen()),
          );
          if (veiculoCadastrado == true) {
            setState(() {});
          }
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
